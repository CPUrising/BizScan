import XCTest

final class SearchTagsUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launchSeeded() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-testing-seed"]
        app.launch()
        XCTAssertTrue(app.navigationBars["名片夹"].waitForExistence(timeout: 15))
        return app
    }

    func testT15SearchByName() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Search"].tap()

        let field = app.searchFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText("David")

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Alice Wu"].exists)
    }

    func testT15SearchByCompany() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Search"].tap()

        let field = app.searchFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText("Northwind")

        XCTAssertTrue(app.staticTexts["Alice Wu"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["David Chen"].exists)
    }

    func testT16TagFilterShowsOnlyTaggedCards() {
        let app = launchSeeded()

        app.buttons["Customer"].tap()

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Alice Wu"].exists)

        app.buttons["全部"].tap()
        XCTAssertTrue(app.staticTexts["Alice Wu"].waitForExistence(timeout: 5))
    }
}
