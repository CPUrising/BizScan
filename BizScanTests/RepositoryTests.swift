import XCTest
import BizScanCore
@testable import BizScan

@MainActor
final class RepositoryTests: XCTestCase {
    func testSaveAndFetchCard() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "CardImages/a.jpg", name: "David Chen")

        try repository.save(card)
        let all = try repository.fetchAll()

        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.name, "David Chen")
        XCTAssertEqual(try repository.fetch(id: card.id)?.name, "David Chen")
    }

    func testFetchAllSortedByUpdatedAtDescending() throws {
        let repository = InMemoryBusinessCardRepository()
        let old = BusinessCard(
            originalImagePath: "a.jpg",
            name: "Old",
            createdAt: Date(timeIntervalSince1970: 100),
            updatedAt: Date(timeIntervalSince1970: 100)
        )
        let recent = BusinessCard(
            originalImagePath: "b.jpg",
            name: "Recent",
            createdAt: Date(timeIntervalSince1970: 200),
            updatedAt: Date(timeIntervalSince1970: 200)
        )

        try repository.save(old)
        try repository.save(recent)

        XCTAssertEqual(try repository.fetchAll().first?.name, "Recent")
    }

    func testDeleteRemovesCard() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David")
        try repository.save(card)

        try repository.delete(id: card.id)

        XCTAssertTrue(try repository.fetchAll().isEmpty)
        XCTAssertNil(try repository.fetch(id: card.id))
    }

    func testTagCreationIsCaseInsensitive() throws {
        let repository = InMemoryBusinessCardRepository()
        let first = try repository.createTag("Conference")
        let second = try repository.createTag("  conference  ")

        XCTAssertEqual(first, "Conference")
        XCTAssertEqual(second, "Conference")
        XCTAssertEqual(try repository.allTags(), ["Conference"])
    }

    func testEmptyTagIsRejected() {
        let repository = InMemoryBusinessCardRepository()
        XCTAssertThrowsError(try repository.createTag("   "))
    }

    func testDeleteTagRemovesItFromCards() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David", tags: ["Customer", "Partner"])
        try repository.save(card)

        try repository.deleteTag("customer")

        let stored = try repository.fetch(id: card.id)
        XCTAssertEqual(stored?.tags, ["Partner"])
        XCTAssertEqual(try repository.allTags().filter { $0 == "Customer" }, [])
    }
}
