import Foundation
import Observation
import UIKit
import BizScanCore

@Observable
@MainActor
final class HomeViewModel {
    private let repository: BusinessCardRepository
    private let imageStore: ImageStoring

    private(set) var cards: [BusinessCard] = []
    private(set) var tags: [String] = []
    private(set) var isLoading = false

    var selectedTag: String?
    var errorMessage: String?

    init(repository: BusinessCardRepository, imageStore: ImageStoring) {
        self.repository = repository
        self.imageStore = imageStore
    }

    var visibleCards: [BusinessCard] {
        guard let selectedTag else { return cards }
        return cards.filter { card in
            card.tags.contains { $0.caseInsensitiveCompare(selectedTag) == .orderedSame }
        }
    }

    var isEmpty: Bool { cards.isEmpty }

    func reload() {
        isLoading = true
        defer { isLoading = false }
        do {
            cards = try repository.fetchAll()
            tags = try repository.allTags()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ card: BusinessCard) {
        do {
            try repository.delete(id: card.id)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleTagFilter(_ tag: String) {
        selectedTag = selectedTag == tag ? nil : tag
    }

    func thumbnail(for card: BusinessCard) -> UIImage? {
        if let processed = card.processedImagePath,
           let image = imageStore.image(forRelativePath: processed) {
            return image
        }
        return imageStore.image(forRelativePath: card.originalImagePath)
    }
}
