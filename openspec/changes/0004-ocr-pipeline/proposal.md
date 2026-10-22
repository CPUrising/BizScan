# Proposal

## Why

校正后的图像仍只是一张图。必须先把图中的文字识别出来，并保留可追溯的原始输出，才能支撑字段解析、准确率评估与人工校正。仅展示"最终识别结果"无法满足 `要求/01.md` 第五章的留痕要求。

## What Changes

- 新增 `OCRRecognizing` 与 `VisionOCRService`：中英识别、文本块坐标与置信度。
- 新增 `OCRObservation`（BizScanCore）：文本、置信度、归一化坐标、行序。
- `ScanPipeline` 接入 OCR，输出 `ScanResult`（原图、校正图、四边形、原始观察、解析结果）。
- OCR 失败或空结果时保留原图并给出重拍/手动录入出口，不生成记录。

不包含：字段分类规则（见 `0005`）、人工校正界面（见 `0006`）。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/ocr` 的既有行为合同。

### Modified Capabilities

无。

## Impact

- 代码：`BizScan/Services/OCRService.swift`、`BizScan/Services/ScanPipeline.swift`、`Packages/BizScanCore/Sources/BizScanCore/OCRObservation.swift`
- 依赖：Vision（系统框架）
- 测试：`OCRServiceTests`（待补）；`FieldParserTests` 复用观察顺序
