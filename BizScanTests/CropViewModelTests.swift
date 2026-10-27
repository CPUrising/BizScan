import XCTest
import UIKit
import CoreGraphics
import BizScanCore
@testable import BizScan

/// T06 回退分支与 T20 校正页行为：默认四点、检测结果应用、90° 旋转、处理成功/失败。
@MainActor
final class CropViewModelTests: XCTestCase {
    private struct SampleError: Error {}

    private final class ThrowingCorrector: ImageCorrecting {
        func correct(image: CGImage, quad: CardQuad?, rotationQuarterTurns: Int) throws -> CGImage {
            throw SampleError()
        }
    }

    private func makeImage(width: Int = 200, height: Int = 100) -> UIImage {
        TestSupport.makeImage(
            color: .gray,
            size: CGSize(width: width, height: height)
        )
    }

    private func makePipeline(
        detector: CardDetecting = StubCardDetector(),
        corrector: ImageCorrecting = PassthroughImageCorrector(),
        ocr: OCRRecognizing = StubOCRService()
    ) -> ScanPipeline {
        ScanPipeline(detector: detector, corrector: corrector, ocr: ocr)
    }

    private func wait(
        for condition: @escaping () -> Bool,
        timeout: TimeInterval = 5,
        message: String
    ) async {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in condition() },
            object: nil
        )
        let result = await XCTWaiter().fulfillment(of: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, message)
    }

    func testT06KeepsDefaultPointsWhenDetectionReturnsNil() {
        let viewModel = CropViewModel(
            originalImage: makeImage(),
            pipeline: makePipeline(detector: StubCardDetector(quad: nil))
        )
        let defaults = viewModel.points

        viewModel.detectIfNeeded()

        XCTAssertEqual(viewModel.points, defaults)
        XCTAssertNil(viewModel.detectionConfidence)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testDetectionAppliesQuadAndConfidence() {
        let quad = CardQuad(
            topLeft: CGPoint(x: 20, y: 10),
            topRight: CGPoint(x: 180, y: 10),
            bottomRight: CGPoint(x: 180, y: 90),
            bottomLeft: CGPoint(x: 20, y: 90),
            confidence: 0.87
        )
        let viewModel = CropViewModel(
            originalImage: makeImage(width: 200, height: 100),
            pipeline: makePipeline(detector: StubCardDetector(quad: quad))
        )

        viewModel.detectIfNeeded()

        let expected = [
            CGPoint(x: 0.1, y: 0.1),
            CGPoint(x: 0.9, y: 0.1),
            CGPoint(x: 0.9, y: 0.9),
            CGPoint(x: 0.1, y: 0.9)
        ]
        XCTAssertEqual(viewModel.points.count, expected.count)
        for (actual, target) in zip(viewModel.points, expected) {
            XCTAssertEqual(actual.x, target.x, accuracy: 1e-6)
            XCTAssertEqual(actual.y, target.y, accuracy: 1e-6)
        }
        XCTAssertEqual(viewModel.detectionConfidence ?? 0, 0.87, accuracy: 1e-6)
    }

    func testRotateCyclesQuarterTurns() {
        let viewModel = CropViewModel(originalImage: makeImage(), pipeline: makePipeline())

        XCTAssertEqual(viewModel.rotationQuarterTurns, 0)
        viewModel.rotate()
        XCTAssertEqual(viewModel.rotationQuarterTurns, 1)
        viewModel.rotate()
        XCTAssertEqual(viewModel.rotationQuarterTurns, 2)
        viewModel.rotate()
        XCTAssertEqual(viewModel.rotationQuarterTurns, 3)
        viewModel.rotate()
        XCTAssertEqual(viewModel.rotationQuarterTurns, 0)
    }

    func testT20ProcessProducesResultFromManualPoints() async {
        let pipeline = makePipeline(ocr: StubOCRService(observations: [OCRObservation(text: "David Chen")]))
        let viewModel = CropViewModel(originalImage: makeImage(), pipeline: pipeline)

        viewModel.rotate()
        viewModel.process()

        await wait(for: { viewModel.result != nil }, message: "process 应产出结果")
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertEqual(viewModel.result?.parsed.name, "David Chen")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testProcessFailureSetsErrorMessage() async {
        let viewModel = CropViewModel(
            originalImage: makeImage(),
            pipeline: makePipeline(corrector: ThrowingCorrector())
        )

        viewModel.process()

        await wait(for: { viewModel.errorMessage != nil }, message: "校正失败应写入错误信息")
        XCTAssertNil(viewModel.result)
        XCTAssertFalse(viewModel.isProcessing)
    }
}
