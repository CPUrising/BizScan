import Foundation

public enum DiagnosticReason: String, Codable, Sendable {
    case labeledField
    case patternMatch
    case ambiguous
    case unresolved
    case duplicate
    case invalidFormat
}

/// 解析依据：每个字段为什么被这样归类，用于错误分析与准确率报告。
public struct ParsingDiagnostic: Codable, Equatable, Sendable {
    public var line: String
    public var field: FieldKind?
    public var reason: DiagnosticReason
    public var rule: String
    public var confidence: Float

    public init(
        line: String,
        field: FieldKind?,
        reason: DiagnosticReason,
        rule: String,
        confidence: Float
    ) {
        self.line = line
        self.field = field
        self.reason = reason
        self.rule = rule
        self.confidence = confidence
    }
}
