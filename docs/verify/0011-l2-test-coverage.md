# 验证报告：0011-l2-test-coverage

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0011-l2-test-coverage` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无（本轮全部为 L1/L2 自动化，不涉及相机与分享系统 UI） |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage` |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本轮共尝试四次，前三次均因执行环境失败、非测试断言失败（见第 4 节 D1/D2）；本报告结论依据第四次 `--scope all` 的全绿运行。

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 中声明 `skip_specs: true`：不新增、不修改任何 `ADDED / MODIFIED` 的 Scenario，只为既有 Txx 补 L2 单元证据。因此本节按 `docs/traceability.md` 中本轮欲补的四项逐条登记。

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `verification` | T11 人工修改 OCR 字段 → 保存后落库 | `BizScanTests.ReviewViewModelTests.testT11ManualCorrectionPersistsEditedFields`、`testInitPrefillsParsedFieldsFromScanResult` | PASS（L2） | 断言校正后的姓名/公司/职位/部门/手机（多行拆分）/邮箱/网站/地址/邮编全部按编辑值落库；UI 行见下 |
| `verification` | T11 校正页 UI 交互 | — | NOT RUN | Review 入口依赖相机/相册，UI 自动化不可达；不阻断归档（L2 已覆盖同一 ViewModel 合同） |
| `card-list` | T12 保存后名片夹出现新名片 | `BizScanTests.ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord`、`BizScanTests.HomeViewModelTests.testReloadSortsByUpdatedAtDescending` | PASS（L2） | 首次保存写入原图/处理图相对路径且记录可被列表按 `updatedAt` 倒序取回；UI 行见下 |
| `card-list` | T12 保存后返回列表的 UI 跳转 | — | NOT RUN | 同上，入口不可达；不阻断归档 |
| `persistence` | T18 Kill App → 重启数据保持 | `BizScanTests.PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen` | PASS（L2） | 同一 sqlite URL 释放并重建 `ModelContainer`，断言 11 个业务字段、标签、备注与两个图像路径全部保留 |
| `persistence` | T18 真机杀掉进程后重启 | — | NOT RUN | 需真机或 `XCUIApplication.terminate()`；不阻断归档（容器重建等价覆盖磁盘持久化） |
| `export` | T19 导出 vCard 字段映射 | `BizScanCoreTests.VCardBuilderTests`（7 项，L1）+ `BizScanTests.VCardExporterTests`（5 项，L2） | PASS（L1+L2） | L2 断言文件以 `BEGIN:VCARD\r\n` 开头、`FN`/`ORG`/`TEL;TYPE=CELL`/`ADR;TYPE=WORK` 写在预期行、缺 Website 不写 `URL:`、空数组抛 `ExportError.noCards`、落盘路径在临时目录且后缀 `.vcf` |
| `export` | T19 分享面板 UI | — | NOT RUN | ShareSheet 为系统 UI，无法稳定自动化；不阻断归档 |

同一批次顺带覆盖的既有 Txx（本 change 未改动其实现，仅新增回归保护）：

| Scenario | 测试方法（类/方法） | 结果 |
|---|---|---|
| T13 打开名片 → 全部字段 | `DetailViewModelTests.testLoadPopulatesDisplayRows` | PASS（L2） |
| T14 编辑姓名 → 保存 | `DetailViewModelTests.testSaveWritesEditedNameAndTouchesUpdatedAt`、`testCancelEditingRestoresOriginalValues` | PASS（L2） |
| T16 加标签 → 按标签筛选 | `DetailViewModelTests.testAddTagThenSavePersistsToRepository`、`HomeViewModelTests.testToggleTagFilterShowsOnlyTaggedCards` | PASS（L2） |
| T17 删除名片 → 从列表消失 | `DetailViewModelTests.testDeleteRemovesCardAndSetsDidDelete`、`HomeViewModelTests.testDeleteRemovesCardFromList`、`PersistenceTests.testDeleteCardRemovesImageFiles` | PASS（L2） |
| T20 空名片保存 → 二次确认 | `ReviewViewModelTests.testEmptyCardRequiresConfirmation` | PASS（L2） |
| T12 重复保存不产生第二条记录 | `ReviewViewModelTests.testSavingExistingCardKeepsIDAndDoesNotDuplicate` | PASS（L2） |
| 图像存储读写 | `PersistenceTests.testFileImageStoreRoundTrip` | PASS（L2） |

执行到的测试套件明细：

| 层 | 测试套件 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore（L1） | `BusinessCardTests` / `ContactNormalizerTests` / `FieldParserTests` / `NoFabricationTests` | 5 / 7 / 13 / 7 | PASS |
| BizScanCore（L1） | `PhoneClassifierTests` / `SearchQueryTests` / `TagStoreTests` / `VCardBuilderTests` | 8 / 8 / 7 / 7 | PASS |
| BizScanCore（L1） | **小计** | **62** | **PASS，0 失败** |
| BizScanTests（L2） | `RepositoryTests` / `SmokeTests` | 6 / 1 | PASS |
| BizScanTests（L2） | `VCardExporterTests` / `ReviewViewModelTests` | 5 / 5 | PASS |
| BizScanTests（L2） | `DetailViewModelTests` / `HomeViewModelTests` | 5 / 3 | PASS |
| BizScanTests（L2） | `PersistenceTests` | 4 | PASS |
| BizScanTests（L2） | **小计** | **29**（新增 22） | **PASS，0 失败** |
| BizScanUITests（UI） | `CaptureUITests` / `CardListUITests` / `DetailUITests` / `LaunchUITests` / `SearchTagsUITests` | 2 / 3 / 2 / 1 / 3 | PASS |
| BizScanUITests（UI） | **小计** | **11** | **PASS，0 失败** |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all`（内含 `swift test --package-path Packages/BizScanCore`） | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上（`-only-testing:BizScanTests`） | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上（`-only-testing:BizScanUITests`） | PASS：11 个用例，0 失败（测试执行 90.860 秒） |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退：core 62 项与 `0009`/`0010` 基线一致；UI 11 项与 `0009` 第二轮基线一致 |

编译侧：`xcodebuild test` 0 error；`xcodegen generate` 成功（新增 5 个测试文件经目录级 `sources` 自动纳入 `BizScanTests`）。

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 首轮 `20261027-182309` 与次轮 `20261027-182948` 均报 `The test runner hung before establishing connection`（exit 65），日志无任何 `Test Case` 行 | 一般 | **已关闭**：`xcrun simctl list devices available` 显示 iPhone 16 为 `Shutdown`；`simctl bootstatus -b` 启动后仍未恢复。根因是模拟器设备状态损坏（`simctl install/launch` 亦永久挂起、界面白屏），执行 `simctl shutdown all` + `erase` 后重建 |
| D2 | 在 Agent 终端内触发 `--scope all` 时再次白屏并输出 `DTServiceHubClient failed to bless service hub`，UI 测试无法连接（该次运行已中止并删除半成品日志/结果包） | 一般 | **已规避**：改在项目所有者本地终端执行同一命令，`--scope all` 全绿；属执行会话差异，非测试或实现缺陷 |
| D3 | `ReviewViewModel.isEmptyCard` 未统计 `faxes`，仅含传真号的名片会被判定为空卡（触发二次确认） | 一般 | 未修复：属产品行为，超出本 change「只补测试」范围，已登记至 `docs/verification-debt.md` |
| D4 | T11/T12/T18/T19 的 UI 行全部 NOT RUN | 一般 | 已接受：Review 入口依赖相机/相册，`-ui-testing` 强制内存容器与真实落盘互斥，ShareSheet 为系统 UI；L2 覆盖同一 ViewModel/存储合同，不阻断归档，理由记入 `0011/design.md` |

风险：T18 用「同一 sqlite URL 释放后重建 `ModelContainer`」模拟重启，未覆盖「进程被系统杀死时 sqlite 未正常关闭」的极端情况；该风险已登记在 `docs/verification-debt.md`。

## 5. 结论

- [x] Ready for archive：所有本 change 声明的 Scenario 均 PASS（L1/L2），NOT RUN 项均为已知不可自动化且不阻断
- [ ] 需修复后复验
- [ ] 需人类决策

补充说明：

1. 本 change 只新增测试，未改动 `BizScan/`、`Packages/BizScanCore/` 任何产品代码；新增文件仅为 `BizScanTests/` 下 6 个文件与 `openspec/changes/0011-l2-test-coverage/`（工作区中 `ScannerView.swift`、`SearchView.swift`、UI 测试与 `scripts/verify.sh` 的改动来自 `0009`，不属于本 change）。
2. 新增的 22 个 L2 用例使 `BizScanTests` 从 7 项扩到 29 项，T11/T12/T18/T19 由此获得首个自动化证据。
3. 后续文档口径统一（`docs/verify/0001`–`0008` 回填、`AGENTS.md` / `verification-debt.md` / `traceability.md` / `README.md` 同步）在 `0012-evidence-and-doc-alignment` 中完成，本报告不代填。
4. 本报告依据 `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` 与同名 `.xcresult` 的实际输出填写，未预填任何结论。
