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
        try context.save()
    }

    func delete(id: UUID) throws {
        guard let entity = try fetchEntity(id: id) else { return }
        imageStore.delete(relativePath: entity.originalImagePath)
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

    private func fetchEntity(id: UUID) throws -> BusinessCardEntity? {
        var descriptor = FetchDescriptor<BusinessCardEntity>(
            predicate: #Predicate { entity in entity.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
