import Foundation
import CoreGraphics
import Vision

/// 名片四边形，坐标为图像坐标（原点左上，单位像素）。
struct CardQuad: Equatable, Sendable {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint
    var confidence: Float

    var points: [CGPoint] { [topLeft, topRight, bottomRight, bottomLeft] }
}

enum CardDetectionError: LocalizedError {
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .requestFailed(let message):
            return "名片边界检测失败：\(message)"
        }
    }
}

protocol CardDetecting {
    /// 返回 nil 表示未检测到可用四边形，调用方应回退到手动四点调整。
    func detectQuad(in image: CGImage) throws -> CardQuad?
}

final class VisionCardDetector: CardDetecting {
    func detectQuad(in image: CGImage) throws -> CardQuad? {
        let request = VNDetectRectanglesRequest()
        request.maximumObservations = 1
        request.minimumConfidence = 0.4
        request.minimumAspectRatio = 0.35
        request.maximumAspectRatio = 2.2
        request.minimumSize = 0.2
        request.quadratureTolerance = 30

        let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            throw CardDetectionError.requestFailed(error.localizedDescription)
        }

        guard let observation = request.results?.first else { return nil }

        let size = CGSize(width: image.width, height: image.height)
        return CardQuad(
            topLeft: convert(observation.topLeft, imageSize: size),
            topRight: convert(observation.topRight, imageSize: size),
            bottomRight: convert(observation.bottomRight, imageSize: size),
            bottomLeft: convert(observation.bottomLeft, imageSize: size),
            confidence: observation.confidence
        )
    }

    /// Vision 使用左下原点；统一转换为左上原点。
    private func convert(_ point: CGPoint, imageSize: CGSize) -> CGPoint {
        CGPoint(
            x: point.x * imageSize.width,
            y: (1 - point.y) * imageSize.height
        )
    }
}

/// 测试替身：返回固定四边形或 nil。
final class StubCardDetector: CardDetecting {
    var quad: CardQuad?
    var error: Error?

    init(quad: CardQuad? = nil, error: Error? = nil) {
        self.quad = quad
        self.error = error
    }

    func detectQuad(in image: CGImage) throws -> CardQuad? {
        if let error { throw error }
        return quad
    }
}
