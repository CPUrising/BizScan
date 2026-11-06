import XCTest
import BizScanCore
@testable import BizScan

/// 0007 的列表 VM 公开方法。
@MainActor
final class HomeViewModelTests: XCTestCase {
    private func makeCard(
        name: String,
        tags: [String] = [],
        group: String? = nil,
        updatedAt: TimeInterval
    ) -> BusinessCard {
        BusinessCard(
            originalImagePath: "CardImages/\(name).jpg",
            name: name,
            tags: tags,
            group: group,
            createdAt: Date(timeIntervalSince1970: updatedAt),
            updatedAt: Date(timeIntervalSince1970: updatedAt)
        )
    }

    func testReloadSortsByCreatedAtDescending() throws {
        let older = makeCard(name: "Older", updatedAt: 100)
        let newer = makeCard(name: "Newer", updatedAt: 200)
        let repository = InMemoryBusinessCardRepository(cards: [older, newer])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()

        XCTAssertEqual(viewModel.cards.map(\.name), ["Newer", "Older"])
        XCTAssertEqual(viewModel.sections.first?.cards.map(\.name), ["Newer", "Older"])
        XCTAssertFalse(viewModel.isEmpty)
    }

    func testSectionsGroupByCreatedDay() throws {
        let dayOne = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 26))!
        let dayTwo = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 27))!
        let first = BusinessCard(
            originalImagePath: nil,
            name: "First",
            createdAt: dayOne,
            updatedAt: dayOne
        )
        let second = BusinessCard(
            originalImagePath: nil,
            name: "Second",
            createdAt: dayTwo,
            updatedAt: dayTwo
        )
        let repository = InMemoryBusinessCardRepository(cards: [first, second])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()

        XCTAssertEqual(viewModel.sections.map(\.title), ["2026-10-27", "2026-10-26"])
        XCTAssertEqual(viewModel.sections.first?.cards.map(\.name), ["Second"])
    }

    func testEditingDoesNotMoveCardToAnotherDay() throws {
        let created = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 26))!
        var card = BusinessCard(
            originalImagePath: nil,
            name: "Edited",
            createdAt: created,
            updatedAt: created
        )
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())
        viewModel.reload()

        card.name = "Edited Again"
        card.touch()
        try repository.save(card)
        viewModel.reload()

        XCTAssertEqual(viewModel.sections.map(\.title), ["2026-10-26"])
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

    func testGroupFilterShowsOnlyGroupCards() throws {
        let customer = makeCard(name: "Alice", group: "客户", updatedAt: 100)
        let partner = makeCard(name: "Bob", group: "合作伙伴", updatedAt: 200)
        let repository = InMemoryBusinessCardRepository(cards: [customer, partner])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()
        viewModel.selectGroup("客户")

        XCTAssertEqual(viewModel.visibleCards.map(\.name), ["Alice"])
        XCTAssertEqual(viewModel.currentGroupTitle, "客户")
        XCTAssertEqual(viewModel.count(in: "客户"), 1)
        XCTAssertEqual(viewModel.count(in: nil), 2)

        viewModel.selectGroup(nil)

        XCTAssertNil(viewModel.selectedGroup)
        XCTAssertEqual(viewModel.visibleCards.count, 2)
    }

    func testReloadResetsSelectionWhenGroupIsDeleted() throws {
        let customer = makeCard(name: "Alice", group: "客户", updatedAt: 100)
        let repository = InMemoryBusinessCardRepository(cards: [customer], groups: ["客户"])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()
        viewModel.selectGroup("客户")
        try repository.deleteGroup("客户")
        viewModel.reload()

        XCTAssertNil(viewModel.selectedGroup)
        XCTAssertTrue(viewModel.groups.isEmpty)
        XCTAssertEqual(viewModel.visibleCards.count, 1)
    }

    func testMoveCardToGroup() throws {
        let card = makeCard(name: "Alice", updatedAt: 100)
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = HomeViewModel(repository: repository, imageStore: InMemoryImageStore())

        viewModel.reload()
        viewModel.move(card, to: "客户")
        viewModel.selectGroup("客户")

        XCTAssertEqual(viewModel.visibleCards.map(\.name), ["Alice"])
        XCTAssertEqual(try repository.fetch(id: card.id)?.group, "客户")
    }
}
