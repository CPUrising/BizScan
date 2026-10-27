# Tasks

## 1. 服务层 L2 用例

- [x] 1.1 `BizScanTests/CardDetectorTests.swift`：清晰矩形、倾斜卡片、纯色无边缘、替身错误透传（4 项）
- [x] 1.2 `BizScanTests/ImageCorrectorTests.swift`：quad 透视输出、四档旋转、nil quad 原样（3 项）
- [x] 1.3 `BizScanTests/OCRServiceTests.swift`：合成名片文本、归一化坐标、空白图（3 项）
- [x] 1.4 `BizScanTests/ScanPipelineTests.swift`：手动 quad 兜底、字段解析接线、OCR 失败保留原图、无效图抛错（4 项）
- [x] 1.5 `BizScanTests/CropViewModelTests.swift`：检测回退、检测应用、旋转循环、process 成功/失败（5 项）

## 2. 人工清单

- [x] 2.1 `docs/verify/manual-device-checklist.md`：T03/T04/T05/T06 倾斜/T18 真机 kill/T19 分享/T20 重拍与旋转，共 8 组，只写步骤与回填表格

## 3. 验证与证据

- [x] 3.1 `bash scripts/verify.sh --scope unit --change 0013-service-layer-coverage` 全绿（失败按 AGENTS.md 第 5 节最多 3 轮自愈）
- [x] 3.2 回填 `docs/verify/0013-service-layer-coverage.md`，T03–T05/T18/T19 登记为「人工清单待执行」
- [x] 3.3 更新 `docs/verification-debt.md`、`docs/traceability.md`、`README.md` §2、`docs/regression-log.md`

> 不改 `BizScan/` 源码、不改 `project.yml`、不写 UI 测试、不新增 fixture、不改 `openspec/specs/`。
