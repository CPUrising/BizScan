import XCTest

/// T18：真实落盘 store 下，App 终止后重启数据仍在。
/// 与其他 UI 测试的内存容器隔离，使用专用 `BizScanUITests.store`。
final class PersistenceUITests: XCTestCase {
    func testT18DataSurvivesRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = [
            "-ui-testing",
            "-ui-testing-persistent",
            "-ui-testing-reset",
            "-ui-testing-seed"
        ]
        app.launch()

        XCTAssertTrue(app.navigationBars["名片夹"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Alice Wu"].exists)

        app.terminate()

        app.launchArguments = ["-ui-testing", "-ui-testing-persistent"]
        app.launch()

        XCTAssertTrue(app.navigationBars["名片夹"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts["David Chen"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Alice Wu"].exists)
    }
}
