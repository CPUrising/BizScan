# 验证报告：0009-acceptance-hardening

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0009-acceptance-hardening` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 17:50:53 – 17:52:41（Asia/Shanghai） |
| 机器 | macOS 26.3.1（25D2128） |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无（模拟器无相机，相机相关场景以 `.denied` 分支与图片注入路径覆盖） |
| 命令 | `bash scripts/verify.sh --scope ui --change 0009-acceptance-hardening` |
| 日志 | `artifacts/verify-0009-acceptance-hardening-20261027-175053.log` |
| 结果包 | `artifacts/verify-0009-acceptance-hardening-20261027-175053.xcresult` |

本轮共执行两次：首轮 `20261027-173838` 为 11 个用例 / 5 个失败（见第 4 节 D1）；本报告结论依据修复后的第二轮全绿运行。

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 中声明 `skip_specs: true`：不新增、不修改任何 `ADDED / MODIFIED` 的 Scenario，只把既有规范变成可执行的验收结果。因此本节按 `docs/traceability.md` 的 T01–T20 逐条登记实际执行结果。

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `card-list` | T01 首次启动 → 空名片夹 | `BizScanUITests/LaunchUITests.testAppLaunchesToEmptyCardHolder` | PASS | 容器标识下发给子元素，断言按整棵 AX 树查找 |
| `capture` | T02 名片夹 → 扫描 → 相机页 | `BizScanUITests/CaptureUITests.testT02OpenScannerAndReturn` | PASS | 模拟器无相机，走 `.denied` 分支后经关闭入口返回名片夹 |
| `capture` | T03 权限允许 / 拒绝 | — | NOT RUN | 需真机或系统权限弹窗；模拟器无法稳定复现 |
| `capture` | T04 拍摄 → 进入识别 | — | NOT RUN | 需真机相机；模拟器无相机 |
| `capture` | T05 相册导入 → 进入识别 | — | NOT RUN | 测试未写（tasks 1.2 剩余部分） |
| `card-detection` | T06 倾斜名片自动识别 | — | NOT RUN | `CardDetectorTests` / `DetectionUITests` 未写（tasks 1.3） |
| `ocr` | T07 标准名片产生原始文本 | — | NOT RUN | `OCRServiceTests` 未写（tasks 1.9） |
| `field-extraction` | T08 标准名片八字段分类 | `BizScanCoreTests/FieldParserTests.testT08StandardEnglishCard` | PASS | L1 单测；端到端（OCR→解析）未覆盖 |
| `field-extraction` | T09 无 Website 不得虚构 | `BizScanCoreTests/FieldParserTests.testT09MissingWebsiteIsNotFabricated`、`NoFabricationTests`（7 项） | PASS | 阻断级要求，虚构字段为 0 |
| `field-extraction` | T10 多电话分流 | `BizScanCoreTests/FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests`（8 项） | PASS | L1 单测 |
| `verification` | T11 人工修改 → 保存 | — | NOT RUN | `VerificationUITests` 未写（tasks 1.4） |
| `card-list` | T12 保存后名片夹出现新名片 | `CardListUITests.testSeededCardsAppearInList`（仅覆盖种子列表渲染） | NOT RUN | T12 的保存链路测试未写（tasks 1.1 剩余部分） |
| `card-detail` | T13 打开名片 → 全部字段 | `CardListUITests.testT13OpenDetailShowsSavedFields`、`DetailUITests.testT13EmptyFieldsAreNotShown` | PASS | 两张用例分别覆盖有值字段与空字段隐藏 |
| `card-detail` | T14 编辑姓名 → 保存 | `BizScanUITests/DetailUITests.testT14EditNamePersistsInDetail` | PASS | 编辑后详情页回读一致 |
| `search-tags` | T15 按姓名/公司搜索 | `SearchTagsUITests.testT15SearchByName`、`testT15SearchByCompany`、`BizScanCoreTests/SearchQueryTests`（8 项） | PASS | UI 断言已限定到结果列表，避免命中 sheet 背景列表 |
| `search-tags` | T16 加标签 → 按标签筛选 | `SearchTagsUITests.testT16TagFilterShowsOnlyTaggedCards`、`TagStoreTests`（7 项） | PASS | 筛选与「全部」还原均通过 |
| `card-list` | T17 删除名片 → 从列表消失 | `BizScanUITests/CardListUITests.testT17DeleteCardRemovesItFromList` | PASS |  |
| `persistence` | T18 Kill App → 重启数据保持 | — | NOT RUN | `PersistenceUITests` 未写（tasks 1.7） |
| `export` | T19 导出 vCard 字段映射 | `BizScanCoreTests/VCardBuilderTests.testT19FieldMapping`（7 项） | PASS（仅 L1） | 文件写出与分享 UI 未测（`VCardExporterTests` 未写） |
| `capture` | T20 中途退出 | `BizScanUITests/CaptureUITests.testT20ExitWithoutDraft` | PASS | 退出后既有名片不受影响 |
| `card-detection` | T20 校正页重拍 | — | NOT RUN | 测试未写（tasks 1.3） |
| `verification` | T20 空名片保存 | — | NOT RUN | 测试未写（tasks 1.4） |

执行到的测试套件明细：

| 层 | 测试套件 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore | `BusinessCardTests` / `ContactNormalizerTests` / `FieldParserTests` / `NoFabricationTests` | 5 / 7 / 13 / 7 | PASS |
| BizScanCore | `PhoneClassifierTests` / `SearchQueryTests` / `TagStoreTests` / `VCardBuilderTests` | 8 / 8 / 7 / 7 | PASS |
| BizScanCore | **小计** | **62** | **PASS，0 失败** |
| UI | `CaptureUITests` | 2 | PASS（T02、T20） |
| UI | `CardListUITests` | 3 | PASS（T13、T17、种子列表） |
| UI | `DetailUITests` | 2 | PASS（T13 空字段、T14） |
| UI | `LaunchUITests` | 1 | PASS（T01） |
| UI | `SearchTagsUITests` | 3 | PASS（T15×2、T16） |
| UI | **小计** | **11** | **PASS，0 失败** |

未执行项：

| 项 | 原因 | 是否阻断归档 |
|---|---|---|
| `BizScanTests`（iOS 单元：`RepositoryTests` 6 + `SmokeTests` 1） | `--scope ui` 按 `verify.sh` 设计只跑 core + UI；本轮未重跑，最近证据为 `0010` | 是（归档前需补 `--scope unit`，tasks 3.2） |
| T03–T07、T11、T12、T18、T19（UI/集成）、T20（重拍、空名片） | 测试尚未编写（tasks 1.1–1.9） | 是 |
| `docs/eval/*.md` 四份评估报告 | 评估流程未执行（tasks 2.1–2.4） | 是 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope ui`（内含 `swift test`） | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2 单元） | `bash scripts/verify.sh --scope unit` | NOT RUN（本轮未执行；`0010` 记录为 7/7 通过，本 change 未改动相关代码） |
| 全量 UI 测试 | `bash scripts/verify.sh --scope ui`（`-only-testing:BizScanUITests`） | PASS：11 个用例，0 失败，`** TEST SUCCEEDED **`（测试执行 101.777 秒） |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退：core 62 项与 `0010` 基线一致；UI 为首次全绿基线 |

编译侧：`xcodebuild test` 0 error；仅 3 条 `appintentsmetadataprocessor` 的 `Metadata extraction skipped. No AppIntents.framework dependency found.` 提示（无 AppIntents 依赖，属正常）。

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 首轮 `20261027-173838` 运行 11 用例 / 5 失败：`LaunchUITests` 1、`SearchTagsUITests` 2（T15）、`CaptureUITests` 2（T02/T20） | 一般 | **已关闭**：用 xcresult 的 AX 层级快照定位后区分——3 项测试错误（容器标识误用 `otherElements`、断言未限定作用域、未先关闭错误提示）、1 项实现缺口（`.denied` 分支缺统一关闭标识）、1 项工具链缺陷（`$STATUS` 后接全角括号）。修复项见 `tasks.md` 第 4 节，第二轮全绿 |
| D2 | 模拟器无相机时同时展示「需要相机权限」页与「当前设备没有可用的相机」提示框，文案互相冲突 | 一般 | 未修复：属行为变更，需新开 change；本轮测试以「先点完成关闭提示」规避，不影响 T02/T20 判定 |
| D3 | `--scope ui` 不含 iOS 单元测试（`BizScanTests`），本轮 `RepositoryTests` / `SmokeTests` 未重跑 | 一般 | 未关闭：归档前需补跑 `--scope unit`（tasks 3.2） |
| D4 | `xcodebuild` 提示 `Using the first of multiple matching destinations`（同一 UDID 同时存在 arm64 / x86_64 两条记录） | 一般 | 实际选中 `arch:arm64, OS:18.0`，与 `0010` 的 D2 同源，结果有效 |
| D5 | `scripts/verify.sh` 成功路径打印的「下一步」第 4 条为 `openspec archive`，但本 change 仍有未写的测试与评估 | 一般 | 归档前置条件以本报告第 5 节为准，不按脚本提示自动归档 |

风险：T02/T20 在模拟器上只证明了「无相机 → 权限页 → 可退出」，未证明真机取景、拍摄与相册导入链路；T06–T07、T11–T12、T18–T19 仍无自动化证据。这些均已登记在 `docs/verification-debt.md`。

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [x] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：

1. 本轮证明的是「已编写的 11 条 UI 用例 + 62 条 L1 单测全绿」，**不等于** T01–T20 全部通过：T03–T07、T11、T12、T18、T19（UI）、T20（重拍/空名片）尚无测试。
2. 归档前必须补齐：`tasks.md` 1.3–1.9（8 个测试文件）、2.1–2.4（四份评估报告）、3.2（`--scope unit`）、3.3（全量）。补齐后重跑 `bash scripts/verify.sh --change 0009-acceptance-hardening` 并更新本报告。
3. 本报告依据 `artifacts/verify-0009-acceptance-hardening-20261027-175053.log` 与同名 `.xcresult` 的实际输出填写，未预填任何结论。

## 6. 归档前复核（追加，2026-10-27 20:15）

第 5 节的判定针对 `175053` 批次，保持不变。此后由 `0011`、`0013`、`0014` 三个 change 补齐了本 change 未完成的部分，归档前逐项对照如下：

| 第 5 节待补项 | 现状 | 证据 |
|---|---|---|
| tasks 3.2 `--scope unit` | 已执行 | `0011`（29 项）、`0013`（50 项） |
| tasks 3.3 全量 | 已执行 | `0014` 批次 20:03:20–20:05:09，core 62 + L2 50 + UI 11 全绿 |
| tasks 1.9 `OCRServiceTests`/`VCardExporterTests`/`ScanPipelineTests` | 已写 | `0011` 5 项、`0013` 3 + 4 项 |
| tasks 2.1–2.4 评估 | 部分完成 | `docs/eval/ocr-field-baseline.md`（`synthetic-001`，15 例，虚构字段 0）；检测/校正专项报告未做 |
| tasks 1.1–1.8 UI 测试 | 部分完成 | T01/T02/T13/T14/T15/T16/T17/T20 有 UI 证据；T03–T05、T06、T11、T12、T18、T19 的 UI 行改由 L2 + `docs/verify/manual-device-checklist.md` 承接 |

仍属未执行、且**必须真机**才能关闭的项：T03–T05 权限/拍摄/导入、T06 真机倾斜拍摄、T18 真机杀进程、T19 系统分享面板、T20 校正页重拍。这五项已写入人工清单，未执行前 `docs/traceability.md` 一律记「未执行 / 部分通过」，不宣称 G7 通过。

最终判定：本 change 的**自动化部分**（core 62 + L2 50 + UI 11）已全部通过，可以归档；**真机部分**转由人工清单结算，不在本 change 的自动化范围内。

