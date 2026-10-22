import Foundation
import Observation
import AVFoundation

enum CameraError: LocalizedError {
    case notAuthorized
    case unavailable
    case captureFailed(String)
    case noData

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "没有相机权限，请在系统设置中允许访问相机。"
        case .unavailable:
            return "当前设备没有可用的相机。"
        case .captureFailed(let message):
            return "拍摄失败：\(message)"
        case .noData:
            return "没有拿到拍摄数据，请重试。"
        }
    }
}

/// 相机会话封装。UI 只接触 `session` 与有限的几个方法，便于在测试中替换。
@Observable
@MainActor
final class CameraService {
    let session = AVCaptureSession()

    private let photoOutput = AVCapturePhotoOutput()
    private let captureDelegate = PhotoCaptureDelegate()
    private let sessionQueue = DispatchQueue(label: "com.bizscan.camera.session")
    private var isConfigured = false

    private(set) var authorizationStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    func refreshAuthorization() {
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestAccess() async -> Bool {
        let granted = await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
        refreshAuthorization()
        return granted
    }

    func start() throws {
        guard authorizationStatus == .authorized else { throw CameraError.notAuthorized }
        try configureIfNeeded()

        let session = self.session
        sessionQueue.async {
            guard !session.isRunning else { return }
            session.startRunning()
        }
    }

    func stop() {
        let session = self.session
        sessionQueue.async {
            guard session.isRunning else { return }
            session.stopRunning()
        }
    }

    func capturePhoto() async throws -> Data {
        guard authorizationStatus == .authorized else { throw CameraError.notAuthorized }
        try configureIfNeeded()

        return try await withCheckedThrowingContinuation { continuation in
            captureDelegate.prepare { result in
                continuation.resume(with: result)
            }

            let settings = AVCapturePhotoSettings()
            if photoOutput.supportedFlashModes.contains(.auto) {
                settings.flashMode = .auto
            }
            photoOutput.capturePhoto(with: settings, delegate: captureDelegate)
        }
    }

    private func configureIfNeeded() throws {
        guard !isConfigured else { return }

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
            isConfigured = true
        }

        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.unavailable
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else { throw CameraError.unavailable }
        session.addInput(input)

        guard session.canAddOutput(photoOutput) else { throw CameraError.unavailable }
        session.addOutput(photoOutput)
        photoOutput.maxPhotoQualityPrioritization = .quality
    }
}

/// 把 AVCapturePhoto 回调转成一次性闭包，避免让 CameraService 继承 NSObject。
private final class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let lock = NSLock()
    private var completion: ((Result<Data, Error>) -> Void)?

    func prepare(_ completion: @escaping (Result<Data, Error>) -> Void) {
        lock.lock()
        self.completion = completion
        lock.unlock()
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let data = photo.fileDataRepresentation()
        let message = error?.localizedDescription

        lock.lock()
        let callback = completion
        completion = nil
        lock.unlock()

        guard let callback else { return }

        if let message {
            callback(.failure(CameraError.captureFailed(message)))
        } else if let data {
            callback(.success(data))
        } else {
            callback(.failure(CameraError.noData))
        }
    }
}
