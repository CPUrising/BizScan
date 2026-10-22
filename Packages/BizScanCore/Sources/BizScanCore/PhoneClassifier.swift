import Foundation

public enum PhoneKind: String, Codable, Sendable {
    case mobile
    case office
    case fax
    case unknown
}

public struct PhoneClassification: Equatable, Sendable {
    public let value: String
    public let kind: PhoneKind
    public let reason: String

    public init(value: String, kind: PhoneKind, reason: String) {
        self.value = value
        self.kind = kind
        self.reason = reason
    }
}

/// 号码归类：标签优先，格式次之；无法确定时返回 `.unknown`，由调用方放入待定区。
public enum PhoneClassifier {
    public static func classify(_ rawValue: String, label: FieldKind? = nil) -> PhoneClassification {
        let value = ContactNormalizer.stripLabelPrefix(rawValue)
        let national = ContactNormalizer.phoneKey(value)

        guard isPhoneLike(value) else {
            return PhoneClassification(value: value, kind: .unknown, reason: "不是有效号码格式")
        }

        switch label {
        case .mobile:
            return PhoneClassification(value: value, kind: .mobile, reason: "标签指定手机")
        case .officePhone:
            return PhoneClassification(value: value, kind: .office, reason: "标签指定办公电话")
        case .fax:
            return PhoneClassification(value: value, kind: .fax, reason: "标签指定传真")
        default:
            break
        }

        if isChineseMobile(national) {
            return PhoneClassification(value: value, kind: .mobile, reason: "中国手机号段")
        }
        if national.hasPrefix("400") || national.hasPrefix("800") {
            return PhoneClassification(value: value, kind: .office, reason: "企业服务号段")
        }
        if national.hasPrefix("0") {
            return PhoneClassification(value: value, kind: .office, reason: "区号格式")
        }
        if (7...8).contains(national.count) {
            return PhoneClassification(value: value, kind: .office, reason: "本地号码长度")
        }
        return PhoneClassification(value: value, kind: .unknown, reason: "缺少可判定特征")
    }

    /// 判断一行文本是否像电话号码：允许括号、加号、空格、连字符，数字 5~20 位。
    public static func isPhoneLike(_ value: String) -> Bool {
        let normalized = ContactNormalizer.halfWidth(value)
        let digits = ContactNormalizer.digits(normalized)
        guard (5...20).contains(digits.count) else { return false }

        let allowedPunctuation = CharacterSet(charactersIn: "+-() .、,/")
        for scalar in normalized.unicodeScalars {
            if CharacterSet.decimalDigits.contains(scalar) { continue }
            if allowedPunctuation.contains(scalar) { continue }
            return false
        }
        return true
    }

    private static func isChineseMobile(_ digits: String) -> Bool {
        guard digits.count == 11, digits.hasPrefix("1") else { return false }
        let second = digits[digits.index(after: digits.startIndex)]
        return second >= "3" && second <= "9"
    }
}
