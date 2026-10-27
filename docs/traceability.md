# 验收追踪矩阵（T01–T20）

> 唯一口径：`要求/01.md` 第十七章定义的 20 个 Reference Test Scenarios。
> 规则：每条 Txx 必须能在规范中找到场景，并在测试代码中找到实现；反之新增场景必须回填本表。
> 状态：`未实现` / `已实现待执行` / `部分通过` / `通过` / `失败`（执行结果由 `docs/verify/<change>.md` 佐证；`已实现待执行` 表示测试代码已存在但从未运行）。

## 1. 确定性场景（必须 100% 通过）

| ID | 场景 | 规范位置 | 自动化测试 | 状态 |
|---|---|---|---|---|
| T01 | 首次启动 → 空名片夹 | `specs/card-list` → `T01 First Launch` | `BizScanUITests/LaunchUITests.testAppLaunchesToEmptyCardHolder` | 通过（`0009`） |
| T02 | 名片夹 → 扫描 → 相机页 | `specs/capture` → `T02 Enter Scanner` | `BizScanUITests/CaptureUITests.testT02OpenScannerAndReturn` | 通过（`0009`，无相机走 `.denied` 分支） |
| T03 | 相机/相册权限允许与拒绝 | `specs/capture` → `T03 Permission 允许` / `T03 Permission 拒绝` | 人工：`docs/verify/manual-device-checklist.md` 第 1–2 节（`CaptureUITests.testCameraPermission*` 未写） | 未执行（模拟器无相机；人工清单 `0013`） |
| T04 | 拍摄标准名片 → 进入识别 | `specs/capture` → `T04 Capture 确认进入识别` | 人工：`manual-device-checklist.md` 第 3 节（`CaptureUITests.testCaptureAndConfirm` 未写） | 未执行（人工清单 `0013`） |
| T05 | 相册导入 → 进入识别 | `specs/capture` → `T05 Import` | 人工：`manual-device-checklist.md` 第 4 节（`CaptureUITests.testImportFromLibrary` 未写） | 未执行（人工清单 `0013`） |
| T06 | 倾斜名片 → 检测并显示区域 | `specs/card-detection` → `T06 倾斜名片自动识别` | `BizScanTests/CardDetectorTests.testT06DetectsClearCardOnContrastBackground`、`testT06DetectsTiltedCard`；`CropViewModelTests.testT06KeepsDefaultPointsWhenDetectionReturnsNil`（回退） | 部分通过（`0013`，L2 Vision 检测；真机倾斜拍摄未执行） |
| T07 | 标准名片 → OCR 原始文本 | `specs/ocr` → `T07 标准名片产生原始文本` | `BizScanTests/OCRServiceTests.testT07RecognizesSyntheticCardText`、`testObservationsUseNormalizedBoundingBox`；`OCREvaluationTests`（15 例合成，`0014`）；`RealCardEvaluationTests`（14 例真实，`0015`） | 部分通过（`0013`/`0014`/`0015`，L2 + 两份评估基线；真机拍摄未执行） |
| T08 | OCR → 八字段分类 | `specs/field-extraction` → `T08 标准名片字段分类` | `FieldParserTests.testT08StandardEnglishCard` | 通过（`0009`，L1 单测） |
| T09 | 无 Website → 不得虚构 | `specs/field-extraction` → `T09 无 Website` | `FieldParserTests.testT09MissingWebsiteIsNotFabricated`、`NoFabricationTests` | 通过（`0009`，虚构字段 0） |
| T10 | 多电话 → Mobile/Office/Fax 分流 | `specs/field-extraction` → `T10 多号码分流` | `FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests` | 通过（`0009`，L1 单测） |
| T11 | 人工修改 → 保存修改结果 | `specs/verification` → `T11 Manual Correction` | `BizScanTests/ReviewViewModelTests.testT11ManualCorrectionPersistsEditedFields`（`VerificationUITests` 待写） | 部分通过（`0011`，L2；校正页 UI 未执行） |
| T12 | 确认保存 → 返回名片夹出现新名片 | `specs/card-list` → `T12 Save 后返回名片夹` | `ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord`、`HomeViewModelTests.testReloadSortsByUpdatedAtDescending`（`CardListUITests.testNewCardAppears` 待写） | 部分通过（`0011`，L2；列表跳转 UI 未执行） |
| T13 | 打开名片 → 显示全部字段 | `specs/card-detail` → `T13 Detail` | `BizScanUITests/DetailUITests.testT13OpenDetailShowsSavedFields`、`testT13EmptyFieldsAreNotShown` | 通过（`0009`） |
| T14 | 编辑姓名/公司 → 保存 → 更新 | `specs/card-detail` → `T14 Edit` | `BizScanUITests/DetailUITests.testT14EditNamePersistsInDetail` | 通过（`0009`） |
| T15 | 搜索姓名/公司 → 返回正确名片 | `specs/search-tags` → `T15 按姓名搜索` / `按公司与号码搜索` | `BizScanUITests/SearchTagsUITests.testT15SearchByName`、`testT15SearchByCompany` | 通过（`0009`） |
| T16 | 加标签 → 按标签筛选 | `specs/search-tags` → `T16 添加标签并按标签筛选` | `BizScanUITests/SearchTagsUITests.testT16TagFilterShowsOnlyTaggedCards` | 通过（`0009`） |
| T17 | 删除名片 → 从列表消失 | `specs/card-list` → `T17 Delete` | `BizScanUITests/CardListUITests.testT17DeleteCardRemovesItFromList` | 通过（`0009`） |
| T18 | Kill App → 重启 → 数据保持 | `specs/persistence` → `T18 Kill App 后重启` | `BizScanTests/PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen`；真机：`manual-device-checklist.md` 第 7 节 | 部分通过（`0011`，L2 同 URL 重建容器；真机 kill 待执行） |
| T19 | 导出联系人/VCF → 字段映射正确 | `specs/export` → `T19 导出单张名片为 vCard` | `VCardBuilderTests.testT19FieldMapping`（L1）+ `BizScanTests/VCardExporterTests`（5 项，L2）；真机：`manual-device-checklist.md` 第 8 节 | 部分通过（`0011`，L1+L2；系统分享面板待执行） |
| T20 | 取消/返回/权限拒绝/无法识别/空字段 | `specs/capture` → `T20 中途退出`<br>`specs/card-detection` → `T20 校正页重拍`<br>`specs/verification` → `空名片保存` | `BizScanUITests/CaptureUITests.testT20ExitWithoutDraft`（通过）<br>`BizScanTests/ReviewViewModelTests.testEmptyCardRequiresConfirmation`（通过）<br>`ImageCorrectorTests.testRotationQuarterTurnsSwapDimensions`、`CropViewModelTests.testT20ProcessProducesResultFromManualPoints`（`0013`，90° 旋转与手动四点）<br>`DetectionUITests.testRetakeFromAdjust`（待写） | 部分通过（`0009` 中途退出 + `0011` 空名片 L2 + `0013` 旋转/回退；校正页重拍待真机） |

## 2. 概率性功能的评价项（不进入 100% 判定）

| 评价项 | 规范位置 | 度量 | 报告位置 |
|---|---|---|---|
| OCR 文本质量 | `specs/ocr` | 字符准确率 / 行召回 | `docs/eval/ocr-field-baseline.md`（合成）、`docs/eval/real-card-baseline.md`（真实，含 OCR 非空 12/14） |
| 字段抽取质量 | `specs/field-extraction` | 字段级精确率 / 召回率 / 虚构率 | `docs/eval/ocr-field-baseline.md`、`docs/eval/real-card-baseline.md`（虚构字段 0） |
| 边界检测质量 | `specs/card-detection` | 检测成功率 / 角点平均误差 | `docs/eval/detection-report.md`（成功率 11/14；角点误差未度量） |
| 人工校正成本 | `specs/verification` | 平均修改字段数 | 未产出（`correction-report.md` 待补） |
| AI 能力边界 | `要求/01.md` 第八章 | 五类边界的实测表现 | `docs/eval/ai-capability-boundary.md` |

## 3. 维护规则

1. 新增/改名 Txx 场景时，必须同步修改：规范场景标题、本表、测试方法名。
2. `状态=通过` 必须能链接到对应 `docs/verify/<change>.md` 的 PASS 行。
3. 任何一次 change 归档前，本表不得存在 `失败`；`未实现` 项必须属于后续 change 的范围并已在 proposal 中声明。
