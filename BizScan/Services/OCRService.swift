import Foundation
import CoreGraphics
import Vision
import BizScanCore

enum OCRServiceError: LocalizedError {
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .requestFailed(let message):
            return "文字识别失败：\(message)"
        }
    }
}

protocol OCRRecognizing {
    func recognizeText(in image: CGImage) throws -> [OCRObservation]
}

final class VisionOCRService: OCRRecognizing {
    var recognitionLanguages: [String] = ["zh-Hans", "en-US"]
    var recognitionLevel: VNRequestTextRecognitionLevel = .accurate

    func recognizeText(in image: CGImage) throws -> [OCRObservation] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = recognitionLevel
        request.usesLanguageCorrection = true
        request.recognitionLanguages = recognitionLanguages

        let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            throw OCRServiceError.requestFailed(error.localizedDescription)
        }

        let results = request.results ?? []
        return results.enumerated().compactMap { index, observation in
            guard let candidate = observation.topCandidates(1).first, !candidate.string.isEmpty else {
                return nil
            }
            return OCRObservation(
                text: candidate.string,
                confidence: candidate.confidence,
                boundingBox: NormalizedRect(
                    x: observation.boundingBox.origin.x,
                    y: observation.boundingBox.origin.y,
                    width: observation.boundingBox.width,
                    height: observation.boundingBox.height
                ),
                lineIndex: index
            )
        }
    }
}

/// 测试替身：直接返回预设文本。
final class StubOCRService: OCRRecognizing {
    var observations: [OCRObservation]
    var error: Error?

    init(observations: [OCRObservation] = [], error: Error? = nil) {
        self.observations = observations
        self.error = error
    }

    func recognizeText(in image: CGImage) throws -> [OCRObservation] {
        if let error { throw error }
        return observations
    }
}
