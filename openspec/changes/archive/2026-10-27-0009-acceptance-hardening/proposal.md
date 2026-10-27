# Proposal

## Why

代码已覆盖功能切片，但"写完"不等于"验收通过"。本 change 不新增产品功能，只负责把 T01–T20 变成可执行、可复现、有证据的验收结果，并结算 `docs/verification-debt.md` 中的全部未验证项。

## What Changes

- 补齐 `BizScanUITests` 中 T02–T20 的 UI 测试与必要的测试替身。
- 建立字段级准确率评估流程（OCR、字段抽取、检测、校正成本）。
- 在 macOS/CI 执行全量验证，产出 `docs/verify/` 证据与回归基线。
- 更新 `docs/traceability.md`、`README.md` 阶段看板与 `docs/regression-log.md`。
- 对失败项做最小修复；禁止通过放宽断言让测试变绿。
- 所有变更验证通过后归档。

不包含：任何新功能、新页面、新数据字段。

## Capabilities

### New Capabilities

无。本 change 只验证既有规范。

### Modified Capabilities

无。若验收发现规范本身有歧义，必须先提交带 `## MODIFIED Requirements` 的增量规范并重新评审，不在本 change 中修改 `openspec/specs/`。

## Impact

- 测试：`BizScanUITests/*`、`BizScanTests/*`、`Packages/BizScanCore/Tests/*`
- 文档：`docs/verify/*`、`docs/eval/*`、`docs/regression-log.md`、`docs/traceability.md`、`README.md`
- 流程：`openspec archive 0001…0008`
