# Proposal

## Why

`docs/eval/ocr-field-baseline.md` 的准确率证据全部来自代码内合成的 15 例（`synthetic-001`）：白底黑字、无透视、无噪声，指标明显优于真实拍摄。README 第 11 节要求概率性功能必须用固定名片集评估，`要求/01.md` 第十四节要求 30–50 张真实/合成混合测试集。目前真实名片样本为 0，G4 的「字段级准确率基线」只能算合成基线就绪。

本机 `card_test/` 有 14 张真实名片（英文 6、简体 4、繁体 4；原 15 张中的 `c009` 已由项目所有者删除），已加入 `.gitignore`。用它们补一份与合成基线同口径的真实基线，才能看出「合成图高估了多少」。

## What Changes

- 新增 `docs/eval/real-cards/README.md` 与 `index.json`：数据集 `real-001` 的标注规则、case id（`c001`–`c015`，`c009` 已删除）与本机图片相对路径；图片与 GT 均不入库。
- 新增 `BizScanTests/RealCardEvaluationDataset.swift`：从 `card_test/ground_truth/*.json` 与 `index.json` 加载 14 例真实名片，复用 `EvalCase` 与 `EvalNormalizer`。
- 新增 `BizScanTests/RealCardEvaluationTests.swift`：逐例跑 `ScanPipeline`，输出与 `0014` 相同的 `EVAL_SUMMARY` 结构，逐例明细写入模拟器临时目录并作为 `.xcresult` 附件。
- 新增 `docs/eval/real-card-baseline.md`：真实基线报告（14 例，虚构字段 0；检测 11/14、OCR 12/14）。
- 新增 `docs/verify/0015-real-card-eval.md`：五节验证报告（本地执行已通过）。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

无。评估只读现有实现，不改变任何行为合同；`.openspec.yaml` 声明 `skip_specs: true`。

## Impact

- 测试：`BizScanTests/` 新增 2 个文件；`card_test/` 不存在时（CI）自动跳过，不计失败。
- 文档：新增数据集说明、索引、基线报告、验证报告。
- 产品代码、`openspec/specs/`、`fixtures/`：**无改动**。
- 隐私：真实姓名/电话/邮箱/地址只存在于本机 `card_test/`，不进入 Git。
