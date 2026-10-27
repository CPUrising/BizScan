# Tasks

## 1. 数据集与评估

- [x] 1.1 `BizScanTests/OCREvaluationDataset.swift`：15 例合成名片 + 同源 Ground Truth + 归一化工具
- [x] 1.2 `BizScanTests/OCREvaluationTests.swift`：逐例跑真实 Vision 全链路，统计并打印 `EVAL_SUMMARY`
- [x] 1.3 逐例明细写入 `docs/eval/raw/<id>.json`

## 2. 报告

- [x] 2.1 `docs/eval/ocr-field-baseline.md`：数据集来源/版本、环境、逐字段精确率与召回率、错误分类、局限
- [x] 2.2 `docs/verify/0014-ocr-eval-baseline.md`：五节结构，结论「需人类决策」

## 3. 验证与收口

- [x] 3.1 `bash scripts/verify.sh --scope all --change 0014-ocr-eval-baseline` 全绿
- [x] 3.2 更新 `README.md` §2/§11、`docs/verification-debt.md`、`docs/traceability.md`、`docs/regression-log.md`

> 不改 `BizScan/` 源码、不改 `openspec/specs/`、不设准确率阈值、不归档任何 change。
