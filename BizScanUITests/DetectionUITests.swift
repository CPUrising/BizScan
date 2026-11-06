import XCTest

/// T20「校正页重拍 / 旋转」与 T04「拍摄后进入识别」的模拟器替代验证。
/// 模拟器无相机，App 在 `-ui-testing-capture` 下注入一张合成名片，直接进入校正页。
final class DetectionUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launchInjectedCapture() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-testing-seed", "-ui-testing-capture"]
        app.launch()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 15))
        return app
    }

    func testRetakeFromAdjustReturnsToScanner() {
        let app = launchInjectedCapture()

        app.buttons["BizScan.Home.Scan"].tap()
        let adjustBar = app.navigationBars["调整名片边界"]
        XCTAssertTrue(adjustBar.waitForExistence(timeout: 15), "注入图片后应进入校正页")

        adjustBar.buttons["取消"].tap()

        XCTAssertFalse(adjustBar.waitForExistence(timeout: 3), "取消后应关闭校正页")
        XCTAssertTrue(
            app.buttons["BizScan.Scanner.Close"].waitForExistence(timeout: 10),
            "取消后应回到扫描页，可重新拍摄"
        )

        app.buttons["BizScan.Scanner.Close"].tap()
        XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 10))
    }

    func testRotateNoticeThenConfirmEntersReview() {
        let app = launchInjectedCapture()

        app.buttons["BizScan.Home.Scan"].tap()
        XCTAssertTrue(app.navigationBars["调整名片边界"].waitForExistence(timeout: 15))

        app.buttons["BizScan.Crop.Rotate"].tap()
        XCTAssertTrue(
            app.staticTexts["输出将旋转 90°"].waitForExistence(timeout: 5),
            "旋转后应提示输出方向"
        )

        app.buttons["BizScan.Crop.Confirm"].tap()
        XCTAssertTrue(
            app.navigationBars["确认识别结果"].waitForExistence(timeout: 60),
            "确认后应完成校正与识别并进入确认识别结果页"
        )
    }
}
