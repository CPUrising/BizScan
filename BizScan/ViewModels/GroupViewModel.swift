import Foundation
import Observation
import BizScanCore

@Observable
@MainActor
final class GroupViewModel {
    private let repository: BusinessCardRepository

    private(set) var groups: [String] = []
    private(set) var counts: [String: Int] = [:]
    private(set) var totalCount = 0

    var errorMessage: String?

    init(repository: BusinessCardRepository) {
        self.repository = repository
    }

    func reload() {
        do {
            let cards = try repository.fetchAll()
            groups = try repository.allGroups()
            totalCount = cards.count
            var counts: [String: Int] = [:]
            for card in cards {
                guard let group = card.group else { continue }
                counts[group, default: 0] += 1
            }
            self.counts = counts
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func count(for group: String?) -> Int {
        guard let group else { return totalCount }
        return counts.first { $0.key.caseInsensitiveCompare(group) == .orderedSame }?.value ?? 0
    }

    func create(_ name: String) -> String? {
        do {
            let created = try repository.createGroup(name)
            reload()
            return created
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func rename(_ group: String, to newName: String) {
        do {
            try repository.renameGroup(from: group, to: newName)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ group: String) {
        do {
            try repository.deleteGroup(group)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
