# Proposal

## Why

名片夹目前没有任何图像来源。要形成 T02–T05 的可观察流程，必须先有相机拍摄与相册导入两条入口，并且权限拒绝、取消、重拍、中途退出都必须有确定行为，否则后续检测与 OCR 无法被稳定触发。

## What Changes

- 新增 `CameraService`：`AVCaptureSession` 装配、权限查询与请求、单次拍照。
- 新增 `PhotoLibraryService`：基于 `PhotosPicker` 读取图片数据。
- 新增 `ScannerViewModel` 与 `ScannerView`：权限状态机、取景、快门、相册入口、关闭与错误提示。
- 拍照/导入结果通过 `capturedImage` 交给后续校正流程；取消或重拍不产生草稿记录。
- 相机权限被拒绝时展示说明与「前往设置」，并保留相册导入作为降级路径。

不包含：边界检测、透视校正、OCR（见 `0003`、`0004`）。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/capture` 的既有行为合同。

### Modified Capabilities

无。若权限文案或状态需要新增行为，改为带 `## MODIFIED Requirements` 的增量规范。

## Impact

- 代码：`BizScan/Services/CameraService.swift`、`BizScan/Services/PhotoLibraryService.swift`、`BizScan/ViewModels/ScannerViewModel.swift`、`BizScan/Views/ScannerView.swift`、`BizScan/Views/Components/CameraPreview.swift`
- 工程：`Info.plist` 相机与相册用途声明（由 `project.yml` 生成）
- 测试：`BizScanUITests` 中的 T02–T05、T20 相机相关场景（待补）
