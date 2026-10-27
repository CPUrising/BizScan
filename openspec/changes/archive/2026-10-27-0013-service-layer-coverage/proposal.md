# Proposal

## Why

`docs/verification-debt.md` 2.2 表中 `CardDetector`、`ImageCorrector`、`OCRService`、`ScanPipeline` 四行仍是「未开始」，导致：

1. T06（倾斜名片自动检测）与 T07（标准名片产生原始文本）在 `docs/traceability.md` 无任何可点开的证据。
2. T20 只覆盖了「中途退出」，校正页的 90° 旋转与「检测失败回退手动四点」没有断言保护。
3. 模拟器无相机，T03–T05 的权限/拍摄/导入、T18 真机杀进程、T19 系统分享面板无法用 XCUITest 取证，但台账里没有一份可照做的人工步骤，欠账无法结算。

`CardDetecting` / `ImageCorrecting` / `OCRRecognizing` 三个协议与 `StubCardDetector` / `PassthroughImageCorrector` / `StubOCRService` 已存在，`ScanPipeline` 与 `CropViewModel` 都可注入，补齐这些测试不需要改产品代码。

## What Changes

- 新增 5 个 L2 测试文件，共 19 个用例：`CardDetectorTests`（4）、`ImageCorrectorTests`（3）、`OCRServiceTests`（3）、`ScanPipelineTests`（4）、`CropViewModelTests`（5）。
- 检测与 OCR 用 `UIGraphicsImageRenderer` 现场合成名片图，不依赖任何外部 fixture。
- 新增 `docs/verify/manual-device-checklist.md`：列出真机可执行的 8 组步骤与回填表格，不预填结论。
- 新增 `docs/verify/0013-service-layer-coverage.md`，并同步 `docs/verification-debt.md`、`docs/traceability.md`、`README.md` 阶段看板与 `docs/regression-log.md`。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

无。只补测试与证据，不改变任何运行时行为合同。

## Impact

- 测试：`BizScanTests/` 新增 5 个文件（19 项），不改动既有 29 项。
- 文档：新增 2 份（验证报告、真机人工清单），更新 4 处（台账、追踪矩阵、README、回归基线）。
- 产品代码：**无改动**（`BizScan/` 下不新增任何 seam 或分支）。
