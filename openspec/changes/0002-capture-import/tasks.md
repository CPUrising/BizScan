# Tasks

## 1. 相机

- [x] 1.1 实现 `CameraService`：会话装配、启停、权限查询与请求
- [x] 1.2 实现 `PhotoCaptureDelegate`，把拍照结果转成一次性 `Data` 回调
- [x] 1.3 实现 `CameraPreview`（`AVCaptureVideoPreviewLayer` 包装）
- [x] 1.4 `Info.plist` 增加 `NSCameraUsageDescription`、`NSPhotoLibraryUsageDescription`

## 2. 相册与页面

- [x] 2.1 实现 `PhotoLibraryService`（`PhotosPickerItem → UIImage`）
- [x] 2.2 实现 `ScannerViewModel`：`idle/denied/ready`、拍照、导入、错误
- [x] 2.3 实现 `ScannerView`：取景、快门、相册入口、关闭、权限说明
- [x] 2.4 拍照/导入结果通过 `capturedImage` 触发校正页；取消不产生记录

## 3. 测试与验证

- [ ] 3.1 `CaptureUITests`：T02 进入扫描器、T03 权限、T04 确认、T05 导入
- [ ] 3.2 `CaptureUITests`：T20 中途退出、重拍、取消
- [ ] 3.3 真机验证相机取景与拍照（模拟器无法覆盖）
- [ ] 3.4 macOS/CI 执行 `bash scripts/verify.sh --change 0002-capture-import`
- [ ] 3.5 回填 `docs/verify/0002-capture-import.md` 并更新 `docs/traceability.md`
