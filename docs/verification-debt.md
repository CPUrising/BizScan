# 验证台账

> 背景：验证基线在 macOS 26.3.1 + Xcode 26.1.1 + iPhone 16 模拟器（iOS 18.0）上取得；项目自始至终**无 iOS 真机**，教师也**未下发 Reference Test Suite 与 30–50 张正式测试名片**。
> 本台账把"未验证"显式记账，避免把未验证代码当成已通过。
> 唯一对外结论见 [`acceptance-report.md`](acceptance-report.md)；本文件只负责逐条记录"每条结论靠什么支撑"。

## 1. 类别定义

| 类别 | 含义 | 是否计入通过率 | 关闭条件 |
|---|---|---|---|
| **A 已验证** | 有真实执行证据（L1 / L2 / UI），可点开日志或 `.xcresult` | 是 | 执行通过并写入 `docs/verify/` |
| **B 行为已覆盖，系统集成未验证** | 判定逻辑有代码级测试；剩余部分依赖真机硬件或系统 App | 否 | 只能由真机执行转换；无真机时长期保持 B |
| **C 环境不可达** | 验收基准或测试资产缺失，原因在项目控制范围外 | 否 | 外部条件具备后才能关闭 |
| **执行失败** | 已运行且失败 | 是（记为失败） | 修复实现或测试后重跑 |

规则：

1. **B / C 不得使用"通过"二字**，也不得被合并进"部分通过"这类中间态。
2. A 类必须能链接到具体 `docs/verify/<change>.md` 的 PASS 行。
3. 环境不可达不等于欠账：无真机项记录为 B，基准缺失记录为 C，二者都不写成"待执行"。
4. 禁止通过放宽断言让结果变绿。

## 2. L1：BizScanCore（跨平台，`swift test` 即可执行）

| 模块 | 应测项 | 测试文件 | 类别 | 备注 |
|---|---|---|---|---|
| `BusinessCard` | 字段契约、标题回退、空判定、时间戳 | `BusinessCardTests` | A | 5 项，`0010` 验证 |
| `ContactNormalizer` | 全角半角、号码归一、邮箱/网址校验 | `ContactNormalizerTests` | A | 7 项，`0010` 验证 |
| `PhoneClassifier` | 手机/办公/传真判定、标签优先 | `PhoneClassifierTests` | A | 8 项，`0010` 验证 |
| `FieldParser` | T08/T09/T10、中英混排、人名公司混淆、多行地址 | `FieldParserTests` | A | 13 项，`0010` 验证 |
| `FieldParser`（不虚构） | 缺失字段、歧义保留、无占位符 | `NoFabricationTests` | A | 7 项，阻断级要求已满足 |
| `VCardBuilder` | T19 映射、多值、转义、75 字节折行 | `VCardBuilderTests` | A | 7 项，`0010` 验证 |
| `SearchQuery` | T15 多字段搜索、格式无关匹配 | `SearchQueryTests` | A | 8 项，`0010` 验证 |
| `TagStore` | T16 标签创建/复用/删除/筛选 | `TagStoreTests` | A | 7 项，`0010` 验证 |
| `UnverifiedValueDetector` | 低置信度与歧义标记、修正后清除 | `UnverifiedValueDetectorTests` | A | `0021` 验证 |

证据：[`verify/0010-toolchain-compile-fixes.md`](verify/0010-toolchain-compile-fixes.md)（core 62 项全绿）、[`verify/0022-save-to-contacts.md`](verify/0022-save-to-contacts.md)（core 累计 69 项全绿）。

## 3. L2：iOS 层（必须 macOS 或 CI）

| 模块 | 应测项 | 测试文件 | 类别 | 备注 |
|---|---|---|---|---|
| `Persistence/BusinessCardRepository` | T12/T17/T18、重启保持、文件清理 | `RepositoryTests`（6）+ `PersistenceTests`（6）+ `PersistenceUITests`（1） | A | 真机 kill 未复跑；模拟器 `terminate/relaunch` 等价覆盖 |
| `ViewModels/ReviewViewModel` | T11 校正落库、T12 首次保存写图、空名片二次确认、连点不重复、仅传真号不判空 | `ReviewViewModelTests` | A | `0011`/`0021`；校正页 UI 未自动化 |
| `ViewModels/DetailViewModel` | 详情字段、收藏、快捷操作 URL、头像首字、备注增删改、通讯录状态机 | `DetailViewModelTests`（9） | A | `0011`/`0020`/`0022` |
| `Views/DetailView` | 自定义顶栏、快捷操作、原图查看、收藏、待核对标签、底部按钮 | `DetailUITests`（8） | A | `0020`/`0021`/`0022`；外部 App 调起未验证 |
| 待核对标记（T30） | 编辑修正后标签消失 | `DetailViewModelTests.testSavingCorrectedValueClearsReviewFlag`、`ReviewViewModelTests.testCorrectedValueClearsUnverifiedFlag` | B | 功能已完成；手机号为多行 `TextField`，Form 中无法稳定取得焦点，UI 断言未落地 |
| `ViewModels/HomeViewModel` | 列表排序、删除、日期分组、分组筛选与移动 | `HomeViewModelTests`（7） | A | `0011`/`0017`/`0019` |
| `Views/HomeView` | 深色外观、日期分组、常驻入口、行菜单删除 | `CardListUITests`（9）/ `LaunchUITests`（1） | A | `0019`；深色配色未做像素级断言 |
| `ViewModels/GroupViewModel` | 分组计数、新建去重、重命名冲突、删除后计数 | `GroupViewModelTests`（4） | A | `0017` |
| `ViewModels/NewCardViewModel` | 无图保存、空卡确认、分组写入、标签编辑 | `NewCardViewModelTests`（4） | A | `0018` |
| `Views/EditCardView` | 编辑页标签删除按钮 | `RepositoryTests.testDeleteTagRemovesItFromCards` | A | 删除能力已实现；UI 层未单独断言，由仓储层覆盖 |
| `Services/ContactsMapper` | 名片 → CNContact 字段映射、号码归一、去重值 | `ContactsMapperTests`（5） | A | `0022` |
| 存入通讯录（T31–T33） | 真实写入、权限拒绝、重复联系人 | `DetailViewModelTests` 三项 | B | 真实通讯录读写与权限弹窗需真机，程序见 `manual-device-checklist.md` 第 8b 节 |
| `Services/CardDetector` | T06 边界检测、八类拍摄条件 | `CardDetectorTests`（4）+ `CropViewModelTests`（5） | B | 合成图检测通过；八类拍摄条件需真机人工清单 |
| `Services/ImageCorrector` | 透视/方向校正 | `ImageCorrectorTests`（3）+ `CropViewModelTests` | A | 透视输出尺寸、四档旋转、nil quad 原样 |
| `Services/OCRService` | T07 原始文本与坐标 | `OCRServiceTests`（3）+ `OCREvaluationTests`（15）+ `RealCardEvaluationTests`（14） | B | 真实 Vision 已跑；真实拍摄未验证 |
| `Services/ScanPipeline` | 检测→校正→OCR→解析接线 | `ScanPipelineTests`（4） | A | 替身接线、OCR 失败保留原图、无效图拒绝 |
| OCR/字段准确率基线 | 字段级精确率/召回率、虚构字段计数 | `OCREvaluationTests`（15 例合成） | A | `0014`；样本 < 30 只报绝对值 |
| 真实名片准确率基线 | 真实拍摄条件下的字段指标 | `RealCardEvaluationTests`（14 例本机名片） | A | `0015`；检测 11/14、OCR 12/14；图片不入库 |
| `Services/VCardExporter` | 文件写出与分享 | `VCardExporterTests`（5） | B | 落盘内容正确；系统分享面板未验证 |
| `Views/*` + `ViewModels/*` | T01–T35 全链路 | 7 个 UI 测试套件，26 项 | A | `0021`/`0022` 基线全绿；逐项见 `acceptance-report.md` |
| `BizScanApp` 种子数据 | 确定性初始状态 | `-ui-testing-seed` 注入 3 张名片 | A | T13–T25、T34–T35 已用种子数据跑通 |
| `project.yml` | XcodeGen 生成与编译 | `xcodebuild build` | A | 编译 0 error（`0010`） |

证据：[`verify/local-20261106.md`](verify/local-20261106.md)（core 62 + L2 54 + UI 12）、[`verify/0021-review-flags.md`](verify/0021-review-flags.md)（core 69 + L2 81 + UI 26）、[`verify/0022-save-to-contacts.md`](verify/0022-save-to-contacts.md)（core 69 + L2 89 + UI 26，当前冻结基线）。

### 3.1 已知产品偏差

| 编号 | 现象 | 影响 | 状态 |
|---|---|---|---|
| K1 | `ReviewViewModel.isEmptyCard` 未统计 `faxes`，仅含传真号的名片会被判为空卡并触发二次确认 | T20「空名片保存」的判定边界 | 已修复，`local-20261106` 补测通过 |
| K2 | 存入通讯录后「已存入」状态不持久化，重进详情会复位 | 重复点击防护仅限当前页面 | 设计未定义，`0022` D4 登记 |

## 4. 环境不可达（B 类明细与 C 类基准缺口）

### 4.1 B 类：行为已覆盖，系统集成未验证

| 项 | 不可达原因 | 已覆盖的判定点 | 未覆盖的动作 | 交接方式 |
|---|---|---|---|---|
| T03 相机权限允许/拒绝 | 需真机系统设置页 | 无相机时进入 `.denied` 分支 | 两条权限分支的 UI 与恢复 | 清单第 1–2 节 |
| T04 拍摄 → 识别 | 模拟器无相机 | 注入图走完检测→校正→OCR→确认 | 真实快门、对焦、曝光 | 清单第 3 节 |
| T05 相册导入 | `PhotosPicker` 为系统 UI | 导入后管线同 T04 | 选择器交互、权限拒绝 | 清单第 4 节 |
| T06 倾斜检测 | 需真实拍摄条件 | 合成图检测、回退逻辑 | 八类拍摄条件中的 5 类 | 清单第 5 节 |
| T07 真实拍摄 OCR | 需真实拍摄 | Vision 文本与坐标、两份评估基线 | 真实拍摄下的字符质量 | 清单第 3–5 节 + `docs/eval/` |
| T11 校正页 UI | 需相机入口 | 校正落库与字段持久化 | 页面内修改交互 | 随 T04/T05 一并执行 |
| T12 扫描保存 → 列表 | 需相机入口 | 保存写图与记录、手动新建后列表更新 | 扫描保存后的列表跳转 | 随 T04 一并执行 |
| T19 分享面板 | 系统分享 UI | vCard 生成与落盘内容 | 分享面板展示与「存储到文件」 | 清单第 8 节 |
| T30 待核对消失 | 多行 `TextField` 焦点不稳定 | 保存时清除标记的两条 L2 路径 | 编辑页内修正的 UI 断言 | 若需自动化，需改造输入控件 |
| T31–T33 通讯录 | 模拟器无通讯录数据库 | 字段映射、权限状态机、去重判定 | 真实写入/拒绝/重复比对 | 清单第 8b 节 |

### 4.2 C 类：基准与资产缺口

| 项 | 原因 | 影响 | 补齐条件 |
|---|---|---|---|
| Reference Test Suite | 教师未下发 | 无法执行教师口径的 T01–T20，只能自建等价映射 | 下发后补映射，不改实现 |
| 30–50 张正式测试名片 + Ground Truth | 教师未下发 | 准确率只能报自建样本绝对值（15 例合成 / 14 例真实） | 下发后重跑评估并替换基线 |
| CamCard 参考版本与观察基线 | 无参考 App 版本锁定与观察记录 | 无法声明与参考产品行为等价 | 提供版本号与观察环境 |

## 5. 结算规则

1. `swift test --package-path Packages/BizScanCore` → 维护第 2 节。
2. `bash scripts/verify.sh --scope unit` → 维护第 3 节 L2 行。
3. `bash scripts/verify.sh --scope all` → 维护 UI 与集成行。
4. 每批执行后更新本表类别，并在 `docs/verify/<change>.md` 留证据。
5. A 类全绿、B 类无阻断偏差、C 类已声明，才允许 `openspec archive`。
6. 文档修订不触发重跑；结论以冻结基线为准，见 `acceptance-report.md` 第 2 节。

## 6. 风险提示

- B 类的"系统集成未验证"是真实风险，不是形式问题：真实相机画质与真实通讯录行为都可能暴露模拟器看不到的缺陷。
- `FieldParser` 的启发式规则只能在固定名片集上评估，不能以"看起来对"结案。
- 本台账不能替代教师 RTS 的 100% 通过要求；RTS 未下发期间，任何"等价通过"的表述都属于越权声明。
