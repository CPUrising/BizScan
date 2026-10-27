# 0013-service-layer-coverage · AI 协作记录

## 1. prompt 范围

出处：`chat_history/chat02.md`（"继续完成 P7 剩余项"→"/plan"系列）与 `openspec/changes/archive/2026-10-27-0013-service-layer-coverage/proposal.md`。

授权范围：补 `CardDetector`、`ImageCorrector`、`OCRService`、`ScanPipeline` 的 L2 测试，并固化真机人工清单。

明确不做：不改产品代码、不改检测/校正/OCR 参数、不新增 fixtures 图像资产。

## 2. AI 产出

- `BizScanTests/CardDetectorTests.swift`（4 项，现场绘制合成图）、`ImageCorrectorTests`（3 项）、`OCRServiceTests`（3 项）、`ScanPipelineTests`（4 项）、`CropViewModelTests` 补充。
- `docs/verify/manual-device-checklist.md`：T03–T05、T06 倾斜、T20 重拍旋转、T18 kill、T19 分享面板共 9 节人工步骤。
- `docs/verify/0013-service-layer-coverage.md`。

## 3. 人工修正点

| 事项 | 人类动作 |
|---|---|
| `ImageCorrectorTests` 尺寸断言恒为期望值 3 倍 | AI 定位为 `UIGraphicsImageRenderer` 默认 scale=3，人类确认修测试而非改实现 |
| `CropViewModelTests` 编译报 `Cannot find 'OCRObservation'` | 补 `import BizScanCore` |
| 真机项 | 人类确认模拟器无相机，接受转人工清单，不在本轮执行 |

## 4. 回归结果

`bash scripts/verify.sh --scope unit --change 0013-service-layer-coverage`：core 62 + L2 50，0 失败。
证据：[docs/verify/0013-service-layer-coverage.md](../verify/0013-service-layer-coverage.md)。
