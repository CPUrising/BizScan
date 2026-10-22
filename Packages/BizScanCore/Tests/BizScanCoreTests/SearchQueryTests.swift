import XCTest
@testable import BizScanCore

final class SearchQueryTests: XCTestCase {
    private func makeCards() -> [BusinessCard] {
        [
            BusinessCard(
                originalImagePath: "a.jpg",
                name: "David Chen",
                company: "ABC Technologies",
                jobTitle: "Technical Director",
                mobiles: ["+86 138 0000 0000"],
                emails: ["david.chen@example.com"]
            ),
            BusinessCard(
                originalImagePath: "b.jpg",
                name: "朱宏明",
                company: "同济大学",
                officePhones: ["021-8888-0000"]
            )
        ]
    }

    func testT15SearchByNameIgnoringCase() {
        let results = SearchQuery("david").filter(makeCards())
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "David Chen")
    }

    func testSearchByCompanySubstring() {
        let results = SearchQuery("ABC").filter(makeCards())
        XCTAssertEqual(results.first?.name, "David Chen")
    }

    func testSearchByPhoneDigitsIgnoresFormatting() {
        let results = SearchQuery("1380000").filter(makeCards())
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "David Chen")
    }

    func testSearchByEmail() {
        let results = SearchQuery("example.com").filter(makeCards())
        XCTAssertFalse(results.isEmpty)
    }

    func testSearchByChineseName() {
        let results = SearchQuery("朱宏明").filter(makeCards())
        XCTAssertEqual(results.count, 1)
    }

    func testNoResultReturnsEmpty() {
        XCTAssertTrue(SearchQuery("zzz-not-exist").filter(makeCards()).isEmpty)
    }

    func testEmptyKeywordReturnsAllCards() {
        let cards = makeCards()
        XCTAssertEqual(SearchQuery("   ").filter(cards).count, cards.count)
        XCTAssertTrue(SearchQuery("").matchedFields(in: cards[0]).isEmpty)
    }

    func testMatchedFieldsReportsAllHits() {
        let card = makeCards()[0]
        let fields = SearchQuery("chen").matchedFields(in: card)
        XCTAssertTrue(fields.contains(.name))
        XCTAssertTrue(fields.contains(.emails))
    }
}
