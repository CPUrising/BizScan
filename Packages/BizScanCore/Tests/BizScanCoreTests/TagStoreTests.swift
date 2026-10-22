import XCTest
@testable import BizScanCore

final class TagStoreTests: XCTestCase {
    func testT16AddAndFilter() {
        var store = TagStore()
        XCTAssertEqual(store.add("Conference"), "Conference")

        var card = BusinessCard(originalImagePath: "a.jpg", name: "David Chen")
        card = TagStore.adding("Conference", to: card)

        let results = store.cards([card], taggedWith: "conference")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(store.tags, ["Conference"])
    }

    func testDuplicateTagIsReused() {
        var store = TagStore()
        _ = store.add("Customer")
        let second = store.add("  customer  ")

        XCTAssertEqual(second, "Customer")
        XCTAssertEqual(store.tags.count, 1)
    }

    func testEmptyTagIsIgnored() {
        var store = TagStore()
        XCTAssertNil(store.add("   "))
        XCTAssertTrue(store.tags.isEmpty)
    }

    func testRemoveTag() {
        var store = TagStore(tags: ["Conference", "Customer"])
        store.remove("conference")

        XCTAssertEqual(store.tags, ["Customer"])
        XCTAssertFalse(store.contains("Conference"))
    }

    func testRemovingTagFromCardKeepsOtherFields() {
        var card = BusinessCard(originalImagePath: "a.jpg", name: "David Chen", company: "ABC")
        card = TagStore.adding("Customer", to: card)
        card = TagStore.adding("Partner", to: card)

        let updated = TagStore.removing("customer", from: card)

        XCTAssertEqual(updated.tags, ["Partner"])
        XCTAssertEqual(updated.name, "David Chen")
        XCTAssertEqual(updated.company, "ABC")
    }

    func testRemovingMissingTagDoesNotChangeTimestamp() {
        let created = Date(timeIntervalSince1970: 0)
        let card = BusinessCard(originalImagePath: "a.jpg", createdAt: created)
        let updated = TagStore.removing("Nope", from: card)

        XCTAssertEqual(updated.updatedAt, created)
    }

    func testAddingSameTagTwiceIsIdempotent() {
        var card = BusinessCard(originalImagePath: "a.jpg")
        card = TagStore.adding("Customer", to: card)
        card = TagStore.adding("customer", to: card)

        XCTAssertEqual(card.tags.count, 1)
    }
}
