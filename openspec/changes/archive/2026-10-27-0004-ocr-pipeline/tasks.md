# Tasks

## 1. 识别服务

- [x] 1.1 定义 `OCRObservation` 与 `NormalizedRect`（BizScanCore）
- [x] 1.2 实现 `VisionOCRService`：中英语言、`.accurate`、语言纠正
- [x] 1.3 实现 `StubOCRService` 供管线测试注入
- [x] 1.4 空结果与识别异常返回空数组，不中断流程

## 2. 管线

- [x] 2.1 `ScanPipeline` 串联检测、校正、OCR、字段解析
- [x] 2.2 `ScanResult` 保留原图、校正图、四边形、原始观察、解析结果
- [x] 2.3 OCR 在主线程外执行，界面展示处理中状态

## 3. 测试与验证

- [ ] 3.1 生成 OCR 原始文本快照（`docs/eval/ocr-report.md`），覆盖中文/英文/中英混排/竖版
- [ ] 3.2 `OCRServiceTests`：标准名片产生非空文本与坐标
- [ ] 3.3 UI 测试 T07：校正确认后进入识别并展示原始文本
- [ ] 3.4 macOS/CI 执行 `bash scripts/verify.sh --change 0004-ocr-pipeline`
- [ ] 3.5 回填 `docs/verify/0004-ocr-pipeline.md`
