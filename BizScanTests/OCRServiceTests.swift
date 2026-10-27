import XCTest
import UIKit
import BizScanCore
@testable import BizScan

/// T07 的 L2 证据：真实 Vision OCR 在合成名片图上的原始文本与坐标。
final class OCRServiceTests: XCTestCase {
    private let service = VisionOCRService()
    private let canvas = CGSize(width: 1400, height: 900)

    private func makeCardImage(lines: [String]) -> CGImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: canvas, format: format)
        let image = renderer.image { _ in
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: canvas)).fill()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 44, weight: .semibold),
                .foregroundColor: UIColor.black
            ]
            for (index, line) in lines.enumerated() {
                (line as NSString).draw(
                    at: CGPoint(x: 120, y: 160 + CGFloat(index) * 110),
                    withAttributes: attributes
                )
            }
        }
        return image.cgImage!
    }

    func testT07RecognizesSyntheticCardText() throws {
        let image = makeCardImage(lines: ["David Chen", "ABC Technologies"])

        let observations = try service.recognizeText(in: image)
        let joined = observations.map(\.text).joined().lowercased().replacingOccurrences(of: " ", with: "")

        XCTAssertFalse(observations.isEmpty, "合成名片应产生至少一条 OCR 观察")
        XCTAssertTrue(joined.contains("davidchen"), "原始文本应包含姓名，实际：\(observations.map(\.text))")
        XCTAssertTrue(joined.contains("abctechnologies"), "原始文本应包含公司，实际：\(observations.map(\.text))")
    }

    func testObservationsUseNormalizedBoundingBox() throws {
        let image = makeCardImage(lines: ["David Chen", "ABC Technologies"])

        let observations = try service.recognizeText(in: image)
        XCTAssertFalse(observations.isEmpty)

        for observation in observations {
            let box = observation.boundingBox
            XCTAssertTrue((0...1).contains(box.x), "x 越界：\(box)")
            XCTAssertTrue((0...1).contains(box.y), "y 越界：\(box)")
            XCTAssertGreaterThan(box.width, 0)
            XCTAssertGreaterThan(box.height, 0)
            XCTAssertLessThanOrEqual(box.x + box.width, 1.0001)
            XCTAssertLessThanOrEqual(box.y + box.height, 1.0001)
        }
    }

    func testEmptyImageReturnsEmptyObservations() throws {
        let image = TestSupport.makeImage(
            color: .white,
            size: CGSize(width: 800, height: 500)
        ).cgImage!

        XCTAssertTrue(try service.recognizeText(in: image).isEmpty)
    }
}
