import XCTest
import UIKit
import BizScanCore
@testable import BizScan

/// OCR/字段准确率基线：15 例合成名片跑真实 Vision 全链路。
/// 只设两条硬门槛（虚构字段 = 0、数据集可用性），不设准确率阈值。
final class OCREvaluationTests: XCTestCase {
    private struct FieldStat {
        var correct = 0
        var wrong = 0
        var missing = 0
        var fabricated = 0
    }

    private var repoRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    func testNormalizationRulesMatchFixtureSpec() {
        XCTAssertEqual(EvalNormalizer.phone("１３８ ００００-００００"), "13800000000")
        XCTAssertEqual(EvalNormalizer.email("  David.Chen@Example.COM "), "david.chen@example.com")
        XCTAssertEqual(EvalNormalizer.website("HTTPS://www.Example.com/"), "example.com")
        XCTAssertEqual(EvalNormalizer.text("  Ｄａｖｉｄ   Ｃｈｅｎ "), "david chen")
    }

    func testEvaluateSyntheticCardSet() throws {
        let pipeline = ScanPipeline(
            detector: VisionCardDetector(),
            corrector: CoreImageCorrector(),
            ocr: VisionOCRService()
        )

        var stats: [String: FieldStat] = [:]
        for field in OCREvaluationDataset.fieldNames {
            stats[field] = FieldStat()
        }

        var details: [[String: Any]] = []
        var fabricatedTotal = 0
        var nonEmptyOCR = 0
        var processed = 0

        for testCase in OCREvaluationDataset.cases() {
            let result = try? pipeline.run(originalImage: testCase.image)
            let parsed = result?.parsed ?? ParsedCard()
            let rawLines = result?.observations.readableLines() ?? []
            processed += 1
            if !rawLines.joined().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                nonEmptyOCR += 1
            }

            for field in OCREvaluationDataset.fieldNames {
                let truthValues = Set(
                    (testCase.groundTruth[field] ?? [])
                        .map { EvalNormalizer.normalize(field: field, value: $0) }
                        .filter { !$0.isEmpty }
                )
                let outputValues = Set(
                    values(of: field, in: parsed)
                        .map { EvalNormalizer.normalize(field: field, value: $0) }
                        .filter { !$0.isEmpty }
                )

                var stat = stats[field] ?? FieldStat()
                if truthValues.isEmpty {
                    stat.fabricated += outputValues.count
                    fabricatedTotal += outputValues.count
                } else {
                    stat.correct += truthValues.intersection(outputValues).count
                    stat.wrong += outputValues.subtracting(truthValues).count
                    stat.missing += truthValues.subtracting(outputValues).count
                }
                stats[field] = stat
            }

            details.append([
                "id": testCase.id,
                "tags": testCase.tags,
                "rawLines": rawLines,
                "parsed": dictionary(from: parsed),
                "groundTruth": testCase.groundTruth
            ])
        }

        let summary = makeSummary(stats: stats, cases: processed, fabricated: fabricatedTotal, nonEmptyOCR: nonEmptyOCR)
        let data = try JSONSerialization.data(withJSONObject: summary, options: [.sortedKeys, .prettyPrinted])
        let json = String(decoding: data, as: UTF8.self)
        print("EVAL_SUMMARY: \(json)")

        let attachment = XCTAttachment(string: json)
        attachment.name = "EVAL_SUMMARY"
        attachment.lifetime = .keepAlways
        add(attachment)

        writeRawDetails(details)

        XCTAssertEqual(processed, OCREvaluationDataset.cases().count, "所有案例都应被处理")
        XCTAssertEqual(fabricatedTotal, 0, "不得虚构 Ground Truth 中不存在的字段")
        XCTAssertGreaterThanOrEqual(
            nonEmptyOCR,
            Int(Double(processed) * 0.8),
            "OCR 原始文本非空的案例不足，数据集或链路不可用"
        )
    }

    // MARK: - 辅助

    private func values(of field: String, in parsed: ParsedCard) -> [String] {
        switch field {
        case "name": return [parsed.name].compactMap { $0 }
        case "company": return [parsed.company].compactMap { $0 }
        case "jobTitle": return [parsed.jobTitle].compactMap { $0 }
        case "department": return [parsed.department].compactMap { $0 }
        case "mobiles": return parsed.mobiles
        case "officePhones": return parsed.officePhones
        case "faxes": return parsed.faxes
        case "emails": return parsed.emails
        case "website": return [parsed.website].compactMap { $0 }
        case "address": return [parsed.address].compactMap { $0 }
        case "postalCode": return [parsed.postalCode].compactMap { $0 }
        default: return []
        }
    }

    private func dictionary(from parsed: ParsedCard) -> [String: Any] {
        [
            "name": parsed.name ?? "",
            "company": parsed.company ?? "",
            "jobTitle": parsed.jobTitle ?? "",
            "department": parsed.department ?? "",
            "mobiles": parsed.mobiles,
            "officePhones": parsed.officePhones,
            "faxes": parsed.faxes,
            "emails": parsed.emails,
            "website": parsed.website ?? "",
            "address": parsed.address ?? "",
            "postalCode": parsed.postalCode ?? "",
            "unresolvedLines": parsed.unresolvedLines
        ]
    }

    private func makeSummary(
        stats: [String: FieldStat],
        cases: Int,
        fabricated: Int,
        nonEmptyOCR: Int
    ) -> [String: Any] {
        var fields: [String: Any] = [:]
        for (field, stat) in stats {
            let precisionDenominator = stat.correct + stat.wrong + stat.fabricated
            let recallDenominator = stat.correct + stat.missing
            fields[field] = [
                "correct": stat.correct,
                "wrong": stat.wrong,
                "missing": stat.missing,
                "fabricated": stat.fabricated,
                "precision": precisionDenominator == 0 ? 0 : Double(stat.correct) / Double(precisionDenominator),
                "recall": recallDenominator == 0 ? 0 : Double(stat.correct) / Double(recallDenominator)
            ]
        }
        return [
            "datasetVersion": OCREvaluationDataset.version,
            "source": "synthetic",
            "cases": cases,
            "casesWithOCRTex": nonEmptyOCR,
            "fabricatedTotal": fabricated,
            "fields": fields
        ]
    }

    private func writeRawDetails(_ details: [[String: Any]]) {
        let directory = repoRoot.appendingPathComponent("docs/eval/raw", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            for detail in details {
                guard let id = detail["id"] as? String else { continue }
                let data = try JSONSerialization.data(withJSONObject: detail, options: [.sortedKeys, .prettyPrinted])
                try data.write(to: directory.appendingPathComponent("\(id).json"))
            }
        } catch {
            // 仓库目录不可写时不判失败，明细改存到 xcresult 附件。
            let attachment = XCTAttachment(string: String(describing: details))
            attachment.name = "eval-raw-details-fallback"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
