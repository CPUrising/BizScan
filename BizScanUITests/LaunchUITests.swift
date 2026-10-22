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
        XCTAssertTrue(
            app.otherElements["BizScan.Home.EmptyState"].waitForExistence(timeout: 10),
            "首次启动且无数据时应展示空状态"
        )
    }
}
