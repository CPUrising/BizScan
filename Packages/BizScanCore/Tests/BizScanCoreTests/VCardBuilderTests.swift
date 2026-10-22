import XCTest
@testable import BizScanCore

final class VCardBuilderTests: XCTestCase {
    private func makeCard() -> BusinessCard {
        BusinessCard(
            originalImagePath: "cards/original.jpg",
            name: "David Chen",
            company: "ABC Technologies",
            jobTitle: "Technical Director",
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

    func testT19FieldMapping() {
        let vcard = VCardBuilder.vCard(for: makeCard())

        XCTAssertTrue(vcard.hasPrefix("BEGIN:VCARD\r\n"))
        XCTAssertTrue(vcard.contains("VERSION:3.0"))
        XCTAssertTrue(vcard.contains("FN:David Chen"))
        XCTAssertTrue(vcard.contains("N:Chen;David;;;"))
        XCTAssertTrue(vcard.contains("ORG:ABC Technologies"))
        XCTAssertTrue(vcard.contains("TITLE:Technical Director"))
        XCTAssertTrue(vcard.contains("TEL;TYPE=CELL:+86 138 0000 0000"))
        XCTAssertTrue(vcard.contains("TEL;TYPE=WORK:021-8888-0000"))
        XCTAssertTrue(vcard.contains("TEL;TYPE=FAX:021-8888-0001"))
        XCTAssertTrue(vcard.contains("EMAIL;TYPE=INTERNET:david.chen@example.com"))
        XCTAssertTrue(vcard.contains("URL:example.com"))
        XCTAssertTrue(vcard.contains("ADR;TYPE=WORK:;;"))
        XCTAssertTrue(vcard.contains("NOTE:Follow up next week"))
        XCTAssertTrue(vcard.hasSuffix("END:VCARD\r\n"))
    }

    func testMultiplePhoneEntriesAreNotMerged() {
        var card = makeCard()
        card.mobiles = ["13800000000", "13900000000"]

        let vcard = VCardBuilder.vCard(for: card)
        let cellLines = vcard
            .components(separatedBy: "\r\n")
            .filter { $0.hasPrefix("TEL;TYPE=CELL:") }

        XCTAssertEqual(cellLines.count, 2)
    }

    func testEmptyFieldsAreOmitted() {
        let card = BusinessCard(originalImagePath: "cards/original.jpg", name: "David Chen")
        let vcard = VCardBuilder.vCard(for: card)

        XCTAssertFalse(vcard.contains("URL:"))
        XCTAssertFalse(vcard.contains("ADR;TYPE=WORK:"))
        XCTAssertFalse(vcard.contains("EMAIL;"))
        XCTAssertFalse(vcard.contains("ORG:"))
        XCTAssertFalse(vcard.contains("NOTE:"))
        XCTAssertTrue(vcard.contains("N:Chen;David;;;"))
    }

    func testEscapingSpecialCharacters() {
        XCTAssertEqual(
            VCardBuilder.escape("A;B,C\nD\\E"),
            "A\\;B\\,C\\nD\\\\E"
        )

        var card = BusinessCard(originalImagePath: "cards/original.jpg", notes: "Line1\nLine2;Note")
        card.name = nil
        let vcard = VCardBuilder.vCard(for: card)
        XCTAssertTrue(vcard.contains("NOTE:Line1\\nLine2\\;Note"))
    }

    func testLineFoldingRespects75ByteLimit() {
        let longNote = String(repeating: "x", count: 200)
        let card = BusinessCard(originalImagePath: "cards/original.jpg", notes: longNote)
        let vcard = VCardBuilder.vCard(for: card)

        let lines = vcard.components(separatedBy: "\r\n").filter { !$0.isEmpty }
        for line in lines {
            XCTAssertLessThanOrEqual(line.utf8.count, 75, "折行超过 75 字节: \(line)")
        }
    }

    func testMultipleCardsProduceMultipleVCards() {
        let cards = [
            BusinessCard(originalImagePath: "a.jpg", name: "Alice"),
            BusinessCard(originalImagePath: "b.jpg", name: "Bob")
        ]

        let output = VCardBuilder.vCards(for: cards)
        let beginCount = output.components(separatedBy: "BEGIN:VCARD").count - 1
        XCTAssertEqual(beginCount, 2)
    }

    func testMissingNameUsesEmptyStructuredName() {
        let card = BusinessCard(originalImagePath: "cards/original.jpg", company: "ABC Technologies")
        let vcard = VCardBuilder.vCard(for: card)

        XCTAssertTrue(vcard.contains("FN:ABC Technologies"))
        XCTAssertTrue(vcard.contains("N:;;;;"))
    }
}
