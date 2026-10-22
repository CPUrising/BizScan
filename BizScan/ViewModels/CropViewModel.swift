import Foundation
import Observation
import UIKit
import BizScanCore

@Observable
@MainActor
final class CropViewModel {
    private(set) var originalImage: UIImage
    private let pipeline: ScanPipeline

    /// 归一化角点，顺序固定为：左上、右上、右下、左下。
    var points: [CGPoint] = [
        CGPoint(x: 0.06, y: 0.06),
        CGPoint(x: 0.94, y: 0.06),
        CGPoint(x: 0.94, y: 0.94),
        CGPoint(x: 0.06, y: 0.94)
    ]

    var rotationQuarterTurns = 0
    var isProcessing = false
    var errorMessage: String?
    var result: ScanResult?

    private(set) var detectionConfidence: Float?
    private var didDetect = false

    init(originalImage: UIImage, pipeline: ScanPipeline) {
        self.originalImage = originalImage
        self.pipeline = pipeline
    }

    func detectIfNeeded() {
        guard !didDetect else { return }
        didDetect = true

        do {
            if let quad = try pipeline.detectQuad(in: originalImage) {
                let size = originalImage.size
                points = quad.points.map { normalized($0, size: size) }
                detectionConfidence = quad.confidence
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func movePoint(at index: Int, to normalizedPoint: CGPoint) {
        guard points.indices.contains(index) else { return }
        points[index] = CGPoint(
            x: min(max(normalizedPoint.x, 0), 1),
            y: min(max(normalizedPoint.y, 0), 1)
        )
    }

    func rotate() {
        rotationQuarterTurns = (rotationQuarterTurns + 1) % 4
    }

    func process() {
        guard !isProcessing else { return }
        isProcessing = true

        let quad = pixelQuad()
        let turns = rotationQuarterTurns
        let image = originalImage
        let pipeline = self.pipeline

        Task {
            defer { isProcessing = false }
            do {
                let output = try await Task.detached(priority: .userInitiated) {
                    try pipeline.run(
                        originalImage: image,
                        manualQuad: quad,
                        rotationQuarterTurns: turns
                    )
                }.value
                result = output
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func pixelQuad() -> CardQuad? {
        guard points.count == 4 else { return nil }
        let size = originalImage.size
        guard size.width > 0, size.height > 0 else { return nil }

        func scaled(_ point: CGPoint) -> CGPoint {
            CGPoint(x: point.x * size.width, y: point.y * size.height)
        }

        return CardQuad(
            topLeft: scaled(points[0]),
            topRight: scaled(points[1]),
            bottomRight: scaled(points[2]),
            bottomLeft: scaled(points[3]),
            confidence: detectionConfidence ?? 0
        )
    }

    private func normalized(_ point: CGPoint, size: CGSize) -> CGPoint {
        guard size.width > 0, size.height > 0 else { return point }
        return CGPoint(
            x: min(max(point.x / size.width, 0), 1),
            y: min(max(point.y / size.height, 0), 1)
        )
    }
}
