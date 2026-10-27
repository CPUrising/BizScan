import XCTest

final class CaptureUITests: XCTestCase {
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

    /// 模拟器无可用相机时，扫描页会先弹出「出错了」提示，需先关闭才能操作页面按钮
    private func dismissCameraUnavailableAlertIfNeeded(_ app: XCUIApplication) {
        let done = app.alerts.buttons["完成"]
        if done.waitForExistence(timeout: 5) {
            done.tap()
        }
    }

    func testT02OpenScannerAndReturn() {
        let app = launchSeeded()

        addUIInterruptionMonitor(withDescription: "Camera permission") { alert in
            for title in ["允许", "Allow", "好", "OK"] where alert.buttons[title].exists {
                alert.buttons[title].tap()
                return true
            }
            return false
        }

        app.buttons["BizScan.Home.Scan"].tap()
        app.tap()
        dismissCameraUnavailableAlertIfNeeded(app)

        let closeButton = app.buttons["BizScan.Scanner.Close"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 15), "进入扫描页后应可关闭")

        closeButton.tap()
        XCTAssertTrue(app.navigationBars["名片夹"].waitForExistence(timeout: 10))
    }

    func testT20ExitWithoutDraft() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Scan"].tap()
        app.tap()
        dismissCameraUnavailableAlertIfNeeded(app)

        let closeButton = app.buttons["BizScan.Scanner.Close"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 15))
        closeButton.tap()

        XCTAssertTrue(app.navigationBars["名片夹"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["David Chen"].exists, true, "退出扫描不应影响已有名片")
    }
}
