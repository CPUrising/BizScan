import XCTest
@testable import BizScanCore

final class FieldParserTests: XCTestCase {
    private let parser = FieldParser()

    private func parse(_ lines: [String]) -> ParsedCard {
        parser.parse(lines: lines)
    }

    func testT08StandardEnglishCard() {
        let result = parse([
            "Dr. David Chen",
            "Technical Director",
            "ABC Technologies",
            "Mobile: +1-415-555-0132",
            "Office: +1-415-555-0199",
            "Fax: +1-415-555-0111",
            "Email: david.chen@example.com",
            "Website: www.example.com",
            "Address: 123 Market Street, San Francisco"
        ])

        XCTAssertEqual(result.name, "David Chen")
        XCTAssertEqual(result.jobTitle, "Technical Director")
        XCTAssertEqual(result.company, "ABC Technologies")
        XCTAssertEqual(result.mobiles, ["+1-415-555-0132"])
        XCTAssertEqual(result.officePhones, ["+1-415-555-0199"])
        XCTAssertEqual(result.faxes, ["+1-415-555-0111"])
        XCTAssertEqual(result.emails, ["david.chen@example.com"])
        XCTAssertEqual(result.website, "example.com")
        XCTAssertEqual(result.address, "123 Market Street, San Francisco")
        XCTAssertFalse(result.diagnostics.isEmpty)
    }

    func testT09MissingWebsiteIsNotFabricated() {
        let result = parse([
            "David Chen",
            "ABC Technologies",
            "Mobile: +1-415-555-0132"
        ])

        XCTAssertNil(result.website)
        XCTAssertTrue(result.emails.isEmpty)
        XCTAssertEqual(result.company, "ABC Technologies")
    }

    func testT10MultiplePhonesAreClassified() {
        let result = parse([
            "Mobile: +86 138 0000 0000",
            "Mobile: +86 139 0000 0000",
            "Office: 021-8888-0000",
            "Fax: 021-8888-0001"
        ])

        XCTAssertEqual(result.mobiles.count, 2)
        XCTAssertEqual(result.officePhones, ["021-8888-0000"])
        XCTAssertEqual(result.faxes, ["021-8888-0001"])
    }

    func testChineseCardFields() {
        let result = parse([
            "朱宏明",
            "教授",
            "同济大学",
            "手机：13800000000",
            "邮箱：zhu@example.edu"
        ])

        XCTAssertEqual(result.name, "朱宏明")
        XCTAssertEqual(result.jobTitle, "教授")
        XCTAssertEqual(result.company, "同济大学")
        XCTAssertEqual(result.mobiles, ["13800000000"])
        XCTAssertEqual(result.emails, ["zhu@example.edu"])
    }

    func testMixedSingleLineIsSplitIntoTokens() {
        let result = parse(["朱宏明 Professor Tongji University"])

        XCTAssertEqual(result.name, "朱宏明")
        XCTAssertEqual(result.jobTitle, "Professor")
        XCTAssertEqual(result.company, "Tongji University")
    }

    func testPersonNameVersusCompanyName() {
        let result = parse(["Jordan Lee", "Lee Consulting"])

        XCTAssertEqual(result.name, "Jordan Lee")
        XCTAssertEqual(result.company, "Lee Consulting")
    }

    func testAmbiguousSingleWordStaysUnresolved() {
        let result = parse(["Apple"])

        XCTAssertNil(result.name)
        XCTAssertNil(result.company)
        XCTAssertEqual(result.unresolvedLines, ["Apple"])
        XCTAssertTrue(result.diagnostics.contains { $0.reason == .unresolved })
    }

    func testEmailLineDoesNotProduceWebsite() {
        let result = parse(["david.chen@example.com"])

        XCTAssertEqual(result.emails, ["david.chen@example.com"])
        XCTAssertNil(result.website)
    }

    func testDuplicatePhoneIsDeduplicated() {
        let result = parse([
            "Mobile: +86 13800000000",
            "Mobile: 138-0000-0000"
        ])

        XCTAssertEqual(result.mobiles.count, 1)
    }

    func testMultiLineAddressIsAppended() {
        let result = parse([
            "Address: 123 Market Street",
            "Suite 500"
        ])

        XCTAssertEqual(result.address, "123 Market Street\nSuite 500")
    }

    func testInvalidLabeledEmailIsRejected() {
        let result = parse(["Email: david@@abc"])

        XCTAssertTrue(result.emails.isEmpty)
        XCTAssertNil(result.website)
    }

    func testObservationOrderIsRespected() {
        var observations: [OCRObservation] = []
        observations.append(OCRObservation(text: "ABC Technologies", lineIndex: 2))
        observations.append(OCRObservation(text: "David Chen", lineIndex: 0))
        observations.append(OCRObservation(text: "Technical Director", lineIndex: 1))

        let result = parser.parse(observations: observations)

        XCTAssertEqual(result.name, "David Chen")
        XCTAssertEqual(result.jobTitle, "Technical Director")
        XCTAssertEqual(result.company, "ABC Technologies")
    }

    func testParsedCardAppliesOnlyNonEmptyValues() {
        var card = BusinessCard(originalImagePath: "cards/original.jpg", name: "Existing")
        var parsed = ParsedCard()
        parsed.name = "David Chen"
        parsed.company = "ABC Technologies"

        parsed.apply(to: &card)

        XCTAssertEqual(card.name, "David Chen")
        XCTAssertEqual(card.company, "ABC Technologies")
        XCTAssertNil(card.website)
    }
}
