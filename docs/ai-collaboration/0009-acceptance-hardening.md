# 0009-acceptance-hardening · AI 协作记录

## 1. prompt 范围

出处：`chat_history/Chat01.md`（"根据 readme 进度，到哪里"→"继续"→"归档"系列）与 `openspec/changes/archive/2026-10-27-0009-acceptance-hardening/proposal.md`。

授权范围：把 T01–T20 从「代码写完」推进到「可执行、有证据」，补 `BizScanUITests`、补测试替身、跑全量验证、回填 `docs/verify/` 与台账。

明确不做：不新增产品功能、不改公开接口、不修改 `openspec/specs/`。

## 2. AI 产出

- `BizScanUITests/`：`LaunchUITests`、`CaptureUITests`、`CardListUITests`、`DetailUITests`、`SearchTagsUITests`（共 11 项）。
- 测试种子注入 `-ui-testing-seed`，使 T13–T17 具备确定性初始状态。
- `docs/verify/0009-acceptance-hardening.md`、README 阶段看板更新。

## 3. 人工修正点

| 事项 | 人类动作 |
|---|---|
| 模拟器无相机导致的文案冲突 | 接受为已知偏差 D2，由 AI 在测试中以「先关闭提示」规避，人类确认不属本轮修复范围 |
| UI 首轮 5 项失败 | 人类提供 `xcresult` 中的 AX 层级快照，AI 据此区分「选择器写错」与「实现错误」，未放宽断言 |
| 归档时机 | AI 不自动归档，等人类明确同意后执行 |

## 4. 回归结果

`bash scripts/verify.sh --scope all`：core 62 + UI 11，0 失败。
证据：[docs/verify/0009-acceptance-hardening.md](../verify/0009-acceptance-hardening.md)。
