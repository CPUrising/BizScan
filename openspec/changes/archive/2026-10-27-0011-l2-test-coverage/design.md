# Design

## Context

0009 已完成 11 个 UI 用例，但 T11/T12/T18/T19 仍无自动化证据。缺口原因分三类：

1. **进入路径不可控**：Review 页只能由相机或相册导入后进入，模拟器无相机，`-ui-testing` 又没有图片注入参数。
2. **系统 UI 不可控**：T19 的分享面板是系统 `ShareSheet`，无法稳定断言。
3. **启动参数与真实落盘互斥**：`-ui-testing` 强制内存容器，而 T18 需要的正是真实磁盘持久化。

因此本 change 只在 L2（`BizScanTests`，iOS 单元测试 target）补证据，UI 行一律记 NOT RUN。

## Goals / Non-Goals

**Goals:**

- T11/T12/T18/T19 各有可追溯的 L2 测试方法与 PASS 结果。
- 0006/0007 涉及的三个 ViewModel 公开方法有单测（AGENTS.md 第 4 节）。
- 不修改产品代码即可完成上述目标。

**Non-Goals:**

- 不追求 UI 端到端覆盖；不新增 `-ui-testing-import` 等测试专用启动参数。
- 不生成 fixtures 图片、不做 OCR/检测准确率评估。
- 不修复测试中发现的疑似缺陷（如 `ReviewViewModel.isEmptyCard` 未统计 `faxes`），只登记偏差。

## Decisions

1. **用 L2 替代 UI 覆盖四项**
   - 理由：现有实现把可测逻辑集中在 ViewModel / Exporter / Repository，注入 `InMemoryBusinessCardRepository`、`InMemoryImageStore` 后完全确定。
   - 备选：改产品代码加图片注入参数（被否：属于行为面变更，且让 0011 越界）。

2. **T18 用"同 URL 重建容器"模拟 Kill App**
   - 做法：`ModelContainer` 指向临时目录下的 `store.sqlite`，写入后把 `container` 置 `nil` 释放，再用同一 URL 新建容器与新 repository，断言数据仍在。
   - 理由：SwiftData 落盘语义与进程重启一致，且不依赖 UI 自动化。
   - 构造顺序（按可用性降级，执行时记录实际采用项）：
     1. `ModelConfiguration(schema: schema, url: url)`
     2. `ModelConfiguration(url: url)`
     3. `ModelConfiguration("Test", schema: schema, url: url)`
   - 备选：`PersistenceUITests` 杀进程重启（被否：`-ui-testing` 强制内存容器，无法验证落盘）。

3. **测试脚手架集中到 `TestSupport.swift`**
   - `makeScanResult(...)` 用 `UIGraphicsImageRenderer(size: 8×8)` 生成两张纯色图，避免依赖 fixture 文件。
   - `makeTemporaryContainer()` 返回 `(ModelContainer, directoryURL)`，用例结束统一删除目录。

4. **vCard 断言复用既有期望串**
   - `VCardExporterTests` 只验证"文件写出链路"，字段格式仍以 `Packages/BizScanCore/Tests/BizScanCoreTests/VCardBuilderTests.testT19FieldMapping` 的断言为准，不重复发明格式。

5. **不断言导出文件名唯一**
   - `BizScan-<epoch>.vcf` 以秒为单位，同秒两次导出会重名。这是既有实现的已知行为，本 change 不修，只避免写出会偶发失败的断言。

6. **所有用例标注 `@MainActor`**
   - `BusinessCardRepository` 协议与三个 ViewModel 都是 `@MainActor`，测试类统一标注可避免并发隔离编译错误。

## Risks / Trade-offs

- [L2 通过被误读为 Txx 全部通过] → 报告与 `traceability.md` 一律写"部分通过（L2）"，UI 行显式 NOT RUN。
- [`FileImageStore` 在模拟器写 Application Support 失败] → 断言真实结果；失败按阻断登记，不放宽断言。
- [SwiftData 在测试进程内缓存导致"重开"未真正读盘] → 释放容器引用并新建 `ModelContext`；如仍读到旧对象，报告登记"真实落盘未验证"。
- [临时目录残留] → 每个用例 `defer` / `tearDown` 删除本轮创建的目录。

## Migration Plan

无数据 schema 变更。测试新增文件由 `project.yml` 的 `BizScanTests` 目录级 `sources` 自动纳入，无需改工程配置。

## Open Questions

无。
