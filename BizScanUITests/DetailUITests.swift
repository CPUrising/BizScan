import XCTest

final class DetailUITests: XCTestCase {
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

    private func openDavid(_ app: XCUIApplication) {
        app.staticTexts["David Chen"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
    }

    func testT14EditNamePersistsInDetail() {
        let app = launchSeeded()
        openDavid(app)

        app.buttons["BizScan.Detail.Quick.Edit"].tap()

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
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))

        XCTAssertFalse(app.staticTexts["手机"].exists)
        XCTAssertFalse(app.staticTexts["网址"].exists)
    }

    func testT23DetailShowsGroup() {
        let app = launchSeeded()
        openDavid(app)

        XCTAssertTrue(app.staticTexts["客户"].waitForExistence(timeout: 5))
    }

    func testT26ProfileAndQuickActions() {
        let app = launchSeeded()
        openDavid(app)

        XCTAssertTrue(app.staticTexts["D"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["David Chen"].exists)
        XCTAssertTrue(app.staticTexts["Technical Director"].exists)
        XCTAssertTrue(app.staticTexts["ABC Technologies"].exists)

        XCTAssertTrue(app.buttons["BizScan.Detail.Quick.Phone"].exists)
        XCTAssertTrue(app.buttons["BizScan.Detail.Quick.Address"].exists)
        XCTAssertTrue(app.buttons["BizScan.Detail.Quick.Notes"].exists)
        XCTAssertTrue(app.buttons["BizScan.Detail.Quick.Edit"].exists)
        let saveToContacts = app.buttons["BizScan.Detail.SaveToContacts"]
        XCTAssertTrue(saveToContacts.exists)
        XCTAssertTrue(saveToContacts.isEnabled)
    }

    func testT26AddressActionDisabledWithoutAddress() {
        let app = launchSeeded()

        app.staticTexts["Alice Wu"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))

        XCTAssertFalse(app.buttons["BizScan.Detail.Quick.Phone"].isEnabled)
        XCTAssertFalse(app.buttons["BizScan.Detail.Quick.Address"].isEnabled)
        XCTAssertFalse(app.buttons["BizScan.Detail.Original"].exists)
    }

    func testT27FavoritePersists() {
        let app = launchSeeded()
        openDavid(app)

        let favorite = app.buttons["BizScan.Detail.Favorite"]
        XCTAssertTrue(favorite.waitForExistence(timeout: 5))
        XCTAssertEqual(favorite.value as? String, "未收藏")

        favorite.tap()
        XCTAssertEqual(favorite.value as? String, "已收藏")

        app.buttons["BizScan.Detail.Back"].tap()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 10))

        app.staticTexts["David Chen"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.buttons["BizScan.Detail.Favorite"].value as? String, "已收藏")
    }

    func testT29ReviewBadgeIsShown() {
        let app = launchSeeded()
        openDavid(app)

        XCTAssertTrue(app.staticTexts["待核对"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["原始识别内容，可在编辑中修正"].exists)
    }

    func testT28ViewOriginalImage() {
        let app = launchSeeded()
        openDavid(app)

        let original = app.buttons["BizScan.Detail.Original"]
        XCTAssertTrue(original.waitForExistence(timeout: 5))
        original.tap()

        let close = app.buttons["BizScan.ImageViewer.Close"]
        XCTAssertTrue(close.waitForExistence(timeout: 5))

        close.tap()

        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 5))
    }
}
