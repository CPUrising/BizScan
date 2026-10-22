import XCTest
@testable import BizScanCore

final class PhoneClassifierTests: XCTestCase {
    func testChineseMobileWithCountryCode() {
        let result = PhoneClassifier.classify("+86 138 0000 0000")
        XCTAssertEqual(result.kind, .mobile)
    }

    func testChineseLandline() {
        let result = PhoneClassifier.classify("021-8888-0000")
        XCTAssertEqual(result.kind, .office)
    }

    func testEnterpriseServiceNumber() {
        let result = PhoneClassifier.classify("400-800-1234")
        XCTAssertEqual(result.kind, .office)
    }

    func testLabelWinsOverFormat() {
        let result = PhoneClassifier.classify("+1-415-555-0132", label: .mobile)
        XCTAssertEqual(result.kind, .mobile)
        XCTAssertEqual(result.value, "+1-415-555-0132")
    }

    func testFaxLabel() {
        let result = PhoneClassifier.classify("021-8888-0001", label: .fax)
        XCTAssertEqual(result.kind, .fax)
    }

    func testUnclassifiableNumberStaysUnknown() {
        let result = PhoneClassifier.classify("12345")
        XCTAssertEqual(result.kind, .unknown)
        XCTAssertFalse(result.reason.isEmpty)
    }

    func testPhoneLikeRejectsShortAndTextValues() {
        XCTAssertFalse(PhoneClassifier.isPhoneLike("123"))
        XCTAssertFalse(PhoneClassifier.isPhoneLike("abc"))
        XCTAssertFalse(PhoneClassifier.isPhoneLike("138xxxx0000"))
        XCTAssertTrue(PhoneClassifier.isPhoneLike("+86 138 0000 0000"))
        XCTAssertTrue(PhoneClassifier.isPhoneLike("(021) 8888-0000"))
    }

    func testLabelPrefixIsStripped() {
        let result = PhoneClassifier.classify("手机：13800000000")
        XCTAssertEqual(result.value, "13800000000")
        XCTAssertEqual(result.kind, .mobile)
    }
}
