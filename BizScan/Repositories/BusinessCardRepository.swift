import Foundation
import BizScanCore

enum RepositoryError: LocalizedError {
    case emptyTag
    case cardNotFound

    var errorDescription: String? {
        switch self {
        case .emptyTag:
            return "标签名称不能为空。"
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
}

/// 内存实现：用于 Preview、单元测试与无持久化场景。
@MainActor
final class InMemoryBusinessCardRepository: BusinessCardRepository {
    private var cards: [UUID: BusinessCard]
    private var tags: [String]

    init(cards: [BusinessCard] = [], tags: [String] = []) {
        self.cards = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
        self.tags = []
        var seen: Set<String> = []
        for tag in tags {
            let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(tag))
            guard !trimmed.isEmpty else { continue }
            let key = trimmed.lowercased()
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            self.tags.append(trimmed)
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
}
