import XCTest

final class CaptureUITests: XCTestCase {
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

    /// 首次进入扫描页会依次出现系统相机权限弹窗与 App 的「出错了」弹窗；
    /// 两者顺序不稳定，统一轮询处理，直到关闭按钮可点击。
    private func waitForScannerCloseButton(_ app: XCUIApplication, timeout: TimeInterval = 30) -> Bool {
        let close = app.buttons["BizScan.Scanner.Close"]
        let appAlertDone = app.alerts.buttons["完成"]
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let systemAllow = springboard.buttons.matching(
            NSPredicate(format: "label IN %@", ["允许", "Allow", "好", "OK"])
        ).firstMatch

        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if close.exists && close.isHittable { return true }
            if systemAllow.exists {
                systemAllow.tap()
                continue
            }
            if appAlertDone.exists {
                appAlertDone.tap()
                continue
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
        return close.exists && close.isHittable
    }

    func testT02OpenScannerAndReturn() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Scan"].tap()
        XCTAssertTrue(waitForScannerCloseButton(app), "进入扫描页后应可关闭")

        app.buttons["BizScan.Scanner.Close"].tap()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 10))
    }

    func testT20ExitWithoutDraft() {
        let app = launchSeeded()

        app.buttons["BizScan.Home.Scan"].tap()
        XCTAssertTrue(waitForScannerCloseButton(app), "进入扫描页后应可关闭")

        app.buttons["BizScan.Scanner.Close"].tap()

        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["David Chen"].exists, true, "退出扫描不应影响已有名片")
    }
}
