# Tasks

## 1. 检测

- [x] 1.1 定义 `CardQuad`（四角 + 置信度）与 `CardDetecting` 协议
- [x] 1.2 实现 `VisionCardDetector`：矩形检测、坐标转换、参数约束
- [x] 1.3 实现 `StubCardDetector` 供测试注入

## 2. 校正

- [x] 2.1 实现 `CoreImageCorrector`：`CIPerspectiveCorrection` + 旋转
- [x] 2.2 实现 `PassthroughImageCorrector` 测试替身
- [x] 2.3 校正失败（渲染失败）时返回可读错误，不吞异常

## 3. 交互与编排

- [x] 3.1 实现 `CropViewModel`：归一化角点、拖拽、旋转、处理状态
- [x] 3.2 实现 `CropView`：图像、四边形、控制点、确认/取消/旋转
- [x] 3.3 实现 `ScanPipeline`：检测 → 校正 → OCR → 解析
- [x] 3.4 检测不可用时回退整图并提示人工调整

## 4. 测试与验证

- [ ] 4.1 用 `fixtures/` 中 8 类拍摄条件生成检测报告（成功率、角点误差）
- [ ] 4.2 `DetectionUITests`：T06 显示检测区域、T20 校正页重拍
- [ ] 4.3 macOS/CI 执行 `bash scripts/verify.sh --change 0003-boundary-perspective`
- [ ] 4.4 回填 `docs/verify/0003-boundary-perspective.md` 与 `docs/eval/detection-report.md`
