import XCTest

final class DetailUITests: XCTestCase {
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

    func testT14EditNamePersistsInDetail() {
        let app = launchSeeded()

        app.staticTexts["David Chen"].tap()
        XCTAssertTrue(app.navigationBars["名片详情"].waitForExistence(timeout: 10))

        app.buttons["编辑"].tap()

        let nameField = app.textFields["BizScan.Edit.Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText(" Jr")

        app.buttons["保存"].tap()

        XCTAssertTrue(app.staticTexts["David Chen Jr"].waitForExistence(timeout: 10))
    }

    func testT13EmptyFieldsAreNotShown() {
        let app = launchSeeded()

        app.staticTexts["Alice Wu"].tap()
        XCTAssertTrue(app.navigationBars["名片详情"].waitForExistence(timeout: 10))

        XCTAssertFalse(app.staticTexts["手机"].exists)
        XCTAssertFalse(app.staticTexts["网址"].exists)
    }
}
