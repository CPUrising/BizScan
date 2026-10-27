# Tasks

## 1. 测试补齐

- [ ] 1.1 `BizScanUITests/CardListUITests`：T01 空态、T12 新增、T17 删除 —— **部分完成**：T01 由 `LaunchUITests.testAppLaunchesToEmptyCardHolder` 覆盖、T17 由 `CardListUITests.testT17DeleteCardRemovesItFromList` 覆盖；T12 保存后列表新增无 UI 测试（L2 由 `0011` 的 `ReviewViewModelTests` / `HomeViewModelTests` 承接）
- [ ] 1.2 `BizScanUITests/CaptureUITests`：T02–T05、T20 中途退出 —— **部分完成**：T02、T20 已覆盖；T03–T05 需真实相机/相册，模拟器无法取证，改由 `docs/verify/manual-device-checklist.md` 第 1–4 节人工执行
- [ ] 1.3 `BizScanUITests/DetectionUITests`：T06、T20 重拍 —— 未写；T06 检测能力由 `0013` 的 `CardDetectorTests`（L2）取证，校正页重拍由人工清单第 6 节承接
- [ ] 1.4 `BizScanUITests/VerificationUITests`：T11、空名片保存 —— 未写；T11 与空名片保存由 `0011` 的 `ReviewViewModelTests`（L2）取证，Review 入口依赖相机/相册，UI 不可达
- [x] 1.5 `BizScanUITests/CardDetailUITests`：T13、T14（实际文件名为 `DetailUITests.swift`，含 `testT13OpenDetailShowsSavedFields`、`testT13EmptyFieldsAreNotShown`、`testT14EditNamePersistsInDetail`）
- [x] 1.6 `BizScanUITests/SearchTagsUITests`：T15、T16
- [ ] 1.7 `BizScanUITests/PersistenceUITests`：T18 —— 未写；容器重建由 `0011` 的 `PersistenceTests`（L2）取证，真机杀进程由人工清单第 7 节承接
- [ ] 1.8 `BizScanUITests/ExportUITests`：T19 —— 未写；文件写出由 `0011` 的 `VCardExporterTests`（L2）取证，系统分享面板由人工清单第 8 节承接
- [x] 1.9 `BizScanTests/OCRServiceTests`、`VCardExporterTests`、`ScanPipelineTests`（`0011`/`0013` 已落地：5 + 3 + 4 项）

## 2. 评估

- [x] 2.1 对 `fixtures/` 全量跑管线，导出原始文本与解析结果 JSON —— **偏差**：`fixtures/cards/` 与 `ground_truth/` 仍为空（教师资产未下发），改用代码内合成 15 例（`synthetic-001`），逐例明细写入 `docs/eval/raw/e01.json`–`e15.json`
- [ ] 2.2 生成 `docs/eval/ocr-report.md`、`field-report.md`、`detection-report.md`、`correction-report.md`（仅产出合并版 `docs/eval/ocr-field-baseline.md`；检测与校正报告未做，缺八类拍摄条件样本）
- [x] 2.3 错误分类：字段歧义、人名/公司混淆、多号码、中英混排、字段缺失、OCR 错字（见 `docs/eval/ocr-field-baseline.md` 第 5 节）
- [x] 2.4 虚构字段必须为 0；否则按阻断缺陷处理（实测 `fabricatedTotal = 0`）

## 3. 验证与证据

- [x] 3.1 macOS/CI 执行 `swift test --package-path Packages/BizScanCore`
- [x] 3.2 macOS/CI 执行 `bash scripts/verify.sh --scope unit`
- [x] 3.3 macOS/CI 执行 `bash scripts/verify.sh`（全量）：`0014` 批次 20:03:20–20:05:09，core 62 + L2 50 + UI 11 全绿
- [x] 3.4 生成 20 份 `docs/verify/<change>.md` 的最终结论并更新 `docs/traceability.md`：`0001`–`0011` + `0013`/`0014` 共 13 份报告，`0012` 为文档口径 change 不单独出报告；traceability 已按实际层级改写
- [x] 3.5 更新 `docs/regression-log.md` 与 README 阶段看板
- [x] 3.6 `openspec validate --all --strict` 通过
- [x] 3.7 依次执行 `openspec archive 0001-app-skeleton` … `0008-export`（含 `0010`–`0014`，均归档至 `openspec/changes/archive/2026-10-27-*`）
- [x] 3.8 归档后执行 `openspec validate --specs --strict`，确认主规范无残留冲突（11 项通过）

## 4. 首轮 UI 验证暴露的修复（2026-10-27）

首轮 `--scope ui` 执行结果：11 个用例、5 个失败。失败原因已用 xcresult 的 UI 层级快照定位，均非产品功能缺陷。

- [x] 4.1 工具链：`scripts/verify.sh` 第 100 行 `$STATUS` 后紧跟全角括号，bash 3.2 将其并入变量名导致 `unbound variable`；改用 `${STATUS}`
- [x] 4.2 测试错误：`EmptyStateView` 的 `.accessibilityIdentifier` 会下发给子元素，容器本身不生成 AX 元素；`LaunchUITests` 改为按标识符在整棵树中查找
- [x] 4.3 实现缺口：`ScannerView.permissionView` 的「返回」按钮补 `BizScan.Scanner.Close` 标识，使无相机环境下关闭入口与取景态一致
- [x] 4.4 测试错误：`SearchTagsUITests` 的 T15 断言未限定范围，命中了 `.sheet` 背后名片夹列表；改为限定 `BizScan.Search.Results` 集合视图
- [x] 4.5 测试错误：模拟器无相机时 `ScannerViewModel.startSession` 会同时置 `.denied` 并弹错误提示，`CaptureUITests` 需先关闭该提示再点关闭
- [x] 4.6 `SearchView` 的 List 补 `BizScan.Search.Results` 标识（供 4.4 使用）
- [x] 4.7 修复后重跑 `bash scripts/verify.sh --scope ui`，11 个用例全绿

> 已知观察（未修复，需新 change）：无相机时会同时展示「需要相机权限」页与「当前设备没有可用的相机」提示框，文案互相冲突。属行为变更，不在本 change 范围内处理。
