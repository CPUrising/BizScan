import Foundation
import Observation
import AVFoundation
import PhotosUI
import SwiftUI
import UIKit

@Observable
@MainActor
final class ScannerViewModel {
    enum State: Equatable {
        case idle
        case denied
        case ready
    }

    private let camera = CameraService()
    private let photoLibrary = PhotoLibraryService()

    private(set) var state: State = .idle
    var errorMessage: String?
    var isCapturing = false
    var capturedImage: UIImage?

    var session: AVCaptureSession { camera.session }

    func prepare() async {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing-capture") {
            state = .denied
            capturedImage = Self.makeUITestCardImage()
            return
        }

        camera.refreshAuthorization()

        switch camera.authorizationStatus {
        case .authorized:
            startSession()
        case .notDetermined:
            let granted = await camera.requestAccess()
            if granted {
                startSession()
            } else {
                state = .denied
            }
        default:
            state = .denied
        }
    }

    func stop() {
        camera.stop()
    }

    func capture() {
        guard !isCapturing, state == .ready else { return }
        isCapturing = true

        Task {
            defer { isCapturing = false }
            do {
                let data = try await camera.capturePhoto()
                guard let image = UIImage(data: data) else {
                    errorMessage = CameraError.noData.localizedDescription
                    return
                }
                capturedImage = image
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func importImage(from item: PhotosPickerItem) {
        Task {
            do {
                capturedImage = try await photoLibrary.loadImage(from: item)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func clearCapturedImage() {
        capturedImage = nil
    }

    private func startSession() {
        do {
            try camera.start()
            state = .ready
        } catch {
            errorMessage = error.localizedDescription
            state = .denied
        }
    }
}

private extension ScannerViewModel {
    /// UI 测试用：模拟器无相机，注入一张合成名片，直接进入「校正 → 识别」链路。
    static func makeUITestCardImage() -> UIImage {
        let size = CGSize(width: 1000, height: 600)
        return UIGraphicsImageRenderer(size: size).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let text = """
            David Chen
            ABC Technologies
            Technical Director
            Mobile: +86 138 0000 0000
            Email: david.chen@example.com
            """
            text.draw(
                at: CGPoint(x: 80, y: 90),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 52, weight: .semibold),
                    .foregroundColor: UIColor.black
                ]
            )
        }
    }
}
