# 真实名片准确率基线（real-001）

> 状态：**已产出**（2026-10-27）。Ground Truth 由项目所有者逐条确认；指标来自真实 Vision 全链路执行。
> 数据集：`real-001`，14 张真实名片（英文 6、简体 4、繁体 4；原 15 张中的 `c009` 已删除）。
> 图片与 GT 只在本机 `card_test/`，均不入库；本报告只写聚合指标与 case id。

## 1. 数据集

| 项 | 值 |
|---|---|
| 来源 | 本机 `card_test/`（非教师下发资产） |
| 版本 | `real-001` |
| 样本量 | 14 例（< 30，只报绝对值，不做统计显著性判断） |
| 语言 | `en` 6、`zh-Hans` 4、`zh-Hant` 4 |
| 图片格式 | jpg 13、png 1 |
| 分辨率 | 最短边 236–695，整体偏低 |
| 来源构成 | 实拍 4（c006/c007/c012/c015）、设计稿/印刷稿/模板 10（含 5 张联系方式为占位） |
| 个人信息 | 原图、GT、逐例原始输出均留在 `card_test/`（已 `.gitignore`） |

标签分布见 `docs/eval/real-cards/index.json` 的 `tags`：`photo`、`design-mockup`、`template`、`placeholder`、`low-res`、`rotated`、`blurry`、`two-sided`、`multi-phone`。`c009` 已由所有者删除，不参与统计。

## 2. 环境

| 项 | 值 |
|---|---|
| 机器 | `adminMac-Studio3222`（项目所有者本地） |
| 系统 | macOS 26.3.1 |
| Xcode | Xcode 26.1.1 / Build 17B100 |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 命令 | `bash scripts/verify.sh --scope unit --change 0015-real-card-eval` |
| 日志 | `artifacts/verify-0015-real-card-eval-20261027-215705.log` |
| 结果包 | `artifacts/verify-0015-real-card-eval-20261027-215705.xcresult` |
| 逐例明细 | 测试临时目录 `real-eval-raw`（路径见日志 `REAL_EVAL_RAW_DIR`）与 `.xcresult` 附件 |

> 首轮（`20261027-214520`）失败原因：测试跑在模拟器沙盒内，`Bundle` 之外的仓库绝对路径不可读，`index.json` 报 `indexMissing`。已改为把 `card_test/` 与 `docs/eval/real-cards/` 作为可选资源打进测试 bundle，第二轮通过。

## 3. 逐字段指标

来自 `EVAL_SUMMARY`（`source = real-local`）。口径与 `docs/eval/ocr-field-baseline.md` 第 3 节一致；精确率 = correct / (correct + wrong + fabricated)，召回率 = correct / (correct + missing)。

| 字段 | correct | wrong | missing | fabricated | 精确率 | 召回率 |
|---|---|---|---|---|---|---|
| name | 6 | 5 | 7 | 0 | 0.545 | 0.462 |
| company | 4 | 2 | 10 | 0 | 0.667 | 0.286 |
| jobTitle | 5 | 2 | 6 | 0 | 0.714 | 0.455 |
| department | 0 | 0 | 0 | 0 | — | — |
| mobiles | 3 | 0 | 7 | 0 | 1.000 | 0.300 |
| officePhones | 3 | 5 | 10 | 0 | 0.375 | 0.231 |
| faxes | 2 | 1 | 5 | 0 | 0.667 | 0.286 |
| emails | 6 | 2 | 7 | 0 | 0.750 | 0.462 |
| website | 4 | 1 | 3 | 0 | 0.800 | 0.571 |
| address | 4 | 6 | 10 | 0 | 0.400 | 0.286 |
| postalCode | 0 | 0 | 6 | 0 | — | 0.000 |

汇总：`cases = 14`、`casesWithOCRTex = 12`、`detectionSucceeded = 11`、`fabricatedTotal = 0`。

按来源分组（仅作对照，样本量过小）：

| 子集 | 例数 | 检测成功 | OCR 非空 | name（对/错/漏） | company（对/错/漏） |
|---|---|---|---|---|---|
| 实拍 | 4 | 3 | 3 | 1 / 1 / 2 | 2 / 0 / 2 |
| 设计稿/印刷稿/模板 | 10 | 8 | 9 | 5 / 4 / 5 | 2 / 2 / 8 |

## 4. 逐例偏差

来自 `.xcresult` 的逐例明细附件（`real-eval-raw`）；只写 case id 与字段类别，不写联系方式。

| id | 检测 | OCR 文本 | 主要偏差字段 |
|---|---|---|---|
| c001 | 否 | 有 | name, company, jobTitle, mobiles, officePhones, faxes, emails, website, address |
| c002 | 否 | 有 | company, officePhones, emails, website, address |
| c003 | 是 | 有 | company, jobTitle, emails, address, postalCode |
| c004 | 是 | 有 | name, company, jobTitle, mobiles, address, postalCode |
| c005 | 是 | 有 | company, officePhones, website, postalCode |
| c006 | 是 | 无 | name, company, mobiles, officePhones, emails, address, postalCode |
| c007 | 否 | 有 | officePhones, address |
| c008 | 是 | 有 | company, officePhones, emails, address |
| c010 | 是 | 无 | name, company, jobTitle, mobiles, officePhones, emails, address |
| c011 | 是 | 有 | address, postalCode |
| c012 | 是 | 有 | officePhones, faxes |
| c013 | 是 | 有 | name, company, mobiles |
| c014 | 是 | 有 | name, company, jobTitle, mobiles, officePhones, faxes, emails, address |
| c015 | 是 | 有 | name, company, jobTitle, mobiles, officePhones, faxes, postalCode |

说明：

- c001、c002 为 400×243 低清图，c007 为斜放实拍，三例检测失败；管线回退到原图继续 OCR，因此仍有原始文本。
- c006 为叠放名片实拍、c010 为模板样张，OCR 未产出可用文本。

## 5. 误差分类统计

按归一化值与原始行的启发式归因；问题条目计数，`分词/换行` 与地址类问题存在重叠，不与前几项相加。

| 类别 | 条目数 | 说明 |
|---|---|---|
| 漏输出 | 71 | GT 有值但解析结果为空；主要集中在 company 10、address 10、officePhones 10、name 7、emails 7、mobiles 7 |
| 解析归属错误 | 8 | 原始文本里有该值，但被归到其他字段或未归位 |
| OCR 错字/字符混淆 | 7 | 输出与 GT 字符级相似但不等 |
| 字段归类（跨字段） | 5 | 输出值落在别的 GT 字段里，典型是人名/公司、号码类型混淆 |
| 号码 OCR 错字 | 2 | 电话号码数字位识别错误 |
| 其他/未归因 | 2 | 无法从原始行判断来源 |
| 分词/换行（附加标记） | 6 | 地址多行未合并或拆分错误 |

结构化字段合计：`wrong = 24`、`missing = 71`、`fabricated = 0`。

## 6. 局限与改进项

1. 样本 14 张 < `要求/01.md` 的 30–50 张，只能作为真实场景现状，不宣称正式准确率。
2. 未与 CamCard 结果比较（项目所有者本轮决定不做；`docs/reference-env.md` 的 CamCard 版本也未锁定）。
3. 10 张为设计稿/印刷稿/模板，其中 5 张联系方式为占位值，会拉低或扭曲字段指标；结论以 4 张实拍子集为主要参考，但该子集过小，不具备统计意义。
4. 分辨率偏低：检测 11/14 成功，c001、c002、c007 失败；检测失败后仍可 OCR，但校正缺失会影响字段位置与归属。
5. EXIF 方向风险：`UIImage.cgImage` 不含方向信息，`VisionOCRService` 固定 `.up`；c007 这类斜放样本的检测失败与此相关，需另开 change 在导入链路统一方向。
6. `postalCode` 召回 0/6：GT 有邮编的 6 例全部未输出，属 `FieldParser` 解析缺口，不是 OCR 问题。
7. `name` 错 5、`company` 错 2、跨字段归类 5：人名与公司、机构名的边界仍是主要误差源。
8. `address` 错 6、漏 10：多行地址未合并，部分行落入 `unresolvedLines`。
9. 电话类召回偏低（mobiles 0.300、officePhones 0.231、faxes 0.286），但 mobiles 精确率 1.000：说明「输出的都对，但大量没输出」，优先修召回而不是分类阈值。

改进项（均需另开 change，不在本 change 内调参）：

- `FieldParser`：邮编提取、人名/公司消歧、多行地址合并、无标签号码归类。
- 导入链路：按 EXIF 方向先归一化，再检测/OCR。
- 检测：低分辨率与斜放样本的失败要单列检测报告（G3 缺口）。
- 数据集：补到 30–50 张，占位模板与实拍分开统计。
- 与 CamCard 对比：锁定版本后另开 change。

## 7. 复现

```bash
# 1. GT 已由项目所有者确认（见第 8 节）
# 2. 本地终端执行（会重新生成工程并把 card_test/ 打进测试 bundle）
bash scripts/verify.sh --scope unit --change 0015-real-card-eval
# 3. 从日志中提取 EVAL_SUMMARY
grep -A 100 "EVAL_SUMMARY" artifacts/verify-0015-real-card-eval-*.log
```

CI 无 `card_test/` 时，`RealCardEvaluationTests` 整组 `XCTSkip`，不影响其他用例。

## 8. GT 确认状态

- 起草方式：读图 AI 逐张目视转写，未使用 App 自身 OCR 输出反填。
- 当前状态：**AI 起草 + 项目所有者逐条确认**（2026-10-27）。
- 已处理：删除 `c009` 及其图片；号码归类、人名/公司归属、占位值、地址换行均按确认结果写入 `card_test/ground_truth/`。
- 后续如再修改 GT，需重新核对并在本节记录日期。
