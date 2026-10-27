# Proposal

## Why

`0001`–`0008` 的代码从未在 macOS 上真实编译过（`docs/verify/` 下无任何报告，`openspec/changes/archive/` 为空）。首次执行 `scripts/verify.sh` 时暴露两类问题，使验证链路完全无法启动：

1. **编译错误**：App target 有 4 处 Swift 编译失败，`BizScanCore` 有 1 处（`String.containsCJK` 不存在）。任一存在都导致 `xcodebuild test` 无法产出结果。
2. **验证工具链缺陷**：`xcodegen generate --project BizScan.xcodeproj` 的用法错误（`--project` 表示输出目录，会在 `BizScan.xcodeproj/` 内再生成一层同名工程）；默认 destination 指向本机不存在的 `iPhone 15`。

这些问题不是行为缺陷，而是「从未被编译」这一事实的产物。必须单独成 change 记录，否则验证证据无法追溯到具体修复。

## What Changes

- 修复 `FieldParser` 中 2 处 `keyword.containsCJK` → `containsCJK(keyword)`（该函数为文件级私有函数，非 `String` 扩展）。
- 修复 `PhotoLibraryService`、`ScannerViewModel` 缺少 `import SwiftUI`（`PhotosPickerItem` 由 SwiftUI 的 cross-import overlay 提供）。
- 修复 `BizScanApp` 演示数据中 `BusinessCard` 初始化参数顺序（`tags` 必须在 `notes` 之前）。
- 修复 `DetailViewModel` 中 2 处闭包省略参数名（`{ .caseInsensitiveCompare(...) }` → `{ $0.caseInsensitiveCompare(...) }`）。
- 修正 `xcodegen generate` 调用方式：`scripts/verify.sh`、`Makefile`、`.github/workflows/ios.yml`。
- 修正默认 destination 为 `iPhone 16, OS=18.0`（本机可用，CI runner 亦有对应镜像）。

不包含：任何行为变更、任何新需求、任何测试断言调整。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

无。本 change 不改变任何行为合同，仅使既有代码可编译、使验证入口可执行。

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/FieldParser.swift`、`BizScan/Services/PhotoLibraryService.swift`、`BizScan/ViewModels/ScannerViewModel.swift`、`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/App/BizScanApp.swift`
- 工程：`scripts/verify.sh`、`Makefile`、`.github/workflows/ios.yml`
- 测试：无新增、无修改
- 数据：无

## 追溯说明

本 change 的改动在 `openspec` CLI 不可用的环境下完成（`openspec` 命令未安装），因此提案与实现阶段未执行 `openspec validate`；该偏差曾登记为 D1。后续已安装 OpenSpec CLI 1.14.3 并补跑：

```
openspec validate 0010-toolchain-compile-fixes --strict
→ Change '0010-toolchain-compile-fixes' is valid
```

D1 已关闭，结果记录于 `docs/verify/0010-toolchain-compile-fixes.md`。
