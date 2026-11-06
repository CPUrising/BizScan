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

    func testCreateGroupIsCaseInsensitive() throws {
        let repository = InMemoryBusinessCardRepository()
        let first = try repository.createGroup("客户")
        let second = try repository.createGroup(" 客户 ")

        XCTAssertEqual(first, "客户")
        XCTAssertEqual(second, "客户")
        XCTAssertEqual(try repository.allGroups(), ["客户"])
    }

    func testEmptyGroupIsRejected() {
        let repository = InMemoryBusinessCardRepository()
        XCTAssertThrowsError(try repository.createGroup("   "))
    }

    func testSaveCardKeepsGroup() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David", group: "客户")

        try repository.save(card)

        XCTAssertEqual(try repository.fetch(id: card.id)?.group, "客户")
        XCTAssertEqual(try repository.allGroups(), ["客户"])
    }

    func testRenameGroupMovesCards() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David", group: "客户")
        try repository.save(card)

        try repository.renameGroup(from: "客户", to: "重点客户")

        XCTAssertEqual(try repository.fetch(id: card.id)?.group, "重点客户")
        XCTAssertEqual(try repository.allGroups(), ["重点客户"])
    }

    func testRenameGroupRejectsDuplicate() throws {
        let repository = InMemoryBusinessCardRepository()
        _ = try repository.createGroup("客户")
        _ = try repository.createGroup("合作伙伴")

        XCTAssertThrowsError(try repository.renameGroup(from: "客户", to: "合作伙伴"))
    }

    func testDeleteGroupClearsCardGroup() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David", group: "客户")
        try repository.save(card)

        try repository.deleteGroup("客户")

        XCTAssertNil(try repository.fetch(id: card.id)?.group)
        XCTAssertTrue(try repository.allGroups().isEmpty)
    }

    func testSetGroupAssignsAndClears() throws {
        let repository = InMemoryBusinessCardRepository()
        let card = BusinessCard(originalImagePath: "a.jpg", name: "David")
        try repository.save(card)

        try repository.setGroup(cardID: card.id, to: "客户")
        XCTAssertEqual(try repository.fetch(id: card.id)?.group, "客户")
        XCTAssertEqual(try repository.fetchCards(group: "客户").count, 1)

        try repository.setGroup(cardID: card.id, to: nil)
        XCTAssertNil(try repository.fetch(id: card.id)?.group)
        XCTAssertEqual(try repository.fetchCards(group: nil).count, 1)
    }
}
