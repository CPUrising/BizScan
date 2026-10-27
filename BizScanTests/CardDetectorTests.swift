import XCTest
import UIKit
import CoreGraphics
@testable import BizScan

/// T06 的 L2 证据：真实 Vision 矩形检测在合成名片图上的行为。
/// 合成图现场绘制，不依赖 `fixtures/`。
final class CardDetectorTests: XCTestCase {
    private let detector = VisionCardDetector()
    private let canvas = CGSize(width: 1400, height: 900)

    // MARK: - 合成图

    private func makeCanvas(draw: (CGContext) -> Void) -> CGImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: canvas, format: format)
        let image = renderer.image { context in
            UIColor(white: 0.22, alpha: 1).setFill()
            context.fill(CGRect(origin: .zero, size: canvas))
            draw(context.cgContext)
        }
        return image.cgImage!
    }

    private func drawCard(_ rect: CGRect, in context: CGContext) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
        UIColor.white.setFill()
        path.fill()
        UIColor(white: 0.92, alpha: 1).setStroke()
        path.lineWidth = 3
        path.stroke()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        ("David Chen" as NSString).draw(at: CGPoint(x: rect.minX + 60, y: rect.minY + 60), withAttributes: attributes)
        ("ABC Technologies" as NSString).draw(at: CGPoint(x: rect.minX + 60, y: rect.minY + 130), withAttributes: attributes)
    }

    private func bounds(of quad: CardQuad) -> CGRect {
        let xs = quad.points.map(\.x)
        let ys = quad.points.map(\.y)
        return CGRect(
            x: xs.min()!,
            y: ys.min()!,
            width: xs.max()! - xs.min()!,
            height: ys.max()! - ys.min()!
        )
    }

    private func assertClose(_ actual: CGRect, _ expected: CGRect, tolerance: CGFloat = 0.12) {
        let dx = canvas.width * tolerance
        let dy = canvas.height * tolerance
        XCTAssertEqual(actual.minX, expected.minX, accuracy: dx, "左边界偏差过大")
        XCTAssertEqual(actual.minY, expected.minY, accuracy: dy, "上边界偏差过大")
        XCTAssertEqual(actual.maxX, expected.maxX, accuracy: dx, "右边界偏差过大")
        XCTAssertEqual(actual.maxY, expected.maxY, accuracy: dy, "下边界偏差过大")
    }

    // MARK: - 用例

    func testT06DetectsClearCardOnContrastBackground() throws {
        let card = CGRect(x: 120, y: 160, width: 1160, height: 600)
        let image = makeCanvas { context in drawCard(card, in: context) }

        let quad = try XCTUnwrap(detector.detectQuad(in: image), "高对比合成名片应被检测到")
        assertClose(bounds(of: quad), card)
        XCTAssertGreaterThan(quad.confidence, 0.4)
    }

    func testT06DetectsTiltedCard() throws {
        let corners = [
            CGPoint(x: 300, y: 150),
            CGPoint(x: 1150, y: 220),
            CGPoint(x: 1250, y: 760),
            CGPoint(x: 220, y: 700)
        ]
        let image = makeCanvas { context in
            let path = UIBezierPath()
            path.move(to: corners[0])
            for point in corners.dropFirst() { path.addLine(to: point) }
            path.close()
            UIColor.white.setFill()
            path.fill()
            UIColor(white: 0.9, alpha: 1).setStroke()
            path.lineWidth = 4
            path.stroke()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                .foregroundColor: UIColor.black
            ]
            ("David Chen" as NSString).draw(at: CGPoint(x: 420, y: 300), withAttributes: attributes)
        }

        let quad = try XCTUnwrap(detector.detectQuad(in: image), "倾斜名片应被检测到")
        XCTAssertGreaterThan(quad.confidence, 0.4)

        let xs = corners.map(\.x)
        let ys = corners.map(\.y)
        let expected = CGRect(
            x: xs.min()!,
            y: ys.min()!,
            width: xs.max()! - xs.min()!,
            height: ys.max()! - ys.min()!
        )
        assertClose(bounds(of: quad), expected, tolerance: 0.15)
    }

    func testT06BlankImageReturnsNil() throws {
        let image = makeCanvas { _ in }
        XCTAssertNil(try detector.detectQuad(in: image), "无边缘的纯色图不应返回四边形")
    }

    func testStubDetectorPropagatesError() {
        struct SampleError: Error {}
        let stub = StubCardDetector(error: SampleError())
        let image = TestSupport.makeImage(color: .gray, size: CGSize(width: 40, height: 40)).cgImage!

        XCTAssertThrowsError(try stub.detectQuad(in: image)) { error in
            XCTAssertTrue(error is SampleError, "替身应原样抛出注入的错误")
        }
    }
}
