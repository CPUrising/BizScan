# Tasks

## 1. 测试补齐

- [ ] 1.1 `BizScanUITests/CardListUITests`：T01 空态、T12 新增、T17 删除
- [ ] 1.2 `BizScanUITests/CaptureUITests`：T02–T05、T20 中途退出
- [ ] 1.3 `BizScanUITests/DetectionUITests`：T06、T20 重拍
- [ ] 1.4 `BizScanUITests/VerificationUITests`：T11、空名片保存
- [ ] 1.5 `BizScanUITests/CardDetailUITests`：T13、T14
- [x] 1.6 `BizScanUITests/SearchTagsUITests`：T15、T16
- [ ] 1.7 `BizScanUITests/PersistenceUITests`：T18
- [ ] 1.8 `BizScanUITests/ExportUITests`：T19
- [ ] 1.9 `BizScanTests/OCRServiceTests`、`VCardExporterTests`、`ScanPipelineTests`

## 2. 评估

- [ ] 2.1 对 `fixtures/` 全量跑管线，导出原始文本与解析结果 JSON
- [ ] 2.2 生成 `docs/eval/ocr-report.md`、`field-report.md`、`detection-report.md`、`correction-report.md`
- [ ] 2.3 错误分类：字段歧义、人名/公司混淆、多号码、中英混排、字段缺失、OCR 错字
- [ ] 2.4 虚构字段必须为 0；否则按阻断缺陷处理

## 3. 验证与证据

- [x] 3.1 macOS/CI 执行 `swift test --package-path Packages/BizScanCore`
- [x] 3.2 macOS/CI 执行 `bash scripts/verify.sh --scope unit`
- [ ] 3.3 macOS/CI 执行 `bash scripts/verify.sh`（全量）
- [ ] 3.4 生成 20 份 `docs/verify/<change>.md` 的最终结论并更新 `docs/traceability.md`
- [ ] 3.5 更新 `docs/regression-log.md` 与 README 阶段看板
- [ ] 3.6 `openspec validate --all --strict` 通过
- [ ] 3.7 依次执行 `openspec archive 0001-app-skeleton` … `0008-export`
- [ ] 3.8 归档后执行 `openspec validate --specs --strict`，确认主规范无残留冲突

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
