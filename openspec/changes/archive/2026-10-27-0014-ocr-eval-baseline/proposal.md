# Proposal

## Why

README 第 11 节要求概率性功能必须产出字段级准确率报告，`docs/eval/` 目前只有 `.gitkeep`。教师测试集（`fixtures/cards/`、`fixtures/ground_truth/`）尚未下发，但评估方法与脚本可以先落地：

1. T07 的 OCR 能力已有 `OCRServiceTests` 证明可识别合成名片，具备做评估的技术前提。
2. 没有基线时，「准确率不达标」与「解析规则退化」都无法被发现。
3. G4 的准入条件是「字段级准确率基线报告产出」，该缺口不补齐，P7 无法收尾。

## What Changes

- 新增 `BizScanTests/OCREvaluationDataset.swift`：15 例合成名片（中/英/混排、缺字段、竖版、低对比、复杂背景、多号码、人名公司混淆、无标签号码、部门、极简、全角），Ground Truth 与绘制文本同源。
- 新增 `BizScanTests/OCREvaluationTests.swift`：逐例跑 `ScanPipeline`（真实 Vision 检测/校正/OCR + `FieldParser`），统计每字段 `correct / wrong / missing / fabricated` 与精确率/召回率，打印 `EVAL_SUMMARY:` JSON，并把逐例明细写入 `docs/eval/raw/<id>.json`。
- 硬门槛只有两条：虚构字段总数 = 0；至少 12/15 例 OCR 原始文本非空。
- 新增 `docs/eval/ocr-field-baseline.md`，标注「自建合成数据、样本 < 30 只报绝对值」。
- 更新 `README.md` §2/§11、`docs/verification-debt.md`、`docs/regression-log.md` 与 `docs/traceability.md`。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

无。评估只读现有实现，不改变行为合同。

## Impact

- 测试：`BizScanTests/` 新增 2 个文件（2 个测试方法）。
- 文档：新增 1 份评估报告 + 逐例 JSON，更新 4 处台账/看板。
- 产品代码与 `openspec/specs/`：**无改动**。
