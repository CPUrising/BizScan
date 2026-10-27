# Tasks

## 1. 数据集与标注

- [x] 1.1 `docs/eval/real-cards/README.md`：标注规则、case 映射、人工确认清单
- [x] 1.2 `docs/eval/real-cards/index.json`：`c001`–`c015` 的图片相对路径、语言、方向、标签
- [x] 1.3 由读图 AI 起草 `card_test/ground_truth/c001–c015.json`（不入库；`c009` 已由所有者删除）
- [x] 1.4 项目所有者逐条核对 GT，并删除 `c009` 及其图片（2026-10-27）

## 2. 评估代码

- [x] 2.1 `BizScanTests/RealCardEvaluationDataset.swift`：从 `index.json` + `card_test/ground_truth/` 加载 14 例
- [x] 2.2 `BizScanTests/RealCardEvaluationTests.swift`：逐例跑 `ScanPipeline`，输出 `EVAL_SUMMARY`，明细写临时目录并附到 `.xcresult`
- [x] 2.3 `card_test/` 缺失时 `XCTSkip`，CI 不受影响
- [x] 2.4 `project.yml` 把 `card_test/` 与 `docs/eval/real-cards/` 作为可选资源打进测试 bundle（模拟器沙盒可读）

## 3. 报告与验证

- [x] 3.1 `bash scripts/verify.sh --scope unit --change 0015-real-card-eval` 本地执行并回填日志
- [x] 3.2 `docs/eval/real-card-baseline.md`：回填逐字段指标、误差分类、设计稿子集对照
- [x] 3.3 `docs/verify/0015-real-card-eval.md`：五节结构，含实际日志与 `.xcresult` 路径
- [x] 3.4 更新 `README.md` §2/§11、`docs/traceability.md`、`docs/verification-debt.md`、`docs/regression-log.md`
- [x] 3.5 `openspec validate --all --strict` 通过；项目所有者批准后已归档（2026-10-27）

> 不改 `BizScan/`、`Packages/BizScanCore/`、`openspec/specs/`、`fixtures/`；不设准确率阈值；不做 CamCard 对比。
