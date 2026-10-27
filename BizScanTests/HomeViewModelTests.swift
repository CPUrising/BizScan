import XCTest
import BizScanCore
@testable import BizScan

/// 0007 的列表 VM 公开方法。
@MainActor
final class HomeViewModelTests: XCTestCase {
    private func makeCard(
        name: String,
        tags: [String] = [],
        updatedAt: TimeInterval
    ) -> BusinessCard {
        BusinessCard(
            originalImagePath: "CardImages/\(name).jpg",
            name: name,
            tags: tags,
            createdAt: Date(timeIntervalSince1970: updatedAt),
            updatedAt: Date(timeIntervalSince1970: updatedAt)
        )
    }

    func testReloadSortsByUpdatedAtDescending() throws {
        let older = makeCard(name: "Older", updatedAt: 100)
        let newer = makeCard(name: "Newer", updatedAt: 200)
        let repository = InMemoryBusinessCardRepository(cards: [older, newer])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()

        XCTAssertEqual(viewModel.cards.map(\.name), ["Newer", "Older"])
        XCTAssertFalse(viewModel.isEmpty)
    }

    func testDeleteRemovesCardFromList() throws {
        let first = makeCard(name: "Alice", updatedAt: 100)
        let second = makeCard(name: "Bob", updatedAt: 200)
        let repository = InMemoryBusinessCardRepository(cards: [first, second])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()
        viewModel.delete(first)

        XCTAssertEqual(viewModel.cards.map(\.name), ["Bob"])
        XCTAssertNil(try repository.fetch(id: first.id))
    }

    func testToggleTagFilterShowsOnlyTaggedCards() throws {
        let customer = makeCard(name: "Alice", tags: ["Customer"], updatedAt: 100)
        let partner = makeCard(name: "Bob", tags: ["Partner"], updatedAt: 200)
        let repository = InMemoryBusinessCardRepository(cards: [customer, partner])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()
        viewModel.toggleTagFilter("customer")

        XCTAssertEqual(viewModel.visibleCards.map(\.name), ["Alice"])

        viewModel.toggleTagFilter("customer")

        XCTAssertNil(viewModel.selectedTag)
        XCTAssertEqual(viewModel.visibleCards.count, 2)
    }
}
