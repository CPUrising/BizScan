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

        // 搜索结果被 .sheet 覆盖，背景名片夹仍在 AX 树中，断言必须限定到结果列表
        let results = app.collectionViews["BizScan.Search.Results"]
        XCTAssertTrue(results.staticTexts["David Chen"].waitForExistence(timeout: 5))
        XCTAssertFalse(results.staticTexts["Alice Wu"].exists)
    }

    func testT15SearchByCompany() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Search"].tap()

        let field = app.searchFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText("Northwind")

        let results = app.collectionViews["BizScan.Search.Results"]
        XCTAssertTrue(results.staticTexts["Alice Wu"].waitForExistence(timeout: 5))
        XCTAssertFalse(results.staticTexts["David Chen"].exists)
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
