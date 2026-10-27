import XCTest

final class LaunchUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchesToEmptyCardHolder() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        XCTAssertTrue(
            app.navigationBars["名片夹"].waitForExistence(timeout: 15),
            "应用启动后应进入名片夹"
        )
        // 标识符加在容器上会下发给子元素，容器本身不是 AX 元素，故按标识符在整棵树中查找
        let emptyState = app.descendants(matching: .any)
            .matching(identifier: "BizScan.Home.EmptyState")
            .firstMatch
        XCTAssertTrue(
            emptyState.waitForExistence(timeout: 10),
            "首次启动且无数据时应展示空状态"
        )
    }
}
