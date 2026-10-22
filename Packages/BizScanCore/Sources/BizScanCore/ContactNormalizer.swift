import Foundation

/// 文本归一化工具：全角半角、标签前缀、号码/邮箱/网址的比较键。
public enum ContactNormalizer {
    public static func trimming(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 全角转半角（含全角空格），保持字符数一一对应。
    public static func halfWidth(_ text: String) -> String {
        var result = String.UnicodeScalarView()
        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x3000:
                result.append(Unicode.Scalar(UInt32(0x20))!)
            case 0xFF01...0xFF5E:
                result.append(Unicode.Scalar(scalar.value - 0xFEE0)!)
            default:
                result.append(scalar)
            }
        }
        return String(result)
    }

    /// 只保留数字，用于号码比较。
    public static func digits(_ text: String) -> String {
        var result = ""
        for scalar in halfWidth(text).unicodeScalars where scalar.value >= 48 && scalar.value <= 57 {
            result.append(Character(scalar))
        }
        return result
    }

    /// 号码比较键：去国家码差异，避免同一号码被当成两个值。
    public static func phoneKey(_ text: String) -> String {
        var value = digits(text)
        if value.hasPrefix("0086") {
            value.removeFirst(4)
        } else if value.hasPrefix("86"), value.count > 11 {
            value.removeFirst(2)
        }
        return value
    }

    public static func normalizedEmail(_ text: String) -> String? {
        let value = trimming(halfWidth(text)).lowercased()
        guard !value.isEmpty, !value.contains(" "), value.contains("@") else { return nil }
        guard let regex = emailRegex else { return nil }
        let range = NSRange(value.startIndex..<value.endIndex, in: value)
        return regex.firstMatch(in: value, options: [], range: range) != nil ? value : nil
    }

    public static func normalizedWebsite(_ text: String) -> String? {
        var value = trimming(halfWidth(text)).lowercased()
        guard !value.isEmpty, !value.contains(" "), !value.contains("@") else { return nil }

        for scheme in ["https://", "http://"] where value.hasPrefix(scheme) {
            value.removeFirst(scheme.count)
        }
        if value.hasPrefix("www.") {
            value.removeFirst(4)
        }
        while value.hasSuffix("/") {
            value.removeLast()
        }
        guard value.contains("."), value.count >= 4 else { return nil }
        guard let lastComponent = value.split(separator: ".").last,
              lastComponent.count >= 2,
              lastComponent.allSatisfy({ $0.isLetter }) else {
            return nil
        }
        return value
    }

    /// 去掉行首的字段标签，例如 `"Mobile: +86..."` → `"+86..."`。
    public static func stripLabelPrefix(_ line: String) -> String {
        guard let (_, value) = FieldLabels.splitLabel(from: line) else {
            return trimming(line)
        }
        return trimming(value)
    }

    public static func equalsIgnoringCaseAndSpaces(_ lhs: String, _ rhs: String) -> Bool {
        let left = halfWidth(lhs).replacingOccurrences(of: " ", with: "").lowercased()
        let right = halfWidth(rhs).replacingOccurrences(of: " ", with: "").lowercased()
        return left == right
    }

    private static let emailRegex = try? NSRegularExpression(
        pattern: #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
    )
}
