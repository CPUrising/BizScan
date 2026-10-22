import XCTest
@testable import BizScanCore

final class NoFabricationTests: XCTestCase {
    private let parser = FieldParser()

    func testCompanyNameDoesNotBecomeWebsite() {
        let result = parser.parse(lines: ["ABC Technologies", "Shanghai, China"])
        XCTAssertNil(result.website)
    }

    func testEmailDomainDoesNotBecomeWebsite() {
        let result = parser.parse(lines: ["Email: david@abc-technologies.com"])

        XCTAssertNil(result.website)
        XCTAssertEqual(result.emails, ["david@abc-technologies.com"])
    }

    func testUnresolvedContentIsPreserved() {
        let result = parser.parse(lines: ["Apple", "Think different"])

        XCTAssertEqual(result.unresolvedLines, ["Apple", "Think different"])
        XCTAssertNil(result.name)
        XCTAssertNil(result.company)
    }

    func testNoEmptyStringIsWrittenIntoFields() {
        let result = parser.parse(lines: [" ", "David Chen", "Email: "])

        let optionalFields = [
            result.name,
            result.company,
            result.jobTitle,
            result.website,
            result.address,
            result.postalCode
        ]
        for value in optionalFields {
            if let value {
                XCTAssertFalse(value.isEmpty)
            }
        }
        XCTAssertTrue(result.emails.allSatisfy { !$0.isEmpty })
    }

    func testWebsiteComesOnlyFromExplicitDomain() {
        let result = parser.parse(lines: ["www.example.com"])
        XCTAssertEqual(result.website, "example.com")
    }

    func testWebsiteLineWithEmailIsNotDoubleCounted() {
        let result = parser.parse(lines: ["Contact: david@example.com"])

        XCTAssertEqual(result.emails, ["david@example.com"])
        XCTAssertNil(result.website)
    }

    func testParsedFieldsNeverContainPlaceholders() {
        let result = parser.parse(lines: ["Mobile: ", "Website: ", "Address: "])

        XCTAssertTrue(result.mobiles.isEmpty)
        XCTAssertNil(result.website)
        XCTAssertNil(result.address)
    }
}
