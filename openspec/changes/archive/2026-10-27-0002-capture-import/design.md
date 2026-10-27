# Design

## Context

见 `proposal.md`。相机只能在真机或模拟器的有限能力下验证；UI 测试需要稳定的"导入图片"路径。参考项目 `CardScanner` 提供了 `AVCaptureSession` 四步装配写法，但其固定取景框不适用于本项目。

## Goals / Non-Goals

**Goals:**

- 相机生命周期与 SwiftUI 视图解耦，页面消失即停止会话。
- 权限三种状态（未决定 / 允许 / 拒绝）都有明确出口。
- 拍照结果只回传 `Data`，不把 `AVCapturePhoto` 泄漏到上层。

**Non-Goals:**

- 不实现闪光灯、网格、对焦手势等参考 App 的完整拍摄工具条。
- 不做多张连拍（Batch）。
- 不在本 change 内改变图像方向或裁剪。

## Decisions

1. **`AVCapturePhotoOutput` 回调封装成一次性闭包**
   - 理由：`@Observable` 类不适合再继承 `NSObject`；独立 `PhotoCaptureDelegate` 持有 completion，避免双次 resume。
   - 备选：让 `CameraService` 继承 `NSObject`（被否：与 Observation 宏组合的风险更高）。

2. **会话启停在专用串行队列执行**
   - 理由：`startRunning()` 是阻塞调用，放主线程会卡首帧。
   - 备选：`Task.detached`（被否：`AVCaptureSession` 非 Sendable，跨 actor 语义更差）。

3. **权限状态机放在 ViewModel**
   - 理由：View 只渲染 `idle/denied/ready`，便于后续 UI 测试断言。
   - 备选：在 View 中直接查询 `AVCaptureDevice`（被否：状态分散、难测试）。

4. **相册导入走 `PhotosPicker` + `Transferable(Data)`**
   - 理由：无需申请完整相册权限，用户选择即授权。
   - 备选：`UIImagePickerController`（被否：旧 API，权限模型更重）。

## Risks / Trade-offs

- [模拟器无相机，T02–T04 只能真机验证] → UI 测试以 T05 导入路径为主；真机结果人工记录到 `docs/verify/0002-capture-import.md`。
- [权限恢复依赖回到前台事件] → 当前实现由用户重新进入扫描页触发刷新；若要求自动恢复，需在 `ScannerView` 监听 `scenePhase`（记录为待验证项）。
- [应用被杀后临时图片未清理] → 只存在于内存 `UIImage`，进程结束即释放；不写磁盘。

## Migration Plan

无数据迁移。若权限文案变更，仅影响 `project.yml` 中 `Info.plist` 属性。

## Open Questions

- 是否需要在扫描页内支持手电筒与自动对焦提示？属参考 App 的加分项，本 change 不实现。
