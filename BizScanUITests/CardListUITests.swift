import XCTest

final class CardListUITests: XCTestCase {
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

    func testSeededCardsAppearInList() {
        let app = launchSeeded()

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["朱宏明"].exists)
        XCTAssertTrue(app.staticTexts["Alice Wu"].exists)
    }

    func testT13OpenDetailShowsSavedFields() {
        let app = launchSeeded()

        app.staticTexts["David Chen"].tap()

        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["ABC Technologies"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Technical Director"].exists)
        XCTAssertTrue(
            app.descendants(matching: .any)
                .matching(identifier: "BizScan.Detail.Contact.email-0")
                .firstMatch
                .exists
        )
    }

    func testT17DeleteCardRemovesItFromList() {
        let app = launchSeeded()

        let target = app.staticTexts["Alice Wu"]
        XCTAssertTrue(target.waitForExistence(timeout: 10))

        let menu = app.buttons["BizScan.CardRow.Menu.Alice Wu"]
        XCTAssertTrue(menu.waitForExistence(timeout: 5))
        menu.tap()

        let deleteButton = app.buttons["删除"].firstMatch
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()

        let confirmButton = app.buttons["删除"].firstMatch
        if confirmButton.waitForExistence(timeout: 3) {
            confirmButton.tap()
        }

        XCTAssertFalse(app.staticTexts["Alice Wu"].waitForExistence(timeout: 3))
    }

    func testT21CreateGroupAndFilter() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.GroupManage"].tap()
        XCTAssertTrue(app.navigationBars["分组管理"].waitForExistence(timeout: 10))

        app.buttons["BizScan.Groups.Add"].tap()

        let alert = app.alerts["新建分组"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        let nameField = alert.textFields.firstMatch
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("新分组")
        alert.buttons["确认"].tap()

        XCTAssertTrue(app.staticTexts["新分组"].waitForExistence(timeout: 5))
        app.buttons["BizScan.Groups.Done"].tap()

        XCTAssertTrue(app.staticTexts["新分组"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["David Chen"].exists)

        app.buttons["BizScan.Home.GroupMenu"].tap()
        let allOption = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH %@", "全部名片")
        ).firstMatch
        XCTAssertTrue(allOption.waitForExistence(timeout: 5))
        allOption.tap()

        let david = app.staticTexts["David Chen"]
        XCTAssertTrue(david.waitForExistence(timeout: 5))

        let rowMenu = app.buttons["BizScan.CardRow.Menu.David Chen"]
        XCTAssertTrue(rowMenu.waitForExistence(timeout: 5))
        rowMenu.tap()
        app.buttons["移动到分组"].tap()
        app.buttons["新分组"].tap()

        app.buttons["BizScan.Home.GroupMenu"].tap()
        let newGroupOption = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH %@", "新分组")
        ).firstMatch
        XCTAssertTrue(newGroupOption.waitForExistence(timeout: 5))
        newGroupOption.tap()

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Alice Wu"].exists)
    }

    func testT22DeleteGroupMovesCardToUngrouped() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.GroupManage"].tap()
        XCTAssertTrue(app.navigationBars["分组管理"].waitForExistence(timeout: 10))

        let row = app.buttons["BizScan.Groups.Row.客户"]
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        row.swipeLeft()

        let deleteGroup = app.buttons["删除分组"].firstMatch
        XCTAssertTrue(deleteGroup.waitForExistence(timeout: 5))
        deleteGroup.tap()

        let confirm = app.buttons["删除"].firstMatch
        XCTAssertTrue(confirm.waitForExistence(timeout: 5))
        confirm.tap()

        app.buttons["BizScan.Groups.Done"].tap()

        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 5))
        app.staticTexts["David Chen"].tap()

        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["未分组"].waitForExistence(timeout: 5))
    }

    func testT34CreateCardManually() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Add"].tap()
        XCTAssertTrue(app.navigationBars["新建名片"].waitForExistence(timeout: 10))

        let nameField = app.textFields["BizScan.New.Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Manual Contact")

        app.buttons["BizScan.New.Save"].tap()

        XCTAssertTrue(app.staticTexts["Manual Contact"].waitForExistence(timeout: 10))

        app.staticTexts["Manual Contact"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Manual Contact"].waitForExistence(timeout: 5))
    }

    func testT35EmptyManualCardRequiresConfirmation() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Add"].tap()
        XCTAssertTrue(app.navigationBars["新建名片"].waitForExistence(timeout: 10))

        app.buttons["BizScan.New.Save"].tap()

        let dialog = app.sheets.firstMatch
        XCTAssertTrue(dialog.waitForExistence(timeout: 5))
        dialog.buttons["保存"].tap()

        XCTAssertTrue(app.staticTexts["未命名名片"].waitForExistence(timeout: 10))
    }

    func testT24HomeGroupsByCreatedDate() {
        let app = launchSeeded()

        let newer = app.staticTexts["2026-10-27"]
        let older = app.staticTexts["2026-10-26"]
        XCTAssertTrue(newer.waitForExistence(timeout: 10))
        XCTAssertTrue(older.exists)
        XCTAssertLessThan(newer.frame.minY, older.frame.minY)
    }

    func testT25HomeKeepsPersistentEntries() {
        let app = launchSeeded()

        XCTAssertTrue(app.staticTexts["名片"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["BizScan.Home.Search"].exists)
        XCTAssertTrue(app.buttons["BizScan.Home.GroupManage"].exists)
        XCTAssertTrue(app.buttons["BizScan.Home.Scan"].exists)
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].exists)
    }
}
