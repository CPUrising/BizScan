import Foundation
import BizScanCore

enum RepositoryError: LocalizedError {
    case emptyTag
    case emptyGroup
    case duplicateGroup
    case cardNotFound

    var errorDescription: String? {
        switch self {
        case .emptyTag:
            return "标签名称不能为空。"
        case .emptyGroup:
            return "分组名称不能为空。"
        case .duplicateGroup:
            return "已存在同名分组。"
        case .cardNotFound:
            return "名片不存在，可能已被删除。"
        }
    }
}

@MainActor
protocol BusinessCardRepository: AnyObject {
    func fetchAll() throws -> [BusinessCard]
    func fetch(id: UUID) throws -> BusinessCard?
    func save(_ card: BusinessCard) throws
    func delete(id: UUID) throws

    func allTags() throws -> [String]
    func createTag(_ name: String) throws -> String
    func deleteTag(_ name: String) throws

    func allGroups() throws -> [String]
    func createGroup(_ name: String) throws -> String
    func renameGroup(from: String, to: String) throws
    func deleteGroup(_ name: String) throws
    func setGroup(cardID: UUID, to group: String?) throws
    func fetchCards(group: String?) throws -> [BusinessCard]
}

/// 内存实现：用于 Preview、单元测试与无持久化场景。
@MainActor
final class InMemoryBusinessCardRepository: BusinessCardRepository {
    private var cards: [UUID: BusinessCard]
    private var tags: [String]
    private var groups: [String]

    init(cards: [BusinessCard] = [], tags: [String] = [], groups: [String] = []) {
        self.cards = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
        self.tags = []
        self.groups = []
        var seen: Set<String> = []
        for tag in tags {
            let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(tag))
            guard !trimmed.isEmpty else { continue }
            let key = trimmed.lowercased()
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            self.tags.append(trimmed)
        }
        var seenGroups: Set<String> = []
        for group in groups {
            let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(group))
            guard !trimmed.isEmpty else { continue }
            let key = trimmed.lowercased()
            guard !seenGroups.contains(key) else { continue }
            seenGroups.insert(key)
            self.groups.append(trimmed)
        }
    }

    func fetchAll() throws -> [BusinessCard] {
        cards.values.sorted { $0.updatedAt > $1.updatedAt }
    }

    func fetch(id: UUID) throws -> BusinessCard? {
        cards[id]
    }

    func save(_ card: BusinessCard) throws {
        cards[card.id] = card
        for tag in card.tags {
            _ = try createTag(tag)
        }
        if let group = card.group, !group.isEmpty {
            _ = try createGroup(group)
        }
    }

    func delete(id: UUID) throws {
        cards.removeValue(forKey: id)
    }

    func allTags() throws -> [String] {
        tags
    }

    func createTag(_ name: String) throws -> String {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(name))
        guard !trimmed.isEmpty else { throw RepositoryError.emptyTag }

        let key = trimmed.lowercased()
        if let existing = tags.first(where: { $0.lowercased() == key }) {
            return existing
        }
        tags.append(trimmed)
        return trimmed
    }

    func deleteTag(_ name: String) throws {
        let key = ContactNormalizer.halfWidth(name).lowercased()
        tags.removeAll { ContactNormalizer.halfWidth($0).lowercased() == key }
        for (id, card) in cards {
            var updated = card
            updated.tags.removeAll { ContactNormalizer.halfWidth($0).lowercased() == key }
            cards[id] = updated
        }
    }

    func allGroups() throws -> [String] {
        var names = groups
        var seen = Set(names.map { $0.lowercased() })
        for card in cards.values {
            guard let group = card.group, !group.isEmpty else { continue }
            let key = ContactNormalizer.halfWidth(group).lowercased()
            guard !seen.contains(key) else { continue }
            names.append(group)
            seen.insert(key)
        }
        return names.sorted()
    }

    func createGroup(_ name: String) throws -> String {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(name))
        guard !trimmed.isEmpty else { throw RepositoryError.emptyGroup }

        let key = trimmed.lowercased()
        if let existing = groups.first(where: { $0.lowercased() == key }) {
            return existing
        }
        groups.append(trimmed)
        return trimmed
    }

    func renameGroup(from oldName: String, to newName: String) throws {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(newName))
        guard !trimmed.isEmpty else { throw RepositoryError.emptyGroup }

        let oldKey = ContactNormalizer.halfWidth(oldName).lowercased()
        guard let index = groups.firstIndex(where: { $0.lowercased() == oldKey }) else { return }
        let current = groups[index]
        if current.caseInsensitiveCompare(trimmed) == .orderedSame { return }
        if groups.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            throw RepositoryError.duplicateGroup
        }

        groups[index] = trimmed
        for (id, card) in cards where card.group?.caseInsensitiveCompare(current) == .orderedSame {
            var updated = card
            updated.group = trimmed
            cards[id] = updated
        }
    }

    func deleteGroup(_ name: String) throws {
        let key = ContactNormalizer.halfWidth(name).lowercased()
        groups.removeAll { ContactNormalizer.halfWidth($0).lowercased() == key }
        for (id, card) in cards where card.group?.lowercased() == key {
            var updated = card
            updated.group = nil
            cards[id] = updated
        }
    }

    func setGroup(cardID: UUID, to group: String?) throws {
        guard var card = cards[cardID] else { throw RepositoryError.cardNotFound }
        let trimmed = group.map { ContactNormalizer.trimming(ContactNormalizer.halfWidth($0)) } ?? ""
        card.group = trimmed.isEmpty ? nil : trimmed
        cards[cardID] = card
        if let name = card.group {
            _ = try createGroup(name)
        }
    }

    func fetchCards(group: String?) throws -> [BusinessCard] {
        let all = try fetchAll()
        guard let group else { return all }
        return all.filter { $0.group?.caseInsensitiveCompare(group) == .orderedSame }
    }
}
