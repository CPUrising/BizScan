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
    private(set) var groups: [String] = []
    private(set) var isLoading = false

    var selectedGroup: String?
    var errorMessage: String?

    init(repository: BusinessCardRepository, imageStore: ImageStoring) {
        self.repository = repository
        self.imageStore = imageStore
    }

    var visibleCards: [BusinessCard] {
        guard let selectedGroup else { return cards }
        return cards.filter { $0.group?.caseInsensitiveCompare(selectedGroup) == .orderedSame }
    }

    var sections: [HomeCardSection] {
        let sorted = visibleCards.sorted { $0.createdAt > $1.createdAt }
        var sections: [HomeCardSection] = []
        for card in sorted {
            let day = Calendar.current.startOfDay(for: card.createdAt)
            if let last = sections.indices.last, sections[last].day == day {
                sections[last].cards.append(card)
            } else {
                sections.append(
                    HomeCardSection(day: day, title: Self.dayFormatter.string(from: day), cards: [card])
                )
            }
        }
        return sections
    }

    var currentGroupTitle: String {
        selectedGroup ?? AppCopy.allGroups
    }

    var isEmpty: Bool { cards.isEmpty }

    func reload() {
        isLoading = true
        defer { isLoading = false }
        do {
            cards = try repository.fetchAll()
            groups = try repository.allGroups()
            if let selectedGroup,
               !groups.contains(where: { $0.caseInsensitiveCompare(selectedGroup) == .orderedSame }) {
                self.selectedGroup = nil
            }
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

    func selectGroup(_ group: String?) {
        selectedGroup = group
    }

    func move(_ card: BusinessCard, to group: String?) {
        do {
            try repository.setGroup(cardID: card.id, to: group)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func count(in group: String?) -> Int {
        guard let group else { return cards.count }
        return cards.filter { $0.group?.caseInsensitiveCompare(group) == .orderedSame }.count
    }

    func thumbnail(for card: BusinessCard) -> UIImage? {
        if let processed = card.processedImagePath,
           let image = imageStore.image(forRelativePath: processed) {
            return image
        }
        guard let original = card.originalImagePath else { return nil }
        return imageStore.image(forRelativePath: original)
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

struct HomeCardSection: Identifiable {
    let day: Date
    let title: String
    var cards: [BusinessCard]

    var id: Date { day }
}
