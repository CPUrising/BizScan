# Design

## Context

见 `proposal.md`。本 change 不引入新逻辑，只处理「首次编译」这一事实暴露出的既有缺陷。设计重点是：如何把这些修复限制在最小范围，使其不掩盖任何行为问题。

## Goals / Non-Goals

**Goals:**

- 让 `xcodebuild build` 与 `xcodebuild test` 能在本机跑通编译阶段。
- 让 `scripts/verify.sh` 的 `xcodegen generate` 真正生成单层 `BizScan.xcodeproj`。
- 每一项修复都能对应到一条真实编译错误，不做预防性重构。

**Non-Goals:**

- 不修复测试失败（测试结果属于后续验证，由各 change 的 Verify 阶段处理）。
- 不改动任何 ViewModel 的公开方法签名。
- 不升级 Swift 语言版本或部署目标。

## Decisions

1. **`containsCJK` 按文件级函数修复，而非加 `String` 扩展**
   - 现状：`FieldParser.swift` 第 401 行已有 `private func containsCJK(_ text: String) -> Bool`，第 134 行也正确使用。
   - 第 264、273 行误写为 `keyword.containsCJK`（成员访问）。
   - 选择：改为 `containsCJK(keyword)`，与同文件既有用法一致。
   - 备选（被否）：新增 `String` 扩展 `var containsCJK`。理由：会引入第二个等价实现，且 `private` 函数的存在说明原作者意图是文件级工具函数。

2. **`import SwiftUI` 而非 `import PhotosUI` 的替代**
   - 现状：`PhotosPickerItem` 定义在 `PhotosUI` 中，但其跨框架 overlay 依赖 SwiftUI 的 `Transferable` 支持。
   - 现象：仅 `import PhotosUI` 时 `PhotosPickerItem` 无法解析。
   - 选择：显式补 `import SwiftUI`。
   - 备选（被否）：改用 `UIImagePickerController`。理由：会改变既有交互实现，超出本 change 范围。

3. **`tags` / `notes` 参数顺序修正，而非修改 `BusinessCard` 的成员顺序**
   - 现状：`BusinessCard` 的 `memberwise init` 由属性声明顺序决定，`tags` 在 `notes` 之前。
   - 选择：调整调用点（`BizScanApp.swift` 演示数据）。
   - 备选（被否）：调整 `BusinessCard` 属性顺序。理由：`BusinessCard` 属于 `BizScanCore` 公开模型，改顺序会影响其他调用点与 Codable 键序假设。

4. **`xcodegen generate` 去掉 `--project` 参数**
   - 现状：`--project` 语义是「输出目录」，传入 `BizScan.xcodeproj` 会生成 `BizScan.xcodeproj/BizScan.xcodeproj`。
   - 选择：直接 `xcodegen generate`，读取根目录 `project.yml`，在当前目录生成 `BizScan.xcodeproj`。
   - 影响面：`scripts/verify.sh`、`Makefile`、`.github/workflows/ios.yml` 三处必须同时改，否则三者行为不一致。

5. **默认 destination 改为 `iPhone 16, OS=18.0`**
   - 现状：`iPhone 15` 在本机模拟器列表中不存在（本机仅有 iOS 18.0 / 18.1 / 26.0 / 26.1 runtime，且 18.x 下无 iPhone 15）。
   - 选择：改为 `iPhone 16, OS=18.0`，与项目部署目标 iOS 17 兼容，且 18.0 runtime 在本机与 CI 均可用。
   - 保留 `DESTINATION` 环境变量覆盖能力，便于后续切换到 iOS 26.x 或真机。

## Risks / Trade-offs

- [iPhone 16 / iOS 18.0 在 GitHub Actions 镜像中可能不存在] → CI 若失败，改用 `OS=latest` 或矩阵；本 change 先保证本机可跑通。
- [`import SwiftUI` 增加了 `PhotoLibraryService` 的框架依赖] → 该类已依赖 UIKit 与 PhotosUI，SwiftUI 不构成新的部署成本。
- [修复编译错误后可能暴露测试失败] → 属预期：编译通过是测试可执行的前提，测试结果由各 change 的 Verify 阶段单独记录。
- [未执行 `openspec validate`] → `openspec` CLI 未安装（曾登记为偏差 D1）。已补装 OpenSpec CLI 1.14.3 并 `--strict` 校验通过，D1 已关闭。

## Migration Plan

无数据迁移。无 API 变更。

## Open Questions

- CI runner 的 Xcode 镜像具体包含哪些 simulator runtime？需在首次 CI 运行后确认并回填 `docs/reference-env.md`。
