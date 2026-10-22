import Foundation

public enum SearchableField: String, Codable, CaseIterable, Sendable {
    case name
    case company
    case jobTitle
    case department
    case phones
    case emails
    case website
    case address
    case notes
}

/// 多字段包含匹配：姓名、公司、职位、电话、邮箱（并额外支持地址与备注）。
public struct SearchQuery: Sendable {
    public let keyword: String

    public init(_ keyword: String) {
        self.keyword = ContactNormalizer.trimming(ContactNormalizer.halfWidth(keyword)).lowercased()
    }

    public var isEmpty: Bool { keyword.isEmpty }

    public func matches(_ card: BusinessCard) -> Bool {
        !matchedFields(in: card).isEmpty
    }

    public func matchedFields(in card: BusinessCard) -> [SearchableField] {
        guard !keyword.isEmpty else { return [] }

        var fields: [SearchableField] = []

        if textMatches(card.name) { fields.append(.name) }
        if textMatches(card.department) { fields.append(.department) }
        if textMatches(card.company) { fields.append(.company) }
        if textMatches(card.jobTitle) { fields.append(.jobTitle) }
        if phoneMatches(card) { fields.append(.phones) }
        if emailMatches(card) { fields.append(.emails) }
        if textMatches(card.website) { fields.append(.website) }
        if textMatches(card.address) { fields.append(.address) }
        if textMatches(card.notes) { fields.append(.notes) }

        return fields
    }

    public func filter(_ cards: [BusinessCard]) -> [BusinessCard] {
        guard !keyword.isEmpty else { return cards }
        return cards.filter { matches($0) }
    }

    private func textMatches(_ value: String?) -> Bool {
        guard let value else { return false }
        return ContactNormalizer.halfWidth(value).lowercased().contains(keyword)
    }

    private func phoneMatches(_ card: BusinessCard) -> Bool {
        let digits = ContactNormalizer.digits(keyword)
        guard !digits.isEmpty else { return false }
        let phones = card.mobiles + card.officePhones + card.faxes
        return phones.contains { ContactNormalizer.phoneKey($0).contains(digits) }
    }

    private func emailMatches(_ card: BusinessCard) -> Bool {
        card.emails.contains { $0.lowercased().contains(keyword) }
    }
}
