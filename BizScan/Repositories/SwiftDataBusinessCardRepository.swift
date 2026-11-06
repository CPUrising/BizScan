import Foundation
import SwiftData
import BizScanCore

@MainActor
final class SwiftDataBusinessCardRepository: BusinessCardRepository {
    private let context: ModelContext
    private let imageStore: ImageStoring

    init(context: ModelContext, imageStore: ImageStoring = FileImageStore()) {
        self.context = context
        self.imageStore = imageStore
    }

    func fetchAll() throws -> [BusinessCard] {
        let descriptor = FetchDescriptor<BusinessCardEntity>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map(\.domainModel)
    }

    func fetch(id: UUID) throws -> BusinessCard? {
        try fetchEntity(id: id)?.domainModel
    }

    func save(_ card: BusinessCard) throws {
        if let entity = try fetchEntity(id: card.id) {
            entity.apply(card)
        } else {
            context.insert(BusinessCardEntity(card: card))
        }
        for tag in card.tags {
            _ = try createTag(tag)
        }
        if let group = card.group, !group.isEmpty {
            _ = try createGroup(group)
        }
        try context.save()
    }

    func delete(id: UUID) throws {
        guard let entity = try fetchEntity(id: id) else { return }
        if let original = entity.originalImagePath {
            imageStore.delete(relativePath: original)
        }
        if let processed = entity.processedImagePath {
            imageStore.delete(relativePath: processed)
        }
        context.delete(entity)
        try context.save()
    }

    func allTags() throws -> [String] {
        let descriptor = FetchDescriptor<TagEntity>(sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor).map(\.name)
    }

    func createTag(_ name: String) throws -> String {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(name))
        guard !trimmed.isEmpty else { throw RepositoryError.emptyTag }

        let key = trimmed.lowercased()
        let all = try context.fetch(FetchDescriptor<TagEntity>())
        if let existing = all.first(where: { $0.name.lowercased() == key }) {
            return existing.name
        }

        context.insert(TagEntity(name: trimmed))
        try context.save()
        return trimmed
    }

    func deleteTag(_ name: String) throws {
        let key = ContactNormalizer.halfWidth(name).lowercased()

        let tagEntities = try context.fetch(FetchDescriptor<TagEntity>())
        for tag in tagEntities where ContactNormalizer.halfWidth(tag.name).lowercased() == key {
            context.delete(tag)
        }

        let cardEntities = try context.fetch(FetchDescriptor<BusinessCardEntity>())
        for card in cardEntities {
            card.tags.removeAll { ContactNormalizer.halfWidth($0).lowercased() == key }
        }

        try context.save()
    }

    func allGroups() throws -> [String] {
        let entities = try context.fetch(FetchDescriptor<CardGroupEntity>())
        let cards = try context.fetch(FetchDescriptor<BusinessCardEntity>())

        var names = entities.map(\.name)
        var seen = Set(names.map { $0.lowercased() })
        for card in cards {
            guard let raw = card.groupName else { continue }
            let name = Self.normalizedGroupName(raw)
            guard let name, !seen.contains(name.lowercased()) else { continue }
            names.append(name)
            seen.insert(name.lowercased())
        }
        return names.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    func createGroup(_ name: String) throws -> String {
        guard let trimmed = Self.normalizedGroupName(name) else {
            throw RepositoryError.emptyGroup
        }

        let key = trimmed.lowercased()
        let all = try context.fetch(FetchDescriptor<CardGroupEntity>())
        if let existing = all.first(where: { $0.name.lowercased() == key }) {
            return existing.name
        }

        context.insert(CardGroupEntity(name: trimmed))
        try context.save()
        return trimmed
    }

    func renameGroup(from oldName: String, to newName: String) throws {
        guard let trimmed = Self.normalizedGroupName(newName) else {
            throw RepositoryError.emptyGroup
        }

        let key = ContactNormalizer.halfWidth(oldName).lowercased()
        let all = try context.fetch(FetchDescriptor<CardGroupEntity>())
        guard let entity = all.first(where: { $0.name.lowercased() == key }) else { return }
        let current = entity.name
        if current.caseInsensitiveCompare(trimmed) == .orderedSame { return }
        if all.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            throw RepositoryError.duplicateGroup
        }

        entity.name = trimmed
        let cards = try context.fetch(FetchDescriptor<BusinessCardEntity>())
        for card in cards where card.groupName?.caseInsensitiveCompare(current) == .orderedSame {
            card.groupName = trimmed
        }
        try context.save()
    }

    func deleteGroup(_ name: String) throws {
        let key = ContactNormalizer.halfWidth(name).lowercased()

        let groups = try context.fetch(FetchDescriptor<CardGroupEntity>())
        for group in groups where ContactNormalizer.halfWidth(group.name).lowercased() == key {
            context.delete(group)
        }

        let cards = try context.fetch(FetchDescriptor<BusinessCardEntity>())
        for card in cards where ContactNormalizer.halfWidth(card.groupName ?? "").lowercased() == key {
            card.groupName = nil
        }

        try context.save()
    }

    func setGroup(cardID: UUID, to group: String?) throws {
        guard let entity = try fetchEntity(id: cardID) else {
            throw RepositoryError.cardNotFound
        }
        if let group, let trimmed = Self.normalizedGroupName(group) {
            entity.groupName = trimmed
            _ = try createGroup(trimmed)
        } else {
            entity.groupName = nil
        }
        try context.save()
    }

    func fetchCards(group: String?) throws -> [BusinessCard] {
        let all = try fetchAll()
        guard let group else { return all }
        return all.filter { $0.group?.caseInsensitiveCompare(group) == .orderedSame }
    }

    private static func normalizedGroupName(_ name: String) -> String? {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(name))
        return trimmed.isEmpty ? nil : trimmed
    }

    private func fetchEntity(id: UUID) throws -> BusinessCardEntity? {
        var descriptor = FetchDescriptor<BusinessCardEntity>(
            predicate: #Predicate { entity in entity.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
