# 验证报告：0014-ocr-eval-baseline

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0014-ocr-eval-baseline` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 20:03:20 – 20:05:09（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope all --change 0014-ocr-eval-baseline` |
| 日志 | `artifacts/verify-0014-ocr-eval-baseline-20261027-200320.log` |
| 结果包 | `artifacts/verify-0014-ocr-eval-baseline-20261027-200320.xcresult` |

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 中声明 `skip_specs: true`：只新增评估测试与报告，不改变任何行为合同。按 README 第 11 节的评估要求逐条登记。

| 要求 | 验收点 | 测试方法 | 结果 | 备注 |
|---|---|---|---|---|
| 全量识别并保留原始文本 | 15 例均产出 OCR 原始文本 | `OCREvaluationTests.testEvaluateSyntheticCardSet` | PASS（L2） | `casesWithOCRTex = 15/15`；逐例 `rawLines` 写入 `docs/eval/raw/<id>.json` |
| 与 Ground Truth 逐字段判等 | 归一化后按集合比对 | 同上（`EvalNormalizer`） | PASS（L2） | 归一化规则由 `testNormalizationRulesMatchFixtureSpec` 单独守护 |
| 统计精确率/召回率 | 逐字段输出 | 同上，`EVAL_SUMMARY` | PASS（L2） | 指标见 `docs/eval/ocr-field-baseline.md` 第 3 节 |
| 虚构字段单独计数 | 缺字段案例不得输出非空值 | 同上（e04 缺 website、e05 缺 email） | PASS（L2） | `fabricatedTotal = 0`，达到阻断级要求 |
| 错误分类 | OCR 错字、分词、人名/公司混淆、多号码、混排、字段缺失 | 同上 + 逐例明细复核 | PASS（L2） | 5 处偏差全部归因，见基线报告第 4–5 节 |
| 标注数据集来源与版本 | 报告必须写 `自建合成` 与版本 | `docs/eval/ocr-field-baseline.md` | PASS（文档） | `synthetic-001`，15 例，明确「样本 < 30 只报绝对值」 |
| T07 标准名片产生原始文本 | 真实 Vision 识别 | `OCRServiceTests.testT07RecognizesSyntheticCardText` | PASS（L2，`0013`） | 本 change 复跑同套件，无回退 |
| T03–T05、T18 真机、T19 分享面板 | 人工步骤 | `docs/verify/manual-device-checklist.md` | NOT RUN | 未在真机执行；不阻断本 change，但阻断 G7 |

执行到的测试套件明细：

| 层 | 范围 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore（L1） | 全部 8 个套件 | 62 | PASS，0 失败 |
| BizScanTests（L2） | 全部 13 个套件（含 `OCREvaluationTests` 2 项） | 50 | PASS，0 失败（13.184 秒） |
| BizScanUITests（UI） | 5 个套件 | 11 | PASS，0 失败（90.574 秒） |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：50 个用例，0 失败 |
| 全量 UI 测试 | 同上（`-only-testing:BizScanUITests`） | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退：与 `0013` 批次同为 62 / 50；UI 与 `0011`、`0009` 同为 11 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 数据集为代码内合成的 15 例，非教师下发资产 | 一般 | 已接受：`fixtures/` 仍为空；报告显著标注 `自建合成 / synthetic-001`，教师资产到位后必须重跑替换 |
| D2 | `emails` 召回 0.818（漏 2、错 1）、`company`/`name` 各漏 1 | 一般 | 已归因：e06 邮箱字符错识、e09 `I`/`l` 混淆、e15 分词丢空格；列入基线报告改进项，不调参凑数 |
| D3 | e10 两行地址未合并，第二行落入 `unresolvedLines` | 一般 | 记为解析规则缺口，需新 change 修改 `FieldParser`；本轮不改实现 |
| D4 | 日志中 `CoreData`/`libsqlite3` 告警 | 一般 | 来自 `PersistenceTests` 临时库反复建删，对应用例均通过；非本 change 引入 |

风险：合成图在字体、对比度、背景上均优于真实拍摄，本基线的精确率不能外推到真实照片；`docs/eval/ocr-field-baseline.md` 第 6 节已写明。

## 5. 结论

- [ ] Ready for archive：所有验收点 PASS，无阻断偏差
- [ ] 需修复后复验
- [x] 需人类决策：评估基线已产出且虚构字段为 0，可归档；但「正式准确率」仍需教师数据集重跑，G4 的准确率部分只能算「基线就绪」

补充说明：

1. 本 change 只新增 2 个测试文件与 1 份评估报告，未改动 `BizScan/`、`Packages/BizScanCore/`、`project.yml`。
2. 本报告与 `docs/eval/ocr-field-baseline.md` 的指标全部来自 `EVAL_SUMMARY` 实际输出，未做四舍五入以外的加工。
3. 逐例明细 `docs/eval/raw/e01.json` – `e15.json` 由测试运行时写入，可与日志互证。
