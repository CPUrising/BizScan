# Proposal

## Why

0009 的验收报告已明确 T11（人工修改保存）、T12（确认保存后回到列表）、T18（Kill App 后重启数据保持）、T19（导出 vCard）缺少自动化证据：T11/T12/T18 原本只规划了 UI 端到端，T19 只有 `VCardBuilder` 的 L1 映射测试。"写完"不等于"验证过"，这四项在 `docs/traceability.md` 里仍处 `未实现` 或 `部分通过（仅 L1）`。

本 change 不新增产品功能、不改任何公开接口与行为，只补 L2 单元测试，把这四项从"无自动化证据"推进到"逻辑层通过、UI 层明确未覆盖"。

## What Changes

- 新增 `BizScanTests/TestSupport.swift`：测试用 `ScanResult` 与临时 SwiftData 容器工厂。
- 新增 `BizScanTests/VCardExporterTests.swift`：`VCardFileExporter` 的文件写出、多卡、空集合、缺字段、落盘位置（T19 L2）。
- 新增 `BizScanTests/ReviewViewModelTests.swift`：预填、人工校正落库（T11）、首次保存写图像路径与记录（T12）、空名片二次确认、既有名片不重复插入。
- 新增 `BizScanTests/DetailViewModelTests.swift`、`BizScanTests/HomeViewModelTests.swift`：0006/0007 的 ViewModel 公开方法（AGENTS.md 第 4 节硬性要求）。
- 新增 `BizScanTests/PersistenceTests.swift`：以同一 `store.sqlite` 重建 `ModelContainer` 模拟 Kill App 重启（T18 L2），并覆盖标签持久化、`FileImageStore` 往返、删除时清理图像文件。

不包含：任何 `BizScan/` 下源码改动、任何 UI 测试、任何 fixture 图片与评估报告。

## Capabilities

### New Capabilities

无。本 change 只验证既有规范，不产生新的行为合同。

### Modified Capabilities

无。测试过程中若发现实现与规范不一致，只登记为偏差并把修复交回对应 change，不在本 change 内修改 `openspec/specs/`。

## Impact

- 测试：`BizScanTests/*`（仅新增文件，`project.yml` 的 `sources` 是目录级，无需改动）
- 证据：`docs/verify/0011-l2-test-coverage.md`
- 文档：`docs/traceability.md`、`docs/verification-debt.md` 的状态行由 `0012` 统一回填
