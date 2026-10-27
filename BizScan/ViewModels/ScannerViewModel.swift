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
