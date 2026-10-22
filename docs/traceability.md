# 验收追踪矩阵（T01–T20）

> 唯一口径：`要求/01.md` 第十七章定义的 20 个 Reference Test Scenarios。
> 规则：每条 Txx 必须能在规范中找到场景，并在测试代码中找到实现；反之新增场景必须回填本表。
> 状态：`未实现` / `已实现待执行` / `通过` / `失败`（执行结果由 `docs/verify/<change>.md` 佐证；`已实现待执行` 表示测试代码已存在但从未运行）。

## 1. 确定性场景（必须 100% 通过）

| ID | 场景 | 规范位置 | 自动化测试 | 状态 |
|---|---|---|---|---|
| T01 | 首次启动 → 空名片夹 | `specs/card-list` → `T01 First Launch` | `BizScanUITests/LaunchUITests.testAppLaunchesToEmptyCardHolder` | 已实现待执行 |
| T02 | 名片夹 → 扫描 → 相机页 | `specs/capture` → `T02 Enter Scanner` | `BizScanUITests/CaptureUITests.testT02OpenScannerAndReturn` | 已实现待执行 |
| T03 | 相机/相册权限允许与拒绝 | `specs/capture` → `T03 Permission 允许` / `T03 Permission 拒绝` | `CaptureUITests.testCameraPermission*` | 未实现 |
| T04 | 拍摄标准名片 → 进入识别 | `specs/capture` → `T04 Capture 确认进入识别` | `CaptureUITests.testCaptureAndConfirm` | 未实现 |
| T05 | 相册导入 → 进入识别 | `specs/capture` → `T05 Import` | `CaptureUITests.testImportFromLibrary` | 未实现 |
| T06 | 倾斜名片 → 检测并显示区域 | `specs/card-detection` → `T06 倾斜名片自动识别` | `CardDetectorTests` + `DetectionUITests.testShowDetectedQuad` | 未实现 |
| T07 | 标准名片 → OCR 原始文本 | `specs/ocr` → `T07 标准名片产生原始文本` | `OCRServiceTests` | 未实现 |
| T08 | OCR → 八字段分类 | `specs/field-extraction` → `T08 标准名片字段分类` | `FieldParserTests` | 未实现 |
| T09 | 无 Website → 不得虚构 | `specs/field-extraction` → `T09 无 Website` | `FieldParserTests.testNoFabricatedWebsite` | 未实现 |
| T10 | 多电话 → Mobile/Office/Fax 分流 | `specs/field-extraction` → `T10 多号码分流` | `FieldParserTests.testPhoneClassification` | 未实现 |
| T11 | 人工修改 → 保存修改结果 | `specs/verification` → `T11 Manual Correction` | `VerificationUITests.testManualCorrection` | 未实现 |
| T12 | 确认保存 → 返回名片夹出现新名片 | `specs/card-list` → `T12 Save 后返回名片夹` | `CardListUITests.testNewCardAppears` | 未实现 |
| T13 | 打开名片 → 显示全部字段 | `specs/card-detail` → `T13 Detail` | `BizScanUITests/DetailUITests.testT13OpenDetailShowsSavedFields`、`testT13EmptyFieldsAreNotShown` | 已实现待执行 |
| T14 | 编辑姓名/公司 → 保存 → 更新 | `specs/card-detail` → `T14 Edit` | `BizScanUITests/DetailUITests.testT14EditNamePersistsInDetail` | 已实现待执行 |
| T15 | 搜索姓名/公司 → 返回正确名片 | `specs/search-tags` → `T15 按姓名搜索` / `按公司与号码搜索` | `BizScanUITests/SearchTagsUITests.testT15SearchByName`、`testT15SearchByCompany` | 已实现待执行 |
| T16 | 加标签 → 按标签筛选 | `specs/search-tags` → `T16 添加标签并按标签筛选` | `BizScanUITests/SearchTagsUITests.testT16TagFilterShowsOnlyTaggedCards` | 已实现待执行 |
| T17 | 删除名片 → 从列表消失 | `specs/card-list` → `T17 Delete` | `BizScanUITests/CardListUITests.testT17DeleteCardRemovesItFromList` | 已实现待执行 |
| T18 | Kill App → 重启 → 数据保持 | `specs/persistence` → `T18 Kill App 后重启` | `PersistenceUITests.testDataSurvivesRelaunch` | 未实现 |
| T19 | 导出联系人/VCF → 字段映射正确 | `specs/export` → `T19 导出单张名片为 vCard` | `VCardExportTests` | 未实现 |
| T20 | 取消/返回/权限拒绝/无法识别/空字段 | `specs/capture` → `T20 中途退出`<br>`specs/card-detection` → `T20 校正页重拍`<br>`specs/verification` → `空名片保存` | `BizScanUITests/CaptureUITests.testT20ExitWithoutDraft`（已实现待执行）<br>`DetectionUITests.testRetakeFromAdjust`（待写）<br>`VerificationUITests.testEmptyCardSave`（待写） | 已实现待执行 |

## 2. 概率性功能的评价项（不进入 100% 判定）

| 评价项 | 规范位置 | 度量 | 报告位置 |
|---|---|---|---|
| OCR 文本质量 | `specs/ocr` | 字符准确率 / 行召回 | `docs/eval/ocr-report.md` |
| 字段抽取质量 | `specs/field-extraction` | 字段级精确率 / 召回率 / 虚构率 | `docs/eval/field-report.md` |
| 边界检测质量 | `specs/card-detection` | 检测成功率 / 角点平均误差 | `docs/eval/detection-report.md` |
| 人工校正成本 | `specs/verification` | 平均修改字段数 | `docs/eval/correction-report.md` |

## 3. 维护规则

1. 新增/改名 Txx 场景时，必须同步修改：规范场景标题、本表、测试方法名。
2. `状态=通过` 必须能链接到对应 `docs/verify/<change>.md` 的 PASS 行。
3. 任何一次 change 归档前，本表不得存在 `失败`；`未实现` 项必须属于后续 change 的范围并已在 proposal 中声明。
