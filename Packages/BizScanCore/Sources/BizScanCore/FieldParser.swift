import Foundation

/// 字段解析结果。`unresolvedLines` 保存无法确定归属的文本，供人工校正查看。
public struct ParsedCard: Equatable, Sendable {
    public var name: String?
    public var company: String?
    public var jobTitle: String?
    public var department: String?
    public var mobiles: [String] = []
    public var officePhones: [String] = []
    public var faxes: [String] = []
    public var emails: [String] = []
    public var website: String?
    public var address: String?
    public var postalCode: String?
    public var unresolvedLines: [String] = []
    public var diagnostics: [ParsingDiagnostic] = []

    public init() {}

    /// 把解析结果预填进待校正的名片。只填充解析出值的字段。
    public func apply(to card: inout BusinessCard) {
        if let name { card.name = name }
        if let company { card.company = company }
        if let jobTitle { card.jobTitle = jobTitle }
        if let department { card.department = department }
        if !mobiles.isEmpty { card.mobiles = mobiles }
        if !officePhones.isEmpty { card.officePhones = officePhones }
        if !faxes.isEmpty { card.faxes = faxes }
        if !emails.isEmpty { card.emails = emails }
        if let website { card.website = website }
        if let address { card.address = address }
        if let postalCode { card.postalCode = postalCode }
    }
}

/// 把 OCR 文本映射为八个必选字段。
///
/// 硬约束：只做"分类"，不做"补全"。无法确定的文本进入 `unresolvedLines`，
/// 不写入任何字段；`website` 永远不能由公司名或邮箱推断得出。
public struct FieldParser: Sendable {
    public init() {}

    public func parse(observations: [OCRObservation]) -> ParsedCard {
        let ordered = observations.sorted { lhs, rhs in
            if lhs.lineIndex != rhs.lineIndex {
                return lhs.lineIndex < rhs.lineIndex
            }
            return lhs.boundingBox.centerY > rhs.boundingBox.centerY
        }
        return parse(lines: ordered.map(\.text), confidences: ordered.map(\.confidence))
    }

    public func parse(lines: [String]) -> ParsedCard {
        parse(lines: lines, confidences: lines.map { _ in Float(1) })
    }

    // MARK: - 主流程

    private func parse(lines: [String], confidences: [Float]) -> ParsedCard {
        var result = ParsedCard()

        for (index, rawLine) in lines.enumerated() {
            let line = ContactNormalizer.trimming(ContactNormalizer.halfWidth(rawLine))
            guard !line.isEmpty else { continue }
            let confidence = index < confidences.count ? confidences[index] : Float(1)

            if let split = FieldLabels.splitLabel(from: line),
               let kind = FieldLabels.kind(forLabel: split.label) {
                let cleaned = ContactNormalizer.trimming(split.value)
                if !cleaned.isEmpty {
                    let assigned = assignLabeled(kind: kind, value: cleaned, result: &result)
                    result.diagnostics.append(
                        ParsingDiagnostic(
                            line: line,
                            field: kind,
                            reason: assigned ? .labeledField : .duplicate,
                            rule: "label:\(split.label)",
                            confidence: confidence
                        )
                    )
                    continue
                }
            }

            consumeUnlabeled(line: line, confidence: confidence, result: &result)
        }

        return result
    }

    private func consumeUnlabeled(line: String, confidence: Float, result: inout ParsedCard) {
        if let email = firstMatch(emailPattern, in: line) {
            if appendUnique(email.lowercased(), to: &result.emails, key: { $0.lowercased() }) {
                result.diagnostics.append(diag(line, .email, .patternMatch, "email", confidence))
            }
            return
        }

        if !line.contains("@"), let site = firstMatch(websitePattern, in: line) {
            if let normalized = ContactNormalizer.normalizedWebsite(site),
               setSingle(&result.website, value: normalized) {
                result.diagnostics.append(diag(line, .website, .patternMatch, "website", confidence))
            }
            return
        }

        let trimmed = ContactNormalizer.trimming(line)
        if PhoneClassifier.isPhoneLike(trimmed) {
            let classified = PhoneClassifier.classify(trimmed)
            switch classified.kind {
            case .mobile:
                if appendUnique(classified.value, to: &result.mobiles, key: ContactNormalizer.phoneKey) {
                    result.diagnostics.append(diag(line, .mobile, .patternMatch, "phone:mobile", confidence))
                }
                return
            case .office:
                if appendUnique(classified.value, to: &result.officePhones, key: ContactNormalizer.phoneKey) {
                    result.diagnostics.append(diag(line, .officePhone, .patternMatch, "phone:office", confidence))
                }
                return
            case .fax:
                if appendUnique(classified.value, to: &result.faxes, key: ContactNormalizer.phoneKey) {
                    result.diagnostics.append(diag(line, .fax, .patternMatch, "phone:fax", confidence))
                }
                return
            case .unknown:
                result.unresolvedLines.append(line)
                result.diagnostics.append(diag(line, nil, .ambiguous, "phone:unknown", confidence))
                return
            }
        }

        if containsCJK(line) && containsLatin(line) {
            if consumeMixedLine(line, confidence: confidence, result: &result) {
                return
            }
        }

        if isCompanyLine(line) {
            if setSingle(&result.company, value: line) {
                result.diagnostics.append(diag(line, .company, .patternMatch, "company-keyword", confidence))
            } else {
                result.unresolvedLines.append(line)
                result.diagnostics.append(diag(line, .company, .duplicate, "company-keyword", confidence))
            }
            return
        }

        if isJobTitleLine(line) {
            if setSingle(&result.jobTitle, value: line) {
                result.diagnostics.append(diag(line, .jobTitle, .patternMatch, "title-keyword", confidence))
            } else {
                result.unresolvedLines.append(line)
                result.diagnostics.append(diag(line, .jobTitle, .duplicate, "title-keyword", confidence))
            }
            return
        }

        if let candidate = nameCandidate(from: line), result.name == nil {
            result.name = candidate
            result.diagnostics.append(diag(line, .name, .patternMatch, "name-shape", confidence))
            return
        }

        if isAddressLine(line) {
            if appendAddress(line, result: &result) {
                result.diagnostics.append(diag(line, .address, .patternMatch, "address-keyword", confidence))
            } else {
                result.unresolvedLines.append(line)
                result.diagnostics.append(diag(line, .address, .duplicate, "address-keyword", confidence))
            }
            return
        }

        result.unresolvedLines.append(line)
        result.diagnostics.append(diag(line, nil, .unresolved, "no-rule", confidence))
    }

    // MARK: - 标签赋值

    @discardableResult
    private func assignLabeled(kind: FieldKind, value: String, result: inout ParsedCard) -> Bool {
        switch kind {
        case .name:
            return setSingle(&result.name, value: stripHonorifics(value))
        case .company:
            return setSingle(&result.company, value: value)
        case .jobTitle:
            return setSingle(&result.jobTitle, value: value)
        case .department:
            return setSingle(&result.department, value: value)
        case .mobile:
            return appendUnique(value, to: &result.mobiles, key: ContactNormalizer.phoneKey)
        case .officePhone:
            return appendUnique(value, to: &result.officePhones, key: ContactNormalizer.phoneKey)
        case .fax:
            return appendUnique(value, to: &result.faxes, key: ContactNormalizer.phoneKey)
        case .email:
            guard let email = ContactNormalizer.normalizedEmail(value) else { return false }
            return appendUnique(email, to: &result.emails, key: { $0.lowercased() })
        case .website:
            guard let site = ContactNormalizer.normalizedWebsite(value) else { return false }
            return setSingle(&result.website, value: site)
        case .address:
            return appendAddress(value, result: &result)
        case .postalCode:
            let digits = ContactNormalizer.digits(value)
            guard (4...10).contains(digits.count) else { return false }
            return setSingle(&result.postalCode, value: digits)
        }
    }

    // MARK: - 启发式规则

    private func consumeMixedLine(_ line: String, confidence: Float, result: inout ParsedCard) -> Bool {
        var tokens = line.split(whereSeparator: { $0 == " " || $0 == "\u{3000}" }).map(String.init)
        guard !tokens.isEmpty else { return false }

        var assigned = false

        if result.name == nil, let index = tokens.firstIndex(where: { isCJKNameToken($0) }) {
            result.name = tokens.remove(at: index)
            result.diagnostics.append(diag(line, .name, .patternMatch, "mixed:cjk-token", confidence))
            assigned = true
        }

        if result.jobTitle == nil, let index = tokens.firstIndex(where: { isJobTitleToken($0) }) {
            result.jobTitle = tokens.remove(at: index)
            result.diagnostics.append(diag(line, .jobTitle, .patternMatch, "mixed:title-token", confidence))
            assigned = true
        }

        let remainder = tokens.joined(separator: " ")
        if !remainder.isEmpty {
            if result.company == nil, isCompanyLine(remainder) {
                result.company = remainder
                result.diagnostics.append(diag(line, .company, .patternMatch, "mixed:company-rest", confidence))
                assigned = true
            } else {
                result.unresolvedLines.append(remainder)
                result.diagnostics.append(diag(remainder, nil, .unresolved, "mixed:rest", confidence))
            }
        }

        return assigned
    }

    private func isCompanyLine(_ line: String) -> Bool {
        containsKeyword(line, in: FieldLabels.companyKeywords)
    }

    private func isJobTitleLine(_ line: String) -> Bool {
        containsKeyword(line, in: FieldLabels.jobTitleKeywords)
    }

    private func isAddressLine(_ line: String) -> Bool {
        guard line.contains(where: { $0.isNumber }) else { return false }
        return containsKeyword(line, in: FieldLabels.addressKeywords)
    }

    private func containsKeyword(_ line: String, in keywords: [String]) -> Bool {
        keywords.contains { keyword in
            if containsCJK(keyword) {
                return line.contains(keyword)
            }
            return containsLatinWord(line, keyword)
        }
    }

    private func isJobTitleToken(_ token: String) -> Bool {
        FieldLabels.jobTitleKeywords.contains { keyword in
            if containsCJK(keyword) {
                return token.contains(keyword)
            }
            return token.lowercased() == keyword
        }
    }

    private func isCJKNameToken(_ token: String) -> Bool {
        let scalars = token.unicodeScalars
        guard !scalars.isEmpty, scalars.allSatisfy({ isCJK($0) }) else { return false }
        return (2...4).contains(scalars.count)
    }

    private func nameCandidate(from line: String) -> String? {
        let stripped = stripHonorifics(line)
        guard !stripped.isEmpty, !stripped.contains("@") else { return nil }
        guard !stripped.contains(where: { $0.isNumber }) else { return nil }

        let tokens = stripped.split(whereSeparator: { $0 == " " || $0 == "\u{3000}" }).map(String.init)

        if tokens.count == 1 {
            return isCJKNameToken(tokens[0]) ? tokens[0] : nil
        }

        guard (2...3).contains(tokens.count) else { return nil }
        guard tokens.allSatisfy({ isCapitalizedLatinToken($0) }) else { return nil }
        return stripped
    }

    private func isCapitalizedLatinToken(_ token: String) -> Bool {
        guard let first = token.unicodeScalars.first else { return false }
        guard first.value >= 65, first.value <= 90 else { return false }
        guard token.unicodeScalars.allSatisfy({ scalar in
            (scalar.value >= 65 && scalar.value <= 90)
                || (scalar.value >= 97 && scalar.value <= 122)
                || scalar.value == 45
                || scalar.value == 46
                || scalar.value == 39
        }) else { return false }
        return true
    }

    private func stripHonorifics(_ text: String) -> String {
        let honorifics = ["professor", "prof.", "prof", "dr.", "dr", "mr.", "mr", "mrs.", "mrs", "ms.", "ms", "sir"]
        var result = ContactNormalizer.trimming(text)
        let lowered = result.lowercased()
        for honorific in honorifics where lowered.hasPrefix(honorific + " ") {
            result = String(result.dropFirst(honorific.count + 1))
            break
        }
        return ContactNormalizer.trimming(result)
    }

    // MARK: - 基础操作

    private func setSingle(_ target: inout String?, value: String) -> Bool {
        let cleaned = ContactNormalizer.trimming(value)
        guard !cleaned.isEmpty else { return false }
        guard target == nil || target?.isEmpty == true else { return false }
        target = cleaned
        return true
    }

    private func appendUnique(
        _ value: String,
        to array: inout [String],
        key: (String) -> String
    ) -> Bool {
        let cleaned = ContactNormalizer.trimming(value)
        guard !cleaned.isEmpty else { return false }
        let newKey = key(cleaned)
        guard !newKey.isEmpty else { return false }
        guard !array.contains(where: { key($0) == newKey }) else { return false }
        array.append(cleaned)
        return true
    }

    private func appendAddress(_ value: String, result: inout ParsedCard) -> Bool {
        let cleaned = ContactNormalizer.trimming(value)
        guard !cleaned.isEmpty else { return false }
        guard let existing = result.address, !existing.isEmpty else {
            result.address = cleaned
            return true
        }
        if ContactNormalizer.equalsIgnoringCaseAndSpaces(existing, cleaned) { return false }
        result.address = existing + "\n" + cleaned
        return true
    }

    private func diag(
        _ line: String,
        _ field: FieldKind?,
        _ reason: DiagnosticReason,
        _ rule: String,
        _ confidence: Float
    ) -> ParsingDiagnostic {
        ParsingDiagnostic(line: line, field: field, reason: reason, rule: rule, confidence: confidence)
    }

    private func firstMatch(_ pattern: String, in text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, options: [], range: range),
              let matchRange = Range(match.range, in: text) else {
            return nil
        }
        return String(text[matchRange])
    }

    // MARK: - 正则

    private var emailPattern: String {
        #"[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}"#
    }

    private var websitePattern: String {
        #"(?:(?:https?://)|(?:www\.))?[A-Za-z0-9](?:[A-Za-z0-9\-]*[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9\-]*[A-Za-z0-9])?)*\.(?:com|cn|edu|org|net|io|co|gov|info|tech|ai|me|tv|hk|us|uk|de|jp)(?:/[^\s]*)?"#
    }
}

// MARK: - 字符判定

private func isCJK(_ scalar: Unicode.Scalar) -> Bool {
    (0x4E00...0x9FFF).contains(scalar.value) || (0x3400...0x4DBF).contains(scalar.value)
}

private func containsCJK(_ text: String) -> Bool {
    text.unicodeScalars.contains(where: isCJK)
}

private func containsLatin(_ text: String) -> Bool {
    text.unicodeScalars.contains { scalar in
        (scalar.value >= 65 && scalar.value <= 90) || (scalar.value >= 97 && scalar.value <= 122)
    }
}

private func containsLatinWord(_ text: String, _ word: String) -> Bool {
    let lowered = text.lowercased()
    var searchStart = lowered.startIndex
    while searchStart < lowered.endIndex,
          let range = lowered.range(of: word, range: searchStart..<lowered.endIndex) {
        let beforeOK: Bool
        if range.lowerBound == lowered.startIndex {
            beforeOK = true
        } else {
            let previous = lowered[lowered.index(before: range.lowerBound)]
            beforeOK = !(previous.isLetter || previous.isNumber)
        }

        let afterOK: Bool
        if range.upperBound == lowered.endIndex {
            afterOK = true
        } else {
            let next = lowered[range.upperBound]
            afterOK = !(next.isLetter || next.isNumber)
        }

        if beforeOK && afterOK { return true }
        searchStart = lowered.index(after: range.lowerBound)
    }
    return false
}
