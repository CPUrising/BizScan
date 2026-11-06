# 验收追踪矩阵（T01–T35）

> 条目来源：`要求/01.md` 第十七章的 20 个 Reference Test Scenarios，加上 `0017` 起 UI 改版新增的 T21–T35。
> **教师 Reference Test Suite 未下发**，因此本表以作业原文为唯一权威条目，自建等价用例逐条映射；不宣称自建用例等同于 RTS。RTS 到位后只需补映射，不改实现。
> 规则：每条 Txx 必须能在规范中找到场景，并在测试代码中找到实现；反之新增场景必须回填本表。
> 唯一对外结论见 [`acceptance-report.md`](acceptance-report.md)。

## 0. 类别定义

| 类别 | 含义 | 计入通过率 |
|---|---|---|
| **A 已验证** | 有真实执行证据（L1 / L2 / UI），可追溯到 `docs/verify/` | 是 |
| **B 行为已覆盖，系统集成未验证** | 判定逻辑有代码级测试；剩余依赖真机硬件或系统 App | 否 |
| **C 环境不可达** | 基准或测试资产缺失，原因在项目控制范围外 | 否 |

B 类不得写成"通过"或"部分通过"；中间态在本表中不存在。

## 1. 确定性场景（必须 100% 通过）

| ID | 场景 | 规范位置 | 自动化证据 | 类别 | 残余风险 |
|---|---|---|---|---|---|
| T01 | 首次启动 → 空名片夹 | `specs/card-list` → `T01 First Launch` | `LaunchUITests.testAppLaunchesToEmptyCardHolder` | A | — |
| T02 | 名片夹 → 扫描 → 相机页 | `specs/capture` → `T02 Enter Scanner` | `CaptureUITests.testT02OpenScannerAndReturn` | A | 无相机时走 `.denied` 分支 |
| T03 | 相机/相册权限允许与拒绝 | `specs/capture` → `T03 Permission 允许` / `T03 Permission 拒绝` | `CaptureUITests` 进入扫描页时解除系统弹窗，未断言两条分支 | B | 拒绝分支需系统设置页，仅真机可执行（清单第 1–2 节） |
| T04 | 拍摄标准名片 → 进入识别 | `specs/capture` → `T04 Capture 确认进入识别` | `DetectionUITests.testRotateNoticeThenConfirmEntersReview`（注入图走完整管线） | B | 真实快门、对焦、曝光未验证（清单第 3 节） |
| T05 | 相册导入 → 进入识别 | `specs/capture` → `T05 Import` | 导入后管线同 T04 注入路径 | B | `PhotosPicker` 为系统 UI，无法稳定驱动（清单第 4 节） |
| T06 | 倾斜名片 → 检测并显示区域 | `specs/card-detection` → `T06 倾斜名片自动识别` | `CardDetectorTests.testT06DetectsTiltedCard`、`testT06DetectsClearCardOnContrastBackground`、`CropViewModelTests.testT06KeepsDefaultPointsWhenDetectionReturnsNil` | B | 八类拍摄条件完整 3/8；真实拍摄 11/14（清单第 5 节） |
| T07 | 标准名片 → OCR 原始文本 | `specs/ocr` → `T07 标准名片产生原始文本` | `OCRServiceTests.testT07RecognizesSyntheticCardText`、`testObservationsUseNormalizedBoundingBox`、`OCREvaluationTests`（15 例）、`RealCardEvaluationTests`（14 例） | B | 真实拍摄下 OCR 非空 12/14（`docs/eval/`） |
| T08 | OCR → 八字段分类 | `specs/field-extraction` → `T08 标准名片字段分类` | `FieldParserTests.testT08StandardEnglishCard` | A | — |
| T09 | 无 Website → 不得虚构 | `specs/field-extraction` → `T09 无 Website` | `FieldParserTests.testT09MissingWebsiteIsNotFabricated`、`NoFabricationTests` | A | 虚构字段计数 0 |
| T10 | 多电话 → Mobile/Office/Fax | `specs/field-extraction` → `T10 多号码分流` | `FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests` | A | — |
| T11 | 人工修改 → 保存修改结果 | `specs/verification` → `T11 Manual Correction` | `ReviewViewModelTests.testT11ManualCorrectionPersistsEditedFields` | B | 校正页 UI 交互未自动化 |
| T12 | 确认保存 → 返回名片夹出现新名片 | `specs/card-list` → `T12 Save 后返回名片夹` | `ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord`、`CardListUITests.testT34CreateCardManually` | B | 扫描保存后的列表跳转未单独断言 |
| T13 | 打开名片 → 显示全部字段 | `specs/card-detail` → `T13 Detail` | `DetailUITests.testT13OpenDetailShowsSavedFields`、`testT13EmptyFieldsAreNotShown` | A | — |
| T14 | 编辑姓名/公司 → 保存 → 更新 | `specs/card-detail` → `T14 Edit` | `DetailUITests.testT14EditNamePersistsInDetail` | A | — |
| T15 | 搜索姓名/公司 → 返回正确名片 | `specs/search-tags` → `T15 按姓名搜索` / `按公司与号码搜索` | `SearchTagsUITests.testT15SearchByName`、`testT15SearchByCompany` | A | — |
| T16 | 添加标签 → 编辑页可见 | `specs/search-tags` → `T16 添加标签并保留在编辑页` | `SearchTagsUITests.testT16TagIsEditableAndHiddenOnHome`、`RepositoryTests.testTagCreationIsCaseInsensitive` | A | 标签删除按钮无 UI 断言，由 `RepositoryTests.testDeleteTagRemovesItFromCards` 覆盖 |
| T17 | 删除名片 → 从列表消失 | `specs/card-list` → `T17 Delete` | `CardListUITests.testT17DeleteCardRemovesItFromList` | A | — |
| T18 | Kill App → 重启 → 数据保持 | `specs/persistence` → `T18 Kill App 后重启` | `PersistenceUITests.testT18DataSurvivesRelaunch`、`PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen` | A | 模拟器 `terminate` 等价于进程终止；未在真机复跑 |
| T19 | 导出联系人/VCF → 字段映射正确 | `specs/export` → `T19 导出单张名片为 vCard` | `VCardBuilderTests.testT19FieldMapping`、`VCardExporterTests`（5 项） | B | 系统分享面板未验证（清单第 8 节） |
| T20 | 取消/返回/重拍/无法识别/空字段 | `specs/capture` → `T20 中途退出`<br>`specs/card-detection` → `T20 校正页重拍`<br>`specs/verification` → `空名片保存` | `CaptureUITests.testT20ExitWithoutDraft`、`DetectionUITests.testRetakeFromAdjustReturnsToScanner`、`testRotateNoticeThenConfirmEntersReview`、`ReviewViewModelTests.testEmptyCardRequiresConfirmation`、`testFaxOnlyCardIsNotTreatedAsEmpty` | A | 权限拒绝分支并入 T03 |
| T21 | 创建分组 → 按分组筛选 | `specs/card-list` → `T21 创建分组并按分组筛选` | `CardListUITests.testT21CreateGroupAndFilter`、`HomeViewModelTests.testGroupFilterShowsOnlyGroupCards`、`testMoveCardToGroup` | A | — |
| T22 | 删除分组 → 名片回到未分组 | `specs/card-list` → `T22 删除分组后名片回到未分组` | `CardListUITests.testT22DeleteGroupMovesCardToUngrouped`、`RepositoryTests.testDeleteGroupClearsCardGroup` | A | — |
| T23 | 打开名片 → 展示所属分组 | `specs/card-detail` → `T23 详情展示分组` | `DetailUITests.testT23DetailShowsGroup`、`RepositoryTests.testSaveCardKeepsGroup` | A | — |
| T24 | 主页按创建日期分组 | `specs/card-list` → `T24 主页按日期分组展示` | `CardListUITests.testT24HomeGroupsByCreatedDate`、`HomeViewModelTests.testSectionsGroupByCreatedDay`、`testEditingDoesNotMoveCardToAnotherDay` | A | — |
| T25 | 主页深色外观与常驻入口 | `specs/card-list` → `T25 主页深色外观与常驻入口` | `CardListUITests.testT25HomeKeepsPersistentEntries` | A | 配色为功能性验证，未做像素级断言 |
| T26 | 详情核心资料与快捷操作 | `specs/card-detail` → `T26 详情核心资料与快捷操作` | `DetailUITests.testT26ProfileAndQuickActions`、`testT26AddressActionDisabledWithoutAddress` | A | 电话/地图/邮件/浏览器的真实调起未验证 |
| T27 | 收藏状态持久化 | `specs/card-detail` → `T27 收藏状态持久化`<br>`specs/card-model` → `收藏标记持久化` | `DetailUITests.testT27FavoritePersists`、`DetailViewModelTests.testToggleFavoritePersists`、`PersistenceTests.testT27FavoriteSurvivesReopen` | A | — |
| T28 | 查看原图 | `specs/card-detail` → `T28 查看原图` | `DetailUITests.testT28ViewOriginalImage`、`testT26AddressActionDisabledWithoutAddress`（无图隐藏） | A | — |
| T29 | 低置信度字段展示待核对 | `specs/card-detail` → `T29 低置信度字段展示待核对`<br>`specs/card-model` → `低置信度电话被标记` | `DetailUITests.testT29ReviewBadgeIsShown`、`DetailViewModelTests.testContactEntriesCarryReviewFlag`、`UnverifiedValueDetectorTests` | A | — |
| T30 | 编辑修正后待核对消失 | `specs/card-detail` → `T30 编辑修正后标记消失`<br>`specs/card-model` → `修正后不再标记` | `DetailViewModelTests.testSavingCorrectedValueClearsReviewFlag`、`ReviewViewModelTests.testCorrectedValueClearsUnverifiedFlag` | B | 功能已完成；手机号为多行 `TextField`，Form 中无法稳定取得焦点，UI 断言未落地 |
| T34 | 主页「+」→ 手动新建无原图名片 | `specs/card-list` → `T34 手动新建并保存`<br>`specs/card-model` → `T34 手动新建允许无原图` | `CardListUITests.testT34CreateCardManually`、`NewCardViewModelTests.testSaveCreatesCardWithoutImage`、`testNoGroupKeepsNilGroup` | A | UI 只录入姓名，手机号由 L2 覆盖 |
| T35 | 手动新建空卡 → 二次确认 | `specs/card-list` → `T35 手动新建空卡需确认` | `CardListUITests.testT35EmptyManualCardRequiresConfirmation`、`NewCardViewModelTests.testEmptyCardRequiresConfirmation` | A | — |
| T31 | 存入通讯录成功 | `specs/card-detail` → `T31 存入通讯录成功` | `DetailViewModelTests.testSaveToContactsSuccessDisablesButton`、`ContactsMapperTests`（5 项） | B | 真实写入系统通讯录未验证（清单第 8b 节） |
| T32 | 通讯录权限拒绝 | `specs/card-detail` → `T32 权限拒绝时引导设置` | `DetailViewModelTests.testSaveToContactsDeniedNeedsSettings` | B | 权限弹窗交互未验证（清单第 8b 节） |
| T33 | 重复联系人提示 | `specs/card-detail` → `T33 重复联系人提示已存在` | `DetailViewModelTests.testSaveToContactsAlreadyExistsShowsMessage`、`ContactsMapperTests.testComparableValuesNormalizePhonesAndEmails` | B | 真实通讯录比对未验证（清单第 8b 节） |

## 2. 概率性功能的评价项（不进入 100% 判定）

| 评价项 | 规范位置 | 度量 | 报告位置 |
|---|---|---|---|
| OCR 文本质量 | `specs/ocr` | 字符准确率 / 行召回 | `docs/eval/ocr-field-baseline.md`（合成）、`docs/eval/real-card-baseline.md`（真实，OCR 非空 12/14） |
| 字段抽取质量 | `specs/field-extraction` | 字段级精确率 / 召回率 / 虚构率 | `docs/eval/ocr-field-baseline.md`、`docs/eval/real-card-baseline.md`（虚构字段 0） |
| 边界检测质量 | `specs/card-detection` | 检测成功率 / 角点平均误差 | `docs/eval/detection-report.md`（成功率 11/14；角点误差未度量） |
| 人工校正成本 | `specs/verification` | 平均修改字段数 | 未产出（`correction-report.md` 待补） |
| AI 能力边界 | `要求/01.md` 第八章 | 五类边界的实测表现 | `docs/eval/ai-capability-boundary.md` |

## 3. 统计

| 类别 | 数量 |
|---|---|
| A 已验证 | 23 |
| B 行为已覆盖，系统集成未验证 | 12 |
| C 环境不可达 | 0（Txx 级）；基准缺口 3 项见 `acceptance-report.md` 第 4 节 E3 |
| 合计 | 35 |

## 4. 维护规则

1. 新增/改名 Txx 场景时，必须同步修改：规范场景标题、本表、测试方法名。
2. `类别=A` 必须能链接到对应 `docs/verify/<change>.md` 的 PASS 行。
3. `类别=B` 必须写明残余风险与交接位置；**不得**用"部分通过"代替。
4. 任何一次 change 归档前，本表不得存在执行失败；C 类必须在 `acceptance-report.md` 声明。
5. 拿到真机或教师 RTS 后，先更新本表类别，再更新 `acceptance-report.md`。
