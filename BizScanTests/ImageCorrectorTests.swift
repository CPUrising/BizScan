import XCTest
import UIKit
import CoreGraphics
@testable import BizScan

/// T20 的 L2 证据：Core Image 透视校正与 90° 旋转的实际输出尺寸。
final class ImageCorrectorTests: XCTestCase {
    private let corrector = CoreImageCorrector()

    private func makeSourceImage(width: Int = 1400, height: Int = 900) -> CGImage {
        // scale = 1：让 points 与 pixels 一致，避免 3x 渲染让尺寸断言按倍数偏差。
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: width, height: height),
            format: format
        )
        let image = renderer.image { context in
            UIColor.lightGray.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
        return image.cgImage!
    }

    /// 居中的名片四边形，四周留白，用于验证透视输出比原图小。
    private func makeCardQuad(width: Int, height: Int) -> CardQuad {
        let insetX = CGFloat(width) * 0.08
        let insetY = CGFloat(height) * 0.12
        return CardQuad(
            topLeft: CGPoint(x: insetX, y: insetY),
            topRight: CGPoint(x: CGFloat(width) - insetX, y: insetY),
            bottomRight: CGPoint(x: CGFloat(width) - insetX, y: CGFloat(height) - insetY),
            bottomLeft: CGPoint(x: insetX, y: CGFloat(height) - insetY),
            confidence: 0.9
        )
    }

    func testCorrectWithQuadProducesCardSizedOutput() throws {
        let source = makeSourceImage()
        let quad = makeCardQuad(width: source.width, height: source.height)

        let output = try corrector.correct(image: source, quad: quad, rotationQuarterTurns: 0)

        XCTAssertGreaterThan(output.width, 0)
        XCTAssertGreaterThan(output.height, 0)
        let ratio = Double(output.width) / Double(output.height)
        XCTAssertTrue((1.2...2.2).contains(ratio), "输出宽高比应接近横版名片，实际 \(ratio)")
        XCTAssertLessThan(output.width, source.width)
        XCTAssertLessThan(output.height, source.height)
    }

    func testRotationQuarterTurnsSwapDimensions() throws {
        let source = makeSourceImage(width: 400, height: 200)

        let zero = try corrector.correct(image: source, quad: nil, rotationQuarterTurns: 0)
        XCTAssertEqual(zero.width, 400)
        XCTAssertEqual(zero.height, 200)

        let one = try corrector.correct(image: source, quad: nil, rotationQuarterTurns: 1)
        XCTAssertEqual(one.width, 200)
        XCTAssertEqual(one.height, 400)

        let two = try corrector.correct(image: source, quad: nil, rotationQuarterTurns: 2)
        XCTAssertEqual(two.width, 400)
        XCTAssertEqual(two.height, 200)

        let three = try corrector.correct(image: source, quad: nil, rotationQuarterTurns: 3)
        XCTAssertEqual(three.width, 200)
        XCTAssertEqual(three.height, 400)
    }

    func testNilQuadKeepsOriginalExtent() throws {
        let source = makeSourceImage(width: 640, height: 480)
        let output = try corrector.correct(image: source, quad: nil, rotationQuarterTurns: 0)

        XCTAssertEqual(output.width, 640)
        XCTAssertEqual(output.height, 480)
    }
}
