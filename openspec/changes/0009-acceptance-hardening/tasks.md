# Tasks

## 1. 测试补齐

- [ ] 1.1 `BizScanUITests/CardListUITests`：T01 空态、T12 新增、T17 删除
- [ ] 1.2 `BizScanUITests/CaptureUITests`：T02–T05、T20 中途退出
- [ ] 1.3 `BizScanUITests/DetectionUITests`：T06、T20 重拍
- [ ] 1.4 `BizScanUITests/VerificationUITests`：T11、空名片保存
- [ ] 1.5 `BizScanUITests/CardDetailUITests`：T13、T14
- [ ] 1.6 `BizScanUITests/SearchTagsUITests`：T15、T16
- [ ] 1.7 `BizScanUITests/PersistenceUITests`：T18
- [ ] 1.8 `BizScanUITests/ExportUITests`：T19
- [ ] 1.9 `BizScanTests/OCRServiceTests`、`VCardExporterTests`、`ScanPipelineTests`

## 2. 评估

- [ ] 2.1 对 `fixtures/` 全量跑管线，导出原始文本与解析结果 JSON
- [ ] 2.2 生成 `docs/eval/ocr-report.md`、`field-report.md`、`detection-report.md`、`correction-report.md`
- [ ] 2.3 错误分类：字段歧义、人名/公司混淆、多号码、中英混排、字段缺失、OCR 错字
- [ ] 2.4 虚构字段必须为 0；否则按阻断缺陷处理

## 3. 验证与证据

- [ ] 3.1 macOS/CI 执行 `swift test --package-path Packages/BizScanCore`
- [ ] 3.2 macOS/CI 执行 `bash scripts/verify.sh --scope unit`
- [ ] 3.3 macOS/CI 执行 `bash scripts/verify.sh`（全量）
- [ ] 3.4 生成 20 份 `docs/verify/<change>.md` 的最终结论并更新 `docs/traceability.md`
- [ ] 3.5 更新 `docs/regression-log.md` 与 README 阶段看板
- [ ] 3.6 `openspec validate --all --strict` 通过
- [ ] 3.7 依次执行 `openspec archive 0001-app-skeleton` … `0008-export`
- [ ] 3.8 归档后执行 `openspec validate --specs --strict`，确认主规范无残留冲突
