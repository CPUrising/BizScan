import XCTest
import BizScanCore
@testable import BizScan

/// 0006 / 0007 的 ViewModel 公开方法（AGENTS.md 第 4 节要求）。
@MainActor
final class DetailViewModelTests: XCTestCase {
    private func makeCard() -> BusinessCard {
        BusinessCard(
            originalImagePath: "CardImages/original.jpg",
            processedImagePath: "CardImages/processed.jpg",
            name: "David Chen",
            company: "ABC Technologies",
            jobTitle: "Technical Director",
            department: "Engineering",
            mobiles: ["+86 138 0000 0000"],
            officePhones: ["021-8888-0000"],
            faxes: ["021-8888-0001"],
            emails: ["david.chen@example.com"],
            website: "example.com",
            address: "123 Market Street, San Francisco",
            postalCode: "200000",
            notes: "Follow up next week"
        )
    }

    func testLoadPopulatesDisplayRows() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()

        XCTAssertEqual(viewModel.name, "David Chen")
        XCTAssertEqual(viewModel.mobilesText, "+86 138 0000 0000")
        XCTAssertEqual(viewModel.tags, [])

        let rows = viewModel.displayRows
        XCTAssertTrue(rows.contains { $0.0 == "姓名" && $0.1 == "David Chen" })
        XCTAssertTrue(rows.contains { $0.0 == "公司" && $0.1 == "ABC Technologies" })
        XCTAssertTrue(rows.contains { $0.0 == "手机" && $0.1 == "+86 138 0000 0000" })
        XCTAssertTrue(rows.contains { $0.0 == "传真" && $0.1 == "021-8888-0001" })
        XCTAssertTrue(rows.contains { $0.0 == "备注" && $0.1 == "Follow up next week" })
    }

    func testCancelEditingRestoresOriginalValues() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()
        viewModel.beginEditing()
        viewModel.name = "Temporary Edit"
        viewModel.cancelEditing()

        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.name, "David Chen")
    }

    func testSaveWritesEditedNameAndTouchesUpdatedAt() throws {
        let past = Date(timeIntervalSince1970: 1_600_000_000)
        var card = makeCard()
        card.updatedAt = past
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()
        viewModel.beginEditing()
        viewModel.name = "David C. Chen"
        viewModel.save()

        let stored = try XCTUnwrap(try repository.fetch(id: card.id))
        XCTAssertEqual(stored.name, "David C. Chen")
        XCTAssertGreaterThan(stored.updatedAt, past)
        XCTAssertFalse(viewModel.isEditing)
    }

    func testDeleteRemovesCardAndSetsDidDelete() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()
        viewModel.delete()

        XCTAssertTrue(viewModel.didDelete)
        XCTAssertNil(try repository.fetch(id: card.id))
    }

    func testAddTagThenSavePersistsToRepository() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()
        viewModel.newTag = "Customer"
        viewModel.addTag()
        XCTAssertEqual(viewModel.newTag, "")
        viewModel.save()

        let stored = try XCTUnwrap(try repository.fetch(id: card.id))
        XCTAssertEqual(stored.tags, ["Customer"])
        XCTAssertEqual(try repository.allTags(), ["Customer"])
    }
}
