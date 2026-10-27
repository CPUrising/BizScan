# Design

## Context

见 `proposal.md`。当前约束：

- 开发机为 Windows，无法执行 `xcodebuild`；验证只能在 macOS 或 GitHub Actions 完成（见 `README.md` 第 7 节）。
- 最低 iOS 17，可使用 SwiftData 与 Observation。
- 主规范已存在，本 change 不改变行为合同，因此 `.openspec.yaml` 标记 `skip_specs: true`。

## Goals / Non-Goals

**Goals:**

- 让 UI 只依赖协议，不直接接触 SwiftData、Vision、AVFoundation。
- 让核心数据与解析逻辑可在 Windows 用 `swift test` 验证（后续阶段收益）。
- 名片图像的持久化对"容器路径变化"免疫。

**Non-Goals:**

- 不实现相机、检测、OCR、字段解析。
- 不引入第三方依赖。
- 不做列表虚拟化、缩略图缓存等性能优化（记录为后续风险）。

## Decisions

1. **领域模型放 SwiftPM（`BizScanCore`），平台能力留在 App target**
   - 理由：Windows 也能编译测试模型、解析、vCard 等纯逻辑；iOS 层保持薄壳。
   - 备选：全部放 App target（被否：无法本地验证）；全部放包并抽象 Vision（被否：抽象成本高于收益）。

2. **`@Model BusinessCardEntity` 与 `struct BusinessCard` 分离，显式映射**
   - 理由：SwiftData 模型是引用类型且与 `ModelContext` 绑定，直接进 UI 会扩大生命周期耦合；映射层同时承担 schema 迁移边界。
   - 备选：UI 直接用 `@Model`（被否：测试与预览需要真实容器）。

3. **仓库协议 + 两套实现**
   - `SwiftDataBusinessCardRepository` 负责持久化；`InMemoryBusinessCardRepository` 供 Preview、单测与 `-ui-testing` 使用。
   - 理由：UI 测试需要确定性初始状态；单测不应依赖磁盘。

4. **图像只存相对路径，根目录为 Application Support**
   - 理由：iOS 容器绝对路径会在重装/迁移后变化；相对路径可重新解析（对应 `persistence` 规范）。
   - 备选：存 `UIImage` 二进制进数据库（被否：数据库膨胀、迁移困难）。

5. **依赖容器 `AppEnvironment` 通过 `.environment(_:)` 注入**
   - 理由：避免单例，便于在测试中替换服务。
   - 备选：全局单例（被否：不可测且会掩盖依赖）。

6. **UI 测试使用 `-ui-testing` 切换内存容器**
   - 理由：保证 T01 首次启动为空态的确定性，不依赖模拟器残留数据。

## Risks / Trade-offs

- [本机无法编译，首次 macOS/CI 构建预计有编译错误] → 已登记到 `docs/verification-debt.md`，按 L1 → L2 顺序结算；代码按"一类型一文件"组织以缩小修复面。
- [SwiftData 对 `[String]` 数组与 `@Attribute(.unique)` 的支持需真机/模拟器确认] → 首次 CI 运行优先验证 schema 创建；失败则改为 `Codable` 包装类型。
- [列表缩略图同步读盘，名片多时可能卡顿] → 后续 change 引入异步缩略图缓存；当前记录为一般风险。
- [`.xcodeproj` 不入库，依赖 XcodeGen 版本一致] → README 固定安装命令；CI 使用 `brew install xcodegen`。

## Migration Plan

全新工程，无历史数据。若 SwiftData schema 在后续 change 中变化，必须提供迁移说明或新增字段的默认值，并补充 `persistence` 规范场景。

## Open Questions

无阻断项。相机权限文案、默认标签集合等可在对应 change 中确定。
