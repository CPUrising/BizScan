import XCTest
@testable import BizScanCore

final class UnverifiedValueDetectorTests: XCTestCase {
    private func makeParsed(mobiles: [String] = ["13504119bile"]) -> ParsedCard {
        var parsed = ParsedCard()
        parsed.mobiles = mobiles
        parsed.emails = ["david@example.com"]
        return parsed
    }

    func testLowConfidenceObservationIsMarked() {
        let parsed = makeParsed()
        let observations = [
            OCRObservation(text: "13504119bile", confidence: 0.5),
            OCRObservation(text: "david@example.com", confidence: 0.95)
        ]

        let result = UnverifiedValueDetector.detect(parsed: parsed, observations: observations)

        XCTAssertEqual(result, ["13504119bile"])
    }

    func testHighConfidenceObservationIsNotMarked() {
        let parsed = makeParsed()
        let observations = [
            OCRObservation(text: "13504119bile", confidence: 0.71)
        ]

        XCTAssertTrue(UnverifiedValueDetector.detect(parsed: parsed, observations: observations).isEmpty)
    }

    func testThresholdBoundary() {
        let parsed = makeParsed()
        let below = [OCRObservation(text: "13504119bile", confidence: 0.69)]
        let above = [OCRObservation(text: "13504119bile", confidence: 0.7)]

        XCTAssertEqual(UnverifiedValueDetector.detect(parsed: parsed, observations: below).count, 1)
        XCTAssertTrue(UnverifiedValueDetector.detect(parsed: parsed, observations: above).isEmpty)
    }

    func testAmbiguousDiagnosticIsMarked() {
        var parsed = makeParsed(mobiles: [])
        parsed.officePhones = ["400-800-1234"]
        parsed.diagnostics = [
            ParsingDiagnostic(
                line: "400-800-1234",
                field: nil,
                reason: .ambiguous,
                rule: "phone:unknown",
                confidence: 0.92
            )
        ]

        let result = UnverifiedValueDetector.detect(parsed: parsed, observations: [])

        XCTAssertEqual(result, ["400-800-1234"])
    }

    func testDiagnosticForOtherFieldDoesNotMark() {
        var parsed = makeParsed(mobiles: ["13504119bile"])
        parsed.diagnostics = [
            ParsingDiagnostic(
                line: "13504119bile",
                field: .email,
                reason: .ambiguous,
                rule: "email",
                confidence: 0.9
            )
        ]

        XCTAssertTrue(UnverifiedValueDetector.detect(parsed: parsed, observations: []).isEmpty)
    }

    func testValuesAreDeduplicatedAndOrdered() {
        var parsed = ParsedCard()
        parsed.mobiles = ["111", "222"]
        parsed.emails = ["111"]
        let observations = [
            OCRObservation(text: "111", confidence: 0.2),
            OCRObservation(text: "222", confidence: 0.3)
        ]

        let result = UnverifiedValueDetector.detect(parsed: parsed, observations: observations)

        XCTAssertEqual(result, ["111", "222"])
    }

    func testNameAndCompanyAreNeverMarked() {
        var parsed = ParsedCard()
        parsed.name = "David Chen"
        parsed.company = "ABC"
        let observations = [OCRObservation(text: "David Chen", confidence: 0.1)]

        XCTAssertTrue(UnverifiedValueDetector.detect(parsed: parsed, observations: observations).isEmpty)
    }
}
