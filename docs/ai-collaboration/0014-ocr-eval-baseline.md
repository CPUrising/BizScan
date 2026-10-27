# 0014-ocr-eval-baseline · AI 协作记录

## 1. prompt 范围

出处：`chat_history/chat02.md`（"继续完成 P7 剩余项"→"验证 0013 修复、跑 0014 评估"系列）与 `openspec/changes/archive/2026-10-27-0014-ocr-eval-baseline/proposal.md`。

授权范围：新增代码内合成数据集与评估测试，产出字段级准确率基线；不改 `FieldParser`、不改 OCR 参数。

明确不做：不接入教师数据集、不宣称正式准确率、不为凑分调参、不删除困难样例。

## 2. AI 产出

- `BizScanTests/OCREvaluationDataset.swift`：15 例合成名片，GT 与绘制文本同源，`EvalNormalizer` 归一化。
- `BizScanTests/OCREvaluationTests.swift`：跑真实 Vision 全链路，输出 `EVAL_SUMMARY`，明细写 `docs/eval/raw/`。
- `docs/eval/ocr-field-baseline.md`、`docs/verify/0014-ocr-eval-baseline.md`。

## 3. 人工修正点

| 事项 | 人类动作 |
|---|---|
| 是否等教师数据集 | 人类同意先用自建合成集，报告必须显著标注来源与样本量 |
| 准确率阈值 | 人类接受「不设阈值、只报绝对值」，唯一硬门槛为虚构字段 0 |
| 执行环境 | 人类本地跑 `--scope all` 并回传 `EVAL_SUMMARY` |

## 4. 回归结果

core 62 + L2 50 + UI 11，0 失败；`fabricatedTotal = 0`，`casesWithOCRTex = 15/15`。
证据：[docs/verify/0014-ocr-eval-baseline.md](../verify/0014-ocr-eval-baseline.md)、[docs/eval/ocr-field-baseline.md](../eval/ocr-field-baseline.md)。
