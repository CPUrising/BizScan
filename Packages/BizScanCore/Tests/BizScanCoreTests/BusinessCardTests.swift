import XCTest
@testable import BizScanCore

final class BusinessCardTests: XCTestCase {
    func testDisplayTitleFallbackOrder() {
        var card = BusinessCard(originalImagePath: "cards/original.jpg")
        XCTAssertEqual(card.displayTitle(), "未命名名片")

        card.company = "ABC Technologies"
        XCTAssertEqual(card.displayTitle(), "ABC Technologies")

        card.name = "David Chen"
        XCTAssertEqual(card.displayTitle(), "David Chen")
    }

    func testDisplaySubtitleFallbackOrder() {
        var card = BusinessCard(originalImagePath: "cards/original.jpg")
        XCTAssertNil(card.displaySubtitle)

        card.emails = ["david@example.com"]
        XCTAssertEqual(card.displaySubtitle, "david@example.com")

        card.mobiles = ["+86 138 0000 0000"]
        XCTAssertEqual(card.displaySubtitle, "+86 138 0000 0000")

        card.jobTitle = "Technical Director"
        XCTAssertEqual(card.displaySubtitle, "Technical Director")

        card.company = "ABC Technologies"
        XCTAssertEqual(card.displaySubtitle, "ABC Technologies")
    }

    func testIsEmptyIgnoresWhitespaceOnlyValues() {
        var card = BusinessCard(originalImagePath: "cards/original.jpg")
        card.name = "   "
        card.notes = "\n"
        XCTAssertTrue(card.isEmpty)

        card.name = "David"
        XCTAssertFalse(card.isEmpty)

        let withPhone = BusinessCard(originalImagePath: "cards/original.jpg", mobiles: ["13800000000"])
        XCTAssertFalse(withPhone.isEmpty)
    }

    func testTouchUpdatesTimestampOnly() {
        let created = Date(timeIntervalSince1970: 1_000)
        var card = BusinessCard(originalImagePath: "cards/original.jpg", createdAt: created)
        XCTAssertEqual(card.updatedAt, created)

        let edited = created.addingTimeInterval(120)
        card.touch(at: edited)
        XCTAssertEqual(card.updatedAt, edited)
        XCTAssertEqual(card.createdAt, created)
    }

    func testUnrecognizedFieldsDefaultToNilOrEmpty() {
        let card = BusinessCard(originalImagePath: "cards/original.jpg")
        XCTAssertNil(card.name)
        XCTAssertNil(card.website)
        XCTAssertNil(card.address)
        XCTAssertTrue(card.mobiles.isEmpty)
        XCTAssertTrue(card.emails.isEmpty)
        XCTAssertTrue(card.tags.isEmpty)
    }
}
