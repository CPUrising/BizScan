# Design

## 1. 测试分层

| 层 | 覆盖 | 说明 |
|---|---|---|
| L2（本 change 新增） | T06 检测、T07 OCR、T20 旋转/回退、流水线接线 | 真实 `VisionCardDetector`、`CoreImageCorrector`、`VisionOCRService`，只把不可控的一环替换为替身 |
| L3（人工清单） | T03 权限、T04 拍摄、T05 导入、T18 真机 kill、T19 分享面板 | 模拟器无相机、系统 UI 无法稳定自动化 |

## 2. 关键决策

1. **合成图不落盘**：`UIGraphicsImageRenderer` 现场绘制 1400×900 白卡片 + 深灰背景，避免引入 `fixtures/` 依赖，也避免真实个人信息。
2. **检测断言用包围盒容差而非逐点相等**：Vision 的矩形角点存在像素级抖动，断言「四点最小/最大 x/y 与绘制矩形误差 ≤ 12% 画布」更稳定，同时仍能证明检测到了正确区域。
3. **OCR 断言用「小写去空格后包含子串」**：Vision 可能在字母间插空格或改变大小写，直接字符串相等会把测试写成字体渲染测试。
4. **流水线用替身证明接线，不用真实 Vision**：`ScanPipelineTests` 只回答「谁在什么时候被调用、失败时是否保留原始图」，真实识别能力由 3.1/3.3 负责。
5. **校正页覆盖两条失败路径**：检测返回 nil 时保留默认四点；corrector 抛错时 `result == nil` 且 `errorMessage` 非空。这两条是 T20 与 T06 回退分支的唯一保护。
6. **人工清单不写 PASS**：未在真机执行的项一律留空，报告结论只勾「需人类决策」。

## 3. 失败判定

- 若 Vision 在合成图上检测不到矩形，先调整对比度/版式，最多 3 轮；仍失败则视为真实偏差写入报告第 4 节，**不放宽断言**。
- 若 OCR 返回空串，先增大字号到 44pt、改纯黑字，最多 3 轮；仍失败同样记偏差。

## 4. 不做的事

- 不给 `ScannerView` 增加 UI 测试图片注入入口。
- 不写 `DetectionUITests` / `VerificationUITests` / `PersistenceUITests` / `ExportUITests`。
- 不修改 `openspec/specs/`，不归档任何 change。
