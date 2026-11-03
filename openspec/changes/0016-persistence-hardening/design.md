# Design

## Context

当前 `BizScanApp` 在启动时调用 `ModelContainer(for: BusinessCardEntity.self, TagEntity.self)`。CI 日志显示，首次启动时 `Library/Application Support` 目录尚不存在，CoreData 先报 `Failed to stat path`，随后通过 recovery 成功创建 store。虽然本次恢复成功，但代码在容器创建失败时会静默回退到内存容器，导致重启后数据丢失且无提示。

T18 的现有证据是 `PersistenceTests`：使用临时 URL 创建容器，写入后释放容器，再用同一 URL 重建并读取。它验证了 SwiftData 落盘，但没有覆盖 App 进程终止/重启，也没有覆盖生产容器工厂。

## Decisions

### 1. 显式准备 Application Support

在创建生产容器前调用 `FileManager` 获取 `.applicationSupportDirectory`（`create: true`）并 `createDirectory`，消除首次启动的目录缺失错误。

### 2. 生产环境不再静默回退内存

- `-ui-testing` 仍然使用内存容器，保持现有 UI 测试的隔离性
- 生产路径失败时 `fatalError("无法创建 SwiftData 容器：\(error)")`
- 理由：静默使用内存会让用户以为保存成功，重启后数据消失；显式失败优于静默丢数据

### 3. 测试专用 on-disk store

新增启动参数：

- `-ui-testing-persistent`：使用 `Application Support/BizScanUITests.store`
- `-ui-testing-reset`：创建前删除 `.store`、`.store-shm`、`.store-wal`
- `-ui-testing-seed`：沿用现有种子数据逻辑

这样 T18 UI 测试可以在同一 App 容器内完成 `launch → terminate → launch`，且不影响生产数据。

### 4. T18 测试流程

1. 首次启动：`-ui-testing -ui-testing-persistent -ui-testing-reset -ui-testing-seed`
2. 断言 `David Chen` 存在
3. `app.terminate()`
4. 第二次启动：`-ui-testing -ui-testing-persistent`（不 reset、不 seed）
5. 断言 `David Chen` / `Alice Wu` 仍在

## Risks / Trade-offs

- `fatalError` 会让存储失败时 App 直接崩溃；但这是显式失败，不会静默丢数据。后续可改为错误页。
- 新增 UI 测试会增加约 15–20 秒 CI 时间。
- 测试 store 位于 Application Support，需要 reset 参数避免跨测试污染。

## Migration Plan

无既有用户数据迁移；生产 store 仍使用 SwiftData 默认 `default.store`，只是创建前补齐父目录。

## Open Questions

无。
