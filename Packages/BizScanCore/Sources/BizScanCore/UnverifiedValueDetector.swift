import Foundation

/// 判定哪些已识别值需要人工复核：低置信度 OCR 或歧义解析。
///
/// 只标记已经写入模型的真实值，不生成新值。
public struct UnverifiedValueDetector {
    public static let defaultThreshold: Float = 0.7

    public static func detect(
        parsed: ParsedCard,
        observations: [OCRObservation],
        threshold: Float = defaultThreshold
    ) -> [String] {
        let candidates: [(FieldKind, String)] = candidates(in: parsed)
        var result: [String] = []

        for (kind, value) in candidates {
            guard !value.isEmpty else { continue }
            if result.contains(value) { continue }

            if isMarkedByDiagnostic(value: value, kind: kind, diagnostics: parsed.diagnostics)
                || isMarkedByLowConfidence(value: value, observations: observations, threshold: threshold) {
                result.append(value)
            }
        }

        return result
    }

    private static func candidates(in parsed: ParsedCard) -> [(FieldKind, String)] {
        var list: [(FieldKind, String)] = []
        for phone in parsed.mobiles { list.append((.mobile, phone)) }
        for phone in parsed.officePhones { list.append((.officePhone, phone)) }
        for fax in parsed.faxes { list.append((.fax, fax)) }
        for email in parsed.emails { list.append((.email, email)) }
        if let address = parsed.address, !address.isEmpty {
            list.append((.address, address))
        }
        return list
    }

    private static func isMarkedByDiagnostic(
        value: String,
        kind: FieldKind,
        diagnostics: [ParsingDiagnostic]
    ) -> Bool {
        diagnostics.contains { diagnostic in
            guard diagnostic.reason == .ambiguous || diagnostic.reason == .invalidFormat else {
                return false
            }
            guard diagnostic.field == nil || diagnostic.field == kind else { return false }
            return overlaps(diagnostic.line, value)
        }
    }

    private static func isMarkedByLowConfidence(
        value: String,
        observations: [OCRObservation],
        threshold: Float
    ) -> Bool {
        observations.contains { observation in
            observation.confidence < threshold && overlaps(observation.text, value)
        }
    }

    private static func overlaps(_ line: String, _ value: String) -> Bool {
        let normalizedLine = normalize(line)
        let normalizedValue = normalize(value)
        guard !normalizedValue.isEmpty, !normalizedLine.isEmpty else { return false }
        return normalizedLine.contains(normalizedValue) || normalizedValue.contains(normalizedLine)
    }

    private static func normalize(_ text: String) -> String {
        text.filter { !$0.isWhitespace }.lowercased()
    }
}
