import Foundation

/// 标签的唯一性与筛选规则。持久化实现负责把结果写回名片。
public struct TagStore: Equatable, Sendable {
    public private(set) var tags: [String]

    public init(tags: [String] = []) {
        self.tags = []
        var seen: Set<String> = []
        for tag in tags {
            let display = ContactNormalizer.trimming(ContactNormalizer.halfWidth(tag))
            guard !display.isEmpty else { continue }
            let key = Self.normalize(display)
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            self.tags.append(display)
        }
    }

    public static func normalize(_ raw: String) -> String {
        ContactNormalizer.trimming(ContactNormalizer.halfWidth(raw)).lowercased()
    }

    /// 返回规范化后的标签名；空字符串返回 nil，重复标签返回已有写法。
    @discardableResult
    public mutating func add(_ raw: String) -> String? {
        let display = ContactNormalizer.trimming(ContactNormalizer.halfWidth(raw))
        guard !display.isEmpty else { return nil }

        let key = Self.normalize(display)
        if let existing = tags.first(where: { Self.normalize($0) == key }) {
            return existing
        }

        tags.append(display)
        return display
    }

    public mutating func remove(_ raw: String) {
        let key = Self.normalize(raw)
        guard !key.isEmpty else { return }
        tags.removeAll { Self.normalize($0) == key }
    }

    public func contains(_ raw: String) -> Bool {
        let key = Self.normalize(raw)
        guard !key.isEmpty else { return false }
        return tags.contains { Self.normalize($0) == key }
    }

    public func cards(_ cards: [BusinessCard], taggedWith raw: String) -> [BusinessCard] {
        let key = Self.normalize(raw)
        guard !key.isEmpty else { return [] }
        return cards.filter { card in
            card.tags.contains { Self.normalize($0) == key }
        }
    }

    public static func adding(_ tag: String, to card: BusinessCard) -> BusinessCard {
        let display = ContactNormalizer.trimming(ContactNormalizer.halfWidth(tag))
        guard !display.isEmpty else { return card }

        var updated = card
        let key = normalize(display)
        if !updated.tags.contains(where: { normalize($0) == key }) {
            updated.tags.append(display)
            updated.touch()
        }
        return updated
    }

    public static func removing(_ tag: String, from card: BusinessCard) -> BusinessCard {
        var updated = card
        let key = normalize(tag)
        let before = updated.tags.count
        updated.tags.removeAll { normalize($0) == key }
        if updated.tags.count != before {
            updated.touch()
        }
        return updated
    }
}
