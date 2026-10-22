import XCTest
@testable import BizScanCore

final class ContactNormalizerTests: XCTestCase {
    func testHalfWidthConvertsFullWidthCharacters() {
        XCTAssertEqual(ContactNormalizer.halfWidth("１２３ＡＢＣ　"), "123ABC ")
        XCTAssertEqual(ContactNormalizer.halfWidth("手机：１３８"), "手机:138")
    }

    func testDigitsKeepsOnlyNumbers() {
        XCTAssertEqual(ContactNormalizer.digits("+86 (138) 0000-0000"), "8613800000000")
        XCTAssertEqual(ContactNormalizer.digits("abc"), "")
    }

    func testPhoneKeyStripsCountryCode() {
        XCTAssertEqual(ContactNormalizer.phoneKey("+86 138 0000 0000"), "13800000000")
        XCTAssertEqual(ContactNormalizer.phoneKey("0086 138 0000 0000"), "13800000000")
        XCTAssertEqual(ContactNormalizer.phoneKey("021-8888-0000"), "02188880000")
    }

    func testNormalizedEmail() {
        XCTAssertEqual(
            ContactNormalizer.normalizedEmail("  David.Chen@ABC.edu "),
            "david.chen@abc.edu"
        )
        XCTAssertNil(ContactNormalizer.normalizedEmail("david@@abc"))
        XCTAssertNil(ContactNormalizer.normalizedEmail("david at abc.edu"))
    }

    func testNormalizedWebsite() {
        XCTAssertEqual(ContactNormalizer.normalizedWebsite("https://www.Example.com/"), "example.com")
        XCTAssertEqual(ContactNormalizer.normalizedWebsite("WWW.EXAMPLE.COM"), "example.com")
        XCTAssertNil(ContactNormalizer.normalizedWebsite("example"))
        XCTAssertNil(ContactNormalizer.normalizedWebsite("david@example.com"))
    }

    func testStripLabelPrefix() {
        XCTAssertEqual(ContactNormalizer.stripLabelPrefix("手机：13800000000"), "13800000000")
        XCTAssertEqual(ContactNormalizer.stripLabelPrefix("Mobile: +86 138 0000 0000"), "+86 138 0000 0000")
        XCTAssertEqual(ContactNormalizer.stripLabelPrefix("plain text"), "plain text")
    }

    func testEqualsIgnoringCaseAndSpaces() {
        XCTAssertTrue(ContactNormalizer.equalsIgnoringCaseAndSpaces("David Chen", "david  chen"))
        XCTAssertFalse(ContactNormalizer.equalsIgnoringCaseAndSpaces("David Chen", "David C."))
    }
}
