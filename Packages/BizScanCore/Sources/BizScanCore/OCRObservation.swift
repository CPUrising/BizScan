import Foundation

/// 归一化矩形（原点左下，与 Vision 的 boundingBox 约定一致）。
public struct NormalizedRect: Codable, Equatable, Sendable {
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    public static let full = NormalizedRect(x: 0, y: 0, width: 1, height: 1)

    public var centerY: Double { y + height / 2 }
}

/// OCR 的一个文本观察单元。
public struct OCRObservation: Codable, Equatable, Sendable {
    public var text: String
    public var confidence: Float
    public var boundingBox: NormalizedRect
    /// OCR 输出顺序；用于在版面坐标不可靠时保持阅读顺序。
    public var lineIndex: Int

    public init(
        text: String,
        confidence: Float = 1.0,
        boundingBox: NormalizedRect = .full,
        lineIndex: Int = 0
    ) {
        self.text = text
        self.confidence = confidence
        self.boundingBox = boundingBox
        self.lineIndex = lineIndex
    }
}

public extension Array where Element == OCRObservation {
    /// 按阅读顺序返回文本行：先按 `lineIndex`，再按版面从上到下。
    func readableLines() -> [String] {
        sorted { lhs, rhs in
            if lhs.lineIndex != rhs.lineIndex {
                return lhs.lineIndex < rhs.lineIndex
            }
            return lhs.boundingBox.centerY > rhs.boundingBox.centerY
        }
        .map(\.text)
    }
}
