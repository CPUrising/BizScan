import Foundation
import CoreGraphics
import CoreImage
import ImageIO

enum ImageCorrectionError: LocalizedError {
    case renderFailed

    var errorDescription: String? {
        switch self {
        case .renderFailed:
            return "名片图像校正失败，请重新拍摄。"
        }
    }
}

protocol ImageCorrecting {
    func correct(image: CGImage, quad: CardQuad?, rotationQuarterTurns: Int) throws -> CGImage
}

final class CoreImageCorrector: ImageCorrecting {
    private let context = CIContext(options: [.useSoftwareRenderer: false])

    func correct(image: CGImage, quad: CardQuad?, rotationQuarterTurns: Int) throws -> CGImage {
        var ciImage = CIImage(cgImage: image)

        if let quad {
            ciImage = perspectiveCorrect(ciImage, quad: quad, imageSize: CGSize(width: image.width, height: image.height))
        }

        let turns = ((rotationQuarterTurns % 4) + 4) % 4
        if turns != 0 {
            ciImage = ciImage.oriented(forExifOrientation: exifOrientation(for: turns))
        }

        let extent = ciImage.extent.integral
        guard !extent.isEmpty, let output = context.createCGImage(ciImage, from: extent) else {
            throw ImageCorrectionError.renderFailed
        }
        return output
    }

    private func perspectiveCorrect(_ image: CIImage, quad: CardQuad, imageSize: CGSize) -> CIImage {
        guard let filter = CIFilter(name: "CIPerspectiveCorrection") else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(vector(for: quad.topLeft, imageSize: imageSize), forKey: "inputTopLeft")
        filter.setValue(vector(for: quad.topRight, imageSize: imageSize), forKey: "inputTopRight")
        filter.setValue(vector(for: quad.bottomRight, imageSize: imageSize), forKey: "inputBottomRight")
        filter.setValue(vector(for: quad.bottomLeft, imageSize: imageSize), forKey: "inputBottomLeft")
        return filter.outputImage ?? image
    }

    /// CI 使用左下原点。
    private func vector(for point: CGPoint, imageSize: CGSize) -> CIVector {
        CIVector(x: point.x, y: imageSize.height - point.y)
    }

    private func exifOrientation(for quarterTurns: Int) -> Int32 {
        switch quarterTurns {
        case 1: return Int32(CGImagePropertyOrientation.right.rawValue)
        case 2: return Int32(CGImagePropertyOrientation.down.rawValue)
        case 3: return Int32(CGImagePropertyOrientation.left.rawValue)
        default: return Int32(CGImagePropertyOrientation.up.rawValue)
        }
    }
}

/// 测试替身：原样返回输入图。
final class PassthroughImageCorrector: ImageCorrecting {
    func correct(image: CGImage, quad: CardQuad?, rotationQuarterTurns: Int) throws -> CGImage {
        image
    }
}
