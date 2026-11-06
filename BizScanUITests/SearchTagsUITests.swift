import XCTest

final class SearchTagsUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launchSeeded() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-testing-seed"]
        app.launch()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 15))
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

    func testT16TagIsEditableAndHiddenOnHome() {
        let app = launchSeeded()

        XCTAssertFalse(app.staticTexts["Customer"].exists)

        app.staticTexts["David Chen"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
        app.buttons["编辑"].tap()
        XCTAssertTrue(app.navigationBars["编辑"].waitForExistence(timeout: 5))

        for _ in 0..<4 {
            if app.staticTexts["Customer"].exists { break }
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Customer"].waitForExistence(timeout: 5))

        app.buttons["取消"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Customer"].exists)
    }
}
