import XCTest

/// 临时截图用；生成对照图后删除。
final class SnapshotUITests: XCTestCase {
    func testCaptureDetail() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-testing-seed"]
        app.launch()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 15))
        app.staticTexts["David Chen"].tap()
        XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 10))

        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "detail"
        shot.lifetime = .keepAlways
        add(shot)
    }
}
