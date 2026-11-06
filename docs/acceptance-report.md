# 验收结论书

> 本文件是项目**唯一对外验收口径**。README 的阶段看板、`docs/traceability.md`、`docs/verification-debt.md` 均指向本文件，不各自表述结论。

## 1. 验收基准声明

| 项 | 说明 |
|---|---|
| 权威条目来源 | `要求/01.md` 第十七章 T01–T20 原文，加上 `0017` 起 UI 改版新增的 T21–T35 |
| 教师 Reference Test Suite | **未下发**（已确认，非"未获取"） |
| 因此的判定方式 | 以作业原文条目为唯一权威，自建等价用例集逐条映射；**不宣称自建用例集等价于教师 RTS** |
| RTS 到位后的动作 | 只需补映射表与执行记录，不需改动实现；若条目口径冲突，以 RTS 为准另开 change |

一句话：**没有教师 RTS，不等于没有验收；但也不能把自建测试集说成 RTS。**

## 2. 冻结基线

本文件的全部结论基于下表这一次执行，文档修订不再触发重跑。

| 项 | 值 |
|---|---|
| 冻结时间 | 2026-11-06 15:25 |
| 机器 | macOS 26.3.1 |
| Xcode | 26.1.1 (17B100) |
| 模拟器 | iPhone 16 (`iPhone17,3`) / iOS 18.0 (22A3351) |
| 真机 | 无 |
| 结果 | `BizScanCore` 69 + `BizScanTests` 89 + `BizScanUITests` 26，共 184 项，0 失败 |
| 证据 | [`verify/0021-review-flags.md`](verify/0021-review-flags.md)、[`verify/0022-save-to-contacts.md`](verify/0022-save-to-contacts.md) |

UI 26 项构成：`LaunchUITests` 1、`CaptureUITests` 2、`CardListUITests` 9、`DetailUITests` 8、`SearchTagsUITests` 3、`PersistenceUITests` 1、`DetectionUITests` 2。

## 3. 结论汇总

| 类别 | 数量 | 含义 | 是否计入通过率 |
|---|---|---|---|
| **A 已验证** | 23 / 35 | 有真实执行证据（L1 / L2 / UI） | 是 |
| **B 行为已覆盖，系统集成未验证** | 12 / 35 | 判定逻辑有代码级测试；剩余部分需要真机硬件或系统 App | 否 |
| **C 环境不可达** | 3 项（非 Txx） | 验收基准/资产缺失，原因在项目控制范围外 | 否 |

**确定性场景结论：A 类 23 项 100% 通过，0 失败；B 类 12 项无阻断偏差，逐项列于第 5 节。**

不使用"全部通过"或"100% 复刻完成"这类无主语表述。

## 4. 环境约束清单

以下三条是**外部约束**，不是未完成的工作项。

| 编号 | 约束 | 直接后果 | 处理方式 |
|---|---|---|---|
| E1 | 无 iOS 真机，仅有模拟器 | 相机取景、权限弹窗真机时序、通讯录真实读写、系统分享面板、系统 App 调起无法执行 | 逻辑层由 L1/L2 覆盖；操作步骤写成可转移程序 [`verify/manual-device-checklist.md`](verify/manual-device-checklist.md)，交有设备者执行，本文件不预填结论 |
| E2 | 模拟器无相机、无通讯录数据库 | T03–T07 的采集段、T31–T33 的写入段无法端到端自动化 | 用 `-ui-testing-capture` 注入合成名片覆盖采集之后的管线；通讯录走 `ContactsMapper` + `DetailViewModel` 双层替身 |
| E3 | 教师未下发 Reference Test Suite 与 30–50 张正式测试名片 | 无法执行教师口径的 20 条用例，也无法产出教师口径的字段级准确率 | 以作业原文 T01–T20 建自建映射；准确率只报自建数据集绝对值，并标注样本量（合成 15 例、真实 14 例，均 < 30） |

## 5. 逐项结论（T01–T35）

> 类别定义见第 3 节。B 类一律不写"通过"。

| ID | 场景 | 类别 | 自动化证据 | 残余风险 |
|---|---|---|---|---|
| T01 | 首次启动 → 空名片夹 | A | `LaunchUITests.testAppLaunchesToEmptyCardHolder` | — |
| T02 | 名片夹 → 扫描 → 相机页 | A | `CaptureUITests.testT02OpenScannerAndReturn` | 无相机时走 `.denied` 分支 |
| T03 | 相机权限允许 / 拒绝 | B | `CaptureUITests` 进入扫描页时会解除系统弹窗，但未断言两条分支 UI | 拒绝分支需系统设置页操作，仅真机可执行 |
| T04 | 拍摄标准名片 → 进入识别 | B | `DetectionUITests.testRotateNoticeThenConfirmEntersReview`（注入图走完整管线） | 真实快门与对焦未验证 |
| T05 | 相册导入 → 进入识别 | B | 导入后管线同 T04 注入路径 | `PhotosPicker` 为系统 UI，无法稳定驱动 |
| T06 | 倾斜名片 → 检测并显示区域 | B | `CardDetectorTests.testT06DetectsTiltedCard`、`CardDetectorTests.testT06DetectsClearCardOnContrastBackground`、`CropViewModelTests.testT06KeepsDefaultPointsWhenDetectionReturnsNil` | 八类拍摄条件完整覆盖 3/8；真实拍摄 11/14 检出 |
| T07 | 标准名片 → OCR 原始文本 | B | `OCRServiceTests.testT07RecognizesSyntheticCardText`、`OCREvaluationTests`（15 例）、`RealCardEvaluationTests`（14 例） | 真实拍摄下 OCR 非空 12/14 |
| T08 | OCR → 八字段分类 | A | `FieldParserTests.testT08StandardEnglishCard` | — |
| T09 | 无 Website → 不得虚构 | A | `FieldParserTests.testT09MissingWebsiteIsNotFabricated`、`NoFabricationTests` | 虚构字段计数 0 |
| T10 | 多电话 → Mobile/Office/Fax | A | `FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests` | — |
| T11 | 人工修改 → 保存修改结果 | B | `ReviewViewModelTests.testT11ManualCorrectionPersistsEditedFields` | 校正页 UI 未自动化 |
| T12 | 保存 → 返回名片夹出现新名片 | B | `ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord`、`CardListUITests.testT34CreateCardManually` | 扫描保存后的列表跳转未单独断言 |
| T13 | 打开名片 → 显示全部字段 | A | `DetailUITests.testT13OpenDetailShowsSavedFields`、`DetailUITests.testT13EmptyFieldsAreNotShown` | — |
| T14 | 编辑姓名/公司 → 保存 → 更新 | A | `DetailUITests.testT14EditNamePersistsInDetail` | — |
| T15 | 搜索姓名 / 公司 | A | `SearchTagsUITests.testT15SearchByName`、`testT15SearchByCompany` | — |
| T16 | 添加标签 → 编辑页可见 | A | `SearchTagsUITests.testT16TagIsEditableAndHiddenOnHome`、`RepositoryTests.testTagCreationIsCaseInsensitive` | 标签删除按钮无 UI 断言，由 `RepositoryTests.testDeleteTagRemovesItFromCards` 覆盖 |
| T17 | 删除名片 → 从列表消失 | A | `CardListUITests.testT17DeleteCardRemovesItFromList` | — |
| T18 | Kill App → 重启 → 数据保持 | A | `PersistenceUITests.testT18DataSurvivesRelaunch`、`PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen` | 模拟器 `terminate` 等价于进程终止；未在真机复跑 |
| T19 | 导出 → 字段映射正确 | B | `VCardBuilderTests.testT19FieldMapping`、`VCardExporterTests`（5 项） | 系统分享面板未验证，落盘内容正确 |
| T20 | 取消 / 返回 / 重拍 / 无法识别 / 空字段 | A | `CaptureUITests.testT20ExitWithoutDraft`、`DetectionUITests.testRetakeFromAdjustReturnsToScanner`、`testRotateNoticeThenConfirmEntersReview`、`ReviewViewModelTests.testEmptyCardRequiresConfirmation`、`testFaxOnlyCardIsNotTreatedAsEmpty` | 权限拒绝分支并入 T03 |
| T21 | 创建分组 → 按分组筛选 | A | `CardListUITests.testT21CreateGroupAndFilter` | — |
| T22 | 删除分组 → 名片回到未分组 | A | `CardListUITests.testT22DeleteGroupMovesCardToUngrouped` | — |
| T23 | 详情展示所属分组 | A | `DetailUITests.testT23DetailShowsGroup` | — |
| T24 | 主页按日期分组 | A | `CardListUITests.testT24HomeGroupsByCreatedDate` | — |
| T25 | 主页深色外观与常驻入口 | A | `CardListUITests.testT25HomeKeepsPersistentEntries` | 配色为功能性验证，未做像素级断言 |
| T26 | 详情核心资料与快捷操作 | A | `DetailUITests.testT26ProfileAndQuickActions`、`testT26AddressActionDisabledWithoutAddress` | 电话/地图/邮件/浏览器的真实调起未验证 |
| T27 | 收藏状态持久化 | A | `DetailUITests.testT27FavoritePersists`、`DetailViewModelTests.testToggleFavoritePersists`、`PersistenceTests.testT27FavoriteSurvivesReopen` | — |
| T28 | 查看原图 | A | `DetailUITests.testT28ViewOriginalImage` | — |
| T29 | 低置信度字段展示待核对 | A | `DetailUITests.testT29ReviewBadgeIsShown`、`DetailViewModelTests.testContactEntriesCarryReviewFlag`、`UnverifiedValueDetectorTests` | — |
| T30 | 编辑修正后待核对消失 | B | `DetailViewModelTests.testSavingCorrectedValueClearsReviewFlag`、`ReviewViewModelTests.testCorrectedValueClearsUnverifiedFlag` | 功能已完成；手机号为多行 `TextField`，Form 中无法稳定取得焦点，UI 断言未落地 |
| T31 | 存入通讯录成功 | B | `DetailViewModelTests.testSaveToContactsSuccessDisablesButton`、`ContactsMapperTests`（5 项） | 真实写入系统通讯录未验证 |
| T32 | 通讯录权限拒绝 | B | `DetailViewModelTests.testSaveToContactsDeniedNeedsSettings` | 权限弹窗交互未验证 |
| T33 | 重复联系人提示 | B | `DetailViewModelTests.testSaveToContactsAlreadyExistsShowsMessage`、`ContactsMapperTests.testComparableValuesNormalizePhonesAndEmails` | 真实通讯录比对未验证 |
| T34 | 手动新建无原图名片 | A | `CardListUITests.testT34CreateCardManually` | UI 只录入姓名，手机号由 L2 覆盖 |
| T35 | 手动新建空卡 → 二次确认 | A | `CardListUITests.testT35EmptyManualCardRequiresConfirmation` | — |

## 6. 概率性功能结论

| 项 | 数据 | 结论 | 局限 |
|---|---|---|---|
| 合成集字段抽取 | 15 例，虚构字段 0 | 字段级基线已建立 | 样本 < 30，只报绝对值 |
| 真实名片集 | 14 张，虚构字段 0，检测 11/14，OCR 非空 12/14 | 真实拍摄下可用 | 样本 < 30；未与 CamCard 对比 |
| 边界检测 | 成功率 11/14 | 可用 | 八类拍摄条件完整 3/8、缺失 2/8 |
| 人工校正成本 | 未产出 | 缺口 | 不影响确定性判定 |

依据：[`eval/ocr-field-baseline.md`](eval/ocr-field-baseline.md)、[`eval/real-card-baseline.md`](eval/real-card-baseline.md)、[`eval/detection-report.md`](eval/detection-report.md)。

准确率不达标不阻断交付；**虚构字段**为阻断缺陷，当前计数 0。

## 7. 条件具备后的补齐路径

1. 拿到真机：按 [`verify/manual-device-checklist.md`](verify/manual-device-checklist.md) 逐条执行，在 `docs/verify/manual-device-<YYYYMMDD>.md` 回填，B 类转 A 类。
2. 拿到教师 RTS：建立条目映射，补执行记录；冲突处另开 change。
3. 拿到 30–50 张正式名片集与 Ground Truth：重跑评估，替换现有基线，样本 ≥ 30 后可报百分比指标。

以上三项均不改变现有实现，只补充验证与映射。
