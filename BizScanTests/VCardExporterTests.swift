import XCTest
import BizScanCore
@testable import BizScan

/// T19 的 L2 证据：`VCardFileExporter` 的落盘链路。
/// 字段格式本身由 `Packages/BizScanCore/Tests/BizScanCoreTests/VCardBuilderTests.testT19FieldMapping` 保证。
final class VCardExporterTests: XCTestCase {
    private let exporter = VCardFileExporter()

    private func makeFullCard() -> BusinessCard {
        BusinessCard(
            originalImagePath: "CardImages/original.jpg",
            processedImagePath: "CardImages/processed.jpg",
            name: "David Chen",
            company: "ABC Technologies",
            jobTitle: "Technical Director",
            department: "Engineering",
            mobiles: ["+86 138 0000 0000"],
            officePhones: ["021-8888-0000"],
            faxes: ["021-8888-0001"],
            emails: ["david.chen@example.com"],
            website: "example.com",
            address: "123 Market Street, San Francisco",
            postalCode: "200000",
            notes: "Follow up next week"
        )
    }

    func testExportSingleCardWritesReadableVCard() throws {
        let url = try exporter.export([makeFullCard()])
        defer { try? FileManager.default.removeItem(at: url) }

        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        let content = try String(contentsOf: url, encoding: .utf8)

        XCTAssertTrue(content.hasPrefix("BEGIN:VCARD\r\n"))
        XCTAssertTrue(content.contains("FN:David Chen"))
        XCTAssertTrue(content.contains("ORG:ABC Technologies"))
        XCTAssertTrue(content.contains("TITLE:Technical Director"))
        XCTAssertTrue(content.contains("TEL;TYPE=CELL:+86 138 0000 0000"))
        XCTAssertTrue(content.contains("TEL;TYPE=WORK:021-8888-0000"))
        XCTAssertTrue(content.contains("TEL;TYPE=FAX:021-8888-0001"))
        XCTAssertTrue(content.contains("EMAIL;TYPE=INTERNET:david.chen@example.com"))
        XCTAssertTrue(content.contains("URL:example.com"))
        XCTAssertTrue(content.contains("ADR;TYPE=WORK:;;"))
        XCTAssertTrue(content.hasSuffix("END:VCARD\r\n"))
    }

    func testExportEmptyArrayThrowsNoCards() {
        XCTAssertThrowsError(try exporter.export([])) { error in
            guard case ExportError.noCards = error else {
                return XCTFail("期望 ExportError.noCards，实际为 \(error)")
            }
        }
    }

    func testExportMultipleCardsEmitsTwoVCards() throws {
        let cards = [
            BusinessCard(originalImagePath: "a.jpg", name: "Alice"),
            BusinessCard(originalImagePath: "b.jpg", name: "Bob")
        ]
        let url = try exporter.export(cards)
        defer { try? FileManager.default.removeItem(at: url) }

        let content = try String(contentsOf: url, encoding: .utf8)
        let beginCount = content.components(separatedBy: "BEGIN:VCARD").count - 1
        XCTAssertEqual(beginCount, 2)
    }

    func testExportOmitsMissingWebsite() throws {
        let card = BusinessCard(originalImagePath: "a.jpg", name: "Alice")
        let url = try exporter.export([card])
        defer { try? FileManager.default.removeItem(at: url) }

        let content = try String(contentsOf: url, encoding: .utf8)
        XCTAssertFalse(content.contains("\nURL:"))
    }

    func testExportedFileIsInTemporaryDirectory() throws {
        let url = try exporter.export([makeFullCard()])
        defer { try? FileManager.default.removeItem(at: url) }

        XCTAssertEqual(url.pathExtension, "vcf")
        XCTAssertEqual(
            url.deletingLastPathComponent().resolvingSymlinksInPath(),
            FileManager.default.temporaryDirectory.resolvingSymlinksInPath()
        )
    }
}
