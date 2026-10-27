import XCTest
import UIKit
import BizScanCore
@testable import BizScan

/// 流水线接线的 L2 证据：谁被调用、失败时是否保留原始图。
/// 真实识别能力由 `CardDetectorTests` / `OCRServiceTests` 保证，这里全部使用替身。
final class ScanPipelineTests: XCTestCase {
    private struct SampleError: Error {}

    private var sourceImage: UIImage {
        TestSupport.makeImage(color: .darkGray, size: CGSize(width: 40, height: 24))
    }

    private func makeQuad() -> CardQuad {
        CardQuad(
            topLeft: CGPoint(x: 2, y: 2),
            topRight: CGPoint(x: 38, y: 2),
            bottomRight: CGPoint(x: 38, y: 22),
            bottomLeft: CGPoint(x: 2, y: 22),
            confidence: 0.9
        )
    }

    func testRunUsesManualQuadWhenDetectorFails() throws {
        let manualQuad = makeQuad()
        let pipeline = ScanPipeline(
            detector: StubCardDetector(error: SampleError()),
            corrector: PassthroughImageCorrector(),
            ocr: StubOCRService()
        )

        let result = try pipeline.run(originalImage: sourceImage, manualQuad: manualQuad)

        XCTAssertEqual(result.quad, manualQuad, "检测失败时应回退到手动四点")
    }

    func testRunParsesFieldsFromOCRObservations() throws {
        let observations = [
            OCRObservation(text: "David Chen", lineIndex: 0),
            OCRObservation(text: "ABC Technologies", lineIndex: 1)
        ]
        let pipeline = ScanPipeline(
            detector: StubCardDetector(quad: makeQuad()),
            corrector: PassthroughImageCorrector(),
            ocr: StubOCRService(observations: observations)
        )

        let result = try pipeline.run(originalImage: sourceImage)

        XCTAssertEqual(result.observations.count, 2)
        XCTAssertEqual(result.parsed.name, "David Chen")
        XCTAssertEqual(result.parsed.company, "ABC Technologies")
    }

    func testRunKeepsOriginalImageWhenOCRThrows() throws {
        let image = sourceImage
        let pipeline = ScanPipeline(
            detector: StubCardDetector(quad: makeQuad()),
            corrector: PassthroughImageCorrector(),
            ocr: StubOCRService(error: SampleError())
        )

        let result = try pipeline.run(originalImage: image)

        XCTAssertTrue(result.observations.isEmpty)
        XCTAssertNil(result.parsed.name)
        XCTAssertTrue(result.originalImage === image, "OCR 失败不应丢弃原始图")
    }

    func testInvalidImageThrowsInvalidImage() {
        let pipeline = ScanPipeline(
            detector: StubCardDetector(),
            corrector: PassthroughImageCorrector(),
            ocr: StubOCRService()
        )

        XCTAssertThrowsError(try pipeline.run(originalImage: UIImage())) { error in
            guard case ScanPipelineError.invalidImage = error else {
                return XCTFail("应抛出 invalidImage，实际：\(error)")
            }
        }
    }
}
