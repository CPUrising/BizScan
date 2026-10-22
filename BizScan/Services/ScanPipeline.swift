import Foundation
import CoreGraphics
import UIKit
import BizScanCore

enum ScanPipelineError: LocalizedError {
    case invalidImage
    case encodeFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "无法读取该图片，请重新选择。"
        case .encodeFailed:
            return "图像处理结果无法保存。"
        }
    }
}

struct ScanResult {
    let originalImage: UIImage
    let processedImage: UIImage
    let quad: CardQuad?
    let observations: [OCRObservation]
    let parsed: ParsedCard
}

/// 检测 → 校正 → OCR → 字段解析。任一步失败都不丢弃原始图，保证可重试。
struct ScanPipeline: @unchecked Sendable {
    let detector: CardDetecting
    let corrector: ImageCorrecting
    let ocr: OCRRecognizing

    func detectQuad(in image: UIImage) throws -> CardQuad? {
        guard let cgImage = image.cgImage else { throw ScanPipelineError.invalidImage }
        return try detector.detectQuad(in: cgImage)
    }

    func run(
        originalImage: UIImage,
        manualQuad: CardQuad? = nil,
        rotationQuarterTurns: Int = 0
    ) throws -> ScanResult {
        guard let cgImage = originalImage.cgImage else { throw ScanPipelineError.invalidImage }

        let quad = manualQuad ?? ((try? detector.detectQuad(in: cgImage)) ?? nil)
        let correctedCGImage = try corrector.correct(
            image: cgImage,
            quad: quad,
            rotationQuarterTurns: rotationQuarterTurns
        )

        let observations = (try? ocr.recognizeText(in: correctedCGImage)) ?? []
        let parsed = FieldParser().parse(observations: observations)

        let processedImage = UIImage(cgImage: correctedCGImage)
        return ScanResult(
            originalImage: originalImage,
            processedImage: processedImage,
            quad: quad,
            observations: observations,
            parsed: parsed
        )
    }
}
