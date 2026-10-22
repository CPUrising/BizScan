import XCTest

final class CardListUITests: XCTestCase {
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

    func testSeededCardsAppearInList() {
        let app = launchSeeded()

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["朱宏明"].exists)
        XCTAssertTrue(app.staticTexts["Alice Wu"].exists)
    }

    func testT13OpenDetailShowsSavedFields() {
        let app = launchSeeded()

        app.staticTexts["David Chen"].tap()

        XCTAssertTrue(app.navigationBars["名片详情"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["ABC Technologies"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Technical Director"].exists)
        XCTAssertTrue(app.staticTexts["david.chen@example.com"].exists)
    }

    func testT17DeleteCardRemovesItFromList() {
        let app = launchSeeded()

        let target = app.staticTexts["Alice Wu"]
        XCTAssertTrue(target.waitForExistence(timeout: 10))
        target.swipeLeft()

        let deleteButton = app.buttons["删除"].firstMatch
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()

        let confirmButton = app.buttons["删除"].firstMatch
        if confirmButton.waitForExistence(timeout: 3) {
            confirmButton.tap()
        }

        XCTAssertFalse(app.staticTexts["Alice Wu"].waitForExistence(timeout: 3))
    }
}
