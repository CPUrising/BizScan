# Proposal

## Why

拍摄结果是一张带透视、可能倾斜或旋转的照片。若直接送入 OCR，字段顺序与文字方向都会失真。本 change 引入边界检测、透视校正与手动调整，并提供检测失败时的回退路径，使 T06 与 T20 可被验证。

## What Changes

- 新增 `CardDetecting` / `VisionCardDetector`：基于 `VNDetectRectanglesRequest` 输出四角点与置信度。
- 新增 `ImageCorrecting` / `CoreImageCorrector`：`CIPerspectiveCorrection` + 90° 方向校正。
- 新增 `CropViewModel` / `CropView`：展示检测结果、四角可拖拽、旋转、确认、重拍。
- 新增 `ScanPipeline`：检测 → 校正 → OCR → 字段解析的统一入口。
- 检测失败或置信度不足时回退为整图四边形，强制人工确认，禁止直接进入 OCR 保存。

不包含：OCR 文本质量评估（见 `0004`）。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/card-detection` 的既有行为合同。

### Modified Capabilities

无。

## Impact

- 代码：`BizScan/Services/CardDetection.swift`、`BizScan/Services/ImageCorrection.swift`、`BizScan/Services/ScanPipeline.swift`、`BizScan/ViewModels/CropViewModel.swift`、`BizScan/Views/CropView.swift`
- 依赖：Vision、Core Image（系统框架）
- 测试：`CardDetectorTests`、`DetectionUITests`（待补）
