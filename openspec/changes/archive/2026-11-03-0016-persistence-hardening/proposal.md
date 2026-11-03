# Proposal

## Why

`BizScanApp.makeContainer()` 在磁盘容器创建失败时会静默回退到内存容器（`BizScanApp.swift:40-44`），App 仍能启动，但重启后数据全部丢失且用户无感知。CI 日志也显示首次启动时 `Application Support` 目录缺失导致 CoreData 初始化失败（随后恢复），说明默认落盘路径需要显式准备。

同时 T18 目前只有“同一 URL 重建容器”的 L2 证据（`PersistenceTests`），缺少真实 App `terminate → relaunch` 的自动化验证；UI 测试全部使用 `-ui-testing` 内存容器，没有覆盖真实落盘重启。

## What Changes

- 启动时确保 `Application Support` 目录存在，再创建 SwiftData 容器
- 生产环境移除静默内存回退；初始化失败时显式 `fatalError`，避免静默丢数据
- 为 UI 测试增加专用 on-disk store 与 reset 启动参数
- 新增 T18 UI 测试：seed → terminate → relaunch → 断言数据仍在
- 更新 `docs/verify/`、`docs/traceability.md`、`docs/verification-debt.md`、README P7

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `persistence`：明确存储初始化失败时 MUST 显式报错，MUST NOT 静默回退到内存存储。

## Impact

- 代码：`BizScan/App/BizScanApp.swift`、`BizScanUITests/PersistenceUITests.swift`
- 文档：`docs/verify/0016-persistence-hardening.md`、`docs/traceability.md`、`docs/verification-debt.md`、`README.md`
- 行为：存储初始化失败从“静默降级为内存”改为“显式启动失败”
- 不在范围：T03–T05、T18 真机、T19、30–50 张正式数据集
