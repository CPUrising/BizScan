import Foundation
import Observation
import UIKit
import BizScanCore

@Observable
@MainActor
final class SearchViewModel {
    private let repository: BusinessCardRepository
    private let imageStore: ImageStoring

    private(set) var allCards: [BusinessCard] = []
    var keyword = ""
    var errorMessage: String?

    init(repository: BusinessCardRepository, imageStore: ImageStoring) {
        self.repository = repository
        self.imageStore = imageStore
    }

    var results: [BusinessCard] {
        SearchQuery(keyword).filter(allCards)
    }

    func load() {
        do {
            allCards = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func thumbnail(for card: BusinessCard) -> UIImage? {
        if let processed = card.processedImagePath,
           let image = imageStore.image(forRelativePath: processed) {
            return image
        }
        return imageStore.image(forRelativePath: card.originalImagePath)
    }
}
