# 验证报告：0015-real-card-eval

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0015-real-card-eval` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 21:57:05 – 21:57:30（Asia/Shanghai） |
| 机器 | `adminMac-Studio3222` / macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope unit --change 0015-real-card-eval` |
| 日志 | `artifacts/verify-0015-real-card-eval-20261027-215705.log` |
| 结果包 | `artifacts/verify-0015-real-card-eval-20261027-215705.xcresult` |

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 声明 `skip_specs: true`：只新增评估数据集、测试与报告，不改变任何行为合同。按 README 第 11 节与 `要求/01.md` 第五章逐条登记。

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 全量识别并保留原始文本 | 14 例真实名片 | `RealCardEvaluationTests.testEvaluateRealCardSet` | PASS（L2） | `casesWithOCRTex = 12/14`；c006、c010 无文本 |
| 与 Ground Truth 逐字段判等 | 归一化后按集合比对 | 同上（`EvalNormalizer`） | PASS（L2） | 与 `0014` 同口径 |
| 统计精确率/召回率 | 逐字段输出 | 同上，`EVAL_SUMMARY` | PASS（L2） | 指标见 `docs/eval/real-card-baseline.md` 第 3 节 |
| 虚构字段单独计数 | GT 为空时不得输出 | 同上 | PASS（L2） | `fabricatedTotal = 0`，达到阻断级要求 |
| 错误分类 | OCR 错字、分词、人名/公司、多号码、混排、字段缺失 | 同上 + 逐例明细复核 | PASS（L2） | 见基线报告第 4–5 节 |
| 数据集来源与版本 | 报告必须写来源/版本 | `docs/eval/real-cards/README.md`、`index.json` | PASS（文档） | `real-001`，14 例本机素材，图片不入库 |
| GT 人工确认 | 不得由 App OCR 反填 | `card_test/ground_truth/` 核对记录 | PASS（文档） | AI 起草 + 项目所有者确认，删除 `c009` |
| 检测能力可观测 | 检测是否成功 | 同上，`detectionSucceeded` | PASS（L2） | 11/14；c001、c002、c007 失败 |
| 与参考 App（CamCard）比较 | 同一批名片对比结果 | — | NOT RUN | 项目所有者本轮决定不做；不阻断本 change，阻断正式验收 |
| 30–50 张统一测试集 | 样本量 | 同上 | PARTIAL | 14 张 < 30；不阻断本 change，阻断正式验收 |

执行到的测试套件明细：

| 层 | 范围 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore（L1） | 全部 8 个套件 | 62 | PASS，0 失败 |
| BizScanTests（L2） | 全部 14 个套件（含 `RealCardEvaluationTests` 2 项） | 52 | PASS，0 失败（18.245 秒） |
| BizScanUITests（UI） | 5 个套件 | 11 | PASS，0 失败 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope unit` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：52 个用例，0 失败 |
| 全量 UI 测试 | `bash scripts/verify.sh --scope ui` | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退：core 62 不变；L2 50 → 52（新增 2 项）；UI 11 不变 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级 | 处理 |
|---|---|---|---|
| D1 | 数据集为 14 张本机真实名片，非教师下发 30–50 张 | 一般 | 已接受：只报绝对值，不宣称正式准确率；教师资产到位后重跑替换 |
| D2 | 检测 11/14；c001、c002（400×243 低清）与 c007（斜放）失败 | 一般 | 已记录：管线回退原图继续 OCR；检测失败需另开 change 修方向/低清处理 |
| D3 | OCR 空文本 2 例（c006 叠放实拍、c010 模板） | 一般 | 已记录：不设阈值；报告中按 case 说明 |
| D4 | `postalCode` 召回 0/6 | 一般 | 已归因：`FieldParser` 未提取邮编；需另开 change，不在本 change 调参 |
| D5 | 10/14 为设计稿/印刷稿/模板，5 张为占位信息 | 一般 | 已在报告按 `tags` 分组对照；结论以 4 张实拍子集为主要参考 |
| D6 | 未与 CamCard 比较 | 一般 | 项目所有者决定本轮不做；`reference-env.md` 版本未锁定 |
| D7 | CI 无 `card_test/` 时整组 `XCTSkip` | 一般 | 只针对本机资产缺失，不掩盖实现失败；报告已登记 |
| D8 | 首轮失败：模拟器沙盒读不到仓库路径（`indexMissing`） | 一般 | 属测试自身错误：改为可选资源打进测试 bundle 后第二轮通过；未放宽断言 |
| D9 | GT 由读图 AI 起草 | 一般 | 已由项目所有者逐条确认并删除 `c009`；报告标注「AI 起草 + 人工确认」 |
| D10 | EXIF 方向未归一化，`VisionOCRService` 固定 `.up` | 一般 | 已记录为产品偏差，需另开 change 在导入链路统一方向 |

## 5. 结论

- [x] Ready for archive：所有本 change 范围内的验收点 PASS，无阻断偏差
- [ ] 需修复后复验
- [ ] 需人类决策

补充说明：

1. 本 change 只新增 2 个测试文件、1 个数据集索引、1 份基线报告与 1 份验证报告；未改动 `BizScan/`、`Packages/BizScanCore/`、`openspec/specs/`、`fixtures/`。
2. `fabricatedTotal = 0`，满足 README 第 11 节的阻断级要求；未设任何准确率阈值。
3. 本报告与基线报告的数值全部来自 `EVAL_SUMMARY` 实际输出，未做四舍五入以外的加工。
4. **不宣称 G4/G7 通过**：真实集只有 14 张且未与 CamCard 比较；正式准确率仍需教师数据集与 30–50 张样本。
5. 归档需项目所有者批准后执行 `openspec archive 0015-real-card-eval`。
