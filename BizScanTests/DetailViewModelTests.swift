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

    func testLoadPopulatesContactEntries() throws {
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
        XCTAssertEqual(viewModel.displayName, "David Chen")
        XCTAssertEqual(viewModel.avatarInitial, "D")

        let entries = viewModel.contactEntries
        XCTAssertTrue(entries.contains { $0.kind == .mobile && $0.value == "+86 138 0000 0000" })
        XCTAssertTrue(entries.contains { $0.kind == .officePhone && $0.value == "021-8888-0000" })
        XCTAssertTrue(entries.contains { $0.kind == .fax && $0.value == "021-8888-0001" })
        XCTAssertTrue(entries.contains { $0.kind == .email && $0.value == "david.chen@example.com" })
        XCTAssertTrue(entries.contains { $0.kind == .address && $0.value.contains("Market Street") })
        XCTAssertEqual(viewModel.notesText, "Follow up next week")
    }

    func testAvatarInitialFallsBackToCompany() throws {
        let card = BusinessCard(
            originalImagePath: nil,
            company: "Northwind Studio"
        )
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()

        XCTAssertEqual(viewModel.avatarInitial, "N")
        XCTAssertEqual(viewModel.displayName, "Northwind Studio")
    }

    func testQuickActionURLsFollowFieldPresence() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )
        viewModel.load()

        XCTAssertEqual(viewModel.primaryPhoneURL?.absoluteString, "tel://+8613800000000")
        XCTAssertNotNil(viewModel.mapsURL)
        XCTAssertNotNil(viewModel.notesText)

        let empty = BusinessCard(originalImagePath: nil)
        let emptyRepository = InMemoryBusinessCardRepository(cards: [empty])
        let emptyViewModel = DetailViewModel(
            cardID: empty.id,
            repository: emptyRepository,
            imageStore: InMemoryImageStore()
        )
        emptyViewModel.load()

        XCTAssertNil(emptyViewModel.primaryPhoneURL)
        XCTAssertNil(emptyViewModel.mapsURL)
        XCTAssertNil(emptyViewModel.notesText)
    }

    func testContactEntriesCarryReviewFlag() throws {
        var card = makeCard()
        card.unverifiedValues = ["+86 138 0000 0000"]
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )
        viewModel.load()

        let mobile = try XCTUnwrap(viewModel.contactEntries.first { $0.kind == .mobile })
        let office = try XCTUnwrap(viewModel.contactEntries.first { $0.kind == .officePhone })
        XCTAssertTrue(mobile.needsReview)
        XCTAssertFalse(office.needsReview)
    }

    func testSavingCorrectedValueClearsReviewFlag() throws {
        var card = makeCard()
        card.unverifiedValues = ["+86 138 0000 0000"]
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )
        viewModel.load()

        viewModel.beginEditing()
        viewModel.mobilesText = "13800000001"
        viewModel.save()

        let stored = try XCTUnwrap(try repository.fetch(id: card.id))
        XCTAssertTrue(stored.unverifiedValues.isEmpty)
        XCTAssertEqual(viewModel.contactEntries.first { $0.kind == .mobile }?.needsReview, false)
    }

    func testToggleFavoritePersists() throws {
        let card = makeCard()
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )
        viewModel.load()

        XCTAssertFalse(viewModel.isFavorite)

        viewModel.toggleFavorite()

        XCTAssertTrue(viewModel.isFavorite)
        XCTAssertEqual(try repository.fetch(id: card.id)?.isFavorite, true)

        viewModel.toggleFavorite()

        XCTAssertFalse(viewModel.isFavorite)
        XCTAssertEqual(try repository.fetch(id: card.id)?.isFavorite, false)
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

    func testNotesCanBeAddedEditedAndCleared() throws {
        var card = makeCard()
        card.notes = nil
        let repository = InMemoryBusinessCardRepository(cards: [card])
        let viewModel = DetailViewModel(
            cardID: card.id,
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.load()
        XCTAssertEqual(viewModel.notes, "")

        viewModel.beginEditing()
        viewModel.notes = "2026 Mobile Computing Conference"
        viewModel.save()
        XCTAssertEqual(try repository.fetch(id: card.id)?.notes, "2026 Mobile Computing Conference")
        XCTAssertEqual(viewModel.notesText, "2026 Mobile Computing Conference")

        viewModel.beginEditing()
        viewModel.notes = "Follow up next week"
        viewModel.save()
        XCTAssertEqual(try repository.fetch(id: card.id)?.notes, "Follow up next week")

        viewModel.beginEditing()
        viewModel.notes = "   "
        viewModel.save()
        XCTAssertNil(try repository.fetch(id: card.id)?.notes)
        XCTAssertNil(viewModel.notesText)
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
