import XCTest
import UIKit
import BizScanCore
@testable import BizScan

/// `real-001`：15 张真实名片的 OCR/字段准确率。
/// 图片与 Ground Truth 只在本机 `card_test/`；CI 无该目录时整组跳过。
/// 口径与 `OCREvaluationTests` 一致，只统计、不设准确率阈值。
final class RealCardEvaluationTests: XCTestCase {
    private struct FieldStat {
        var correct = 0
        var wrong = 0
        var missing = 0
        var fabricated = 0
    }

    func testDatasetIndexIsWellFormed() throws {
        try requireLocalDataset()

        let cases = try RealCardEvaluationDataset.load()
        XCTAssertEqual(cases.count, 14, "真实名片集应为 14 例（c009 已由项目所有者删除）")

        let ids = cases.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "case id 不得重复")
        for id in ids {
            XCTAssertNotNil(
                id.range(of: "^c[0-9]{3}$", options: .regularExpression),
                "case id 必须符合 c001 格式：\(id)"
            )
        }
    }

    func testEvaluateRealCardSet() throws {
        try requireLocalDataset()

        let cases = try RealCardEvaluationDataset.load()
        let pipeline = ScanPipeline(
            detector: VisionCardDetector(),
            corrector: CoreImageCorrector(),
            ocr: VisionOCRService()
        )

        var stats: [String: FieldStat] = [:]
        for field in RealCardEvaluationDataset.fieldNames {
            stats[field] = FieldStat()
        }

        var details: [[String: Any]] = []
        var fabricatedTotal = 0
        var nonEmptyOCR = 0
        var detectionSucceeded = 0
        var processed = 0

        for testCase in cases {
            let result = try? pipeline.run(originalImage: testCase.image)
            let parsed = result?.parsed ?? ParsedCard()
            let rawLines = result?.observations.readableLines() ?? []
            let detected = result?.quad != nil
            processed += 1
            if detected { detectionSucceeded += 1 }
            if !rawLines.joined().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                nonEmptyOCR += 1
            }

            for field in RealCardEvaluationDataset.fieldNames {
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
                "detected": detected,
                "rawLines": rawLines,
                "parsed": dictionary(from: parsed),
                "groundTruth": testCase.groundTruth
            ])
        }

        let summary = makeSummary(
            stats: stats,
            cases: processed,
            fabricated: fabricatedTotal,
            nonEmptyOCR: nonEmptyOCR,
            detectionSucceeded: detectionSucceeded
        )
        let data = try JSONSerialization.data(withJSONObject: summary, options: [.sortedKeys, .prettyPrinted])
        let json = String(decoding: data, as: UTF8.self)
        print("EVAL_SUMMARY: \(json)")

        let attachment = XCTAttachment(string: json)
        attachment.name = "EVAL_SUMMARY_REAL"
        attachment.lifetime = .keepAlways
        add(attachment)

        writeRawDetails(details)

        XCTAssertEqual(processed, cases.count, "所有案例都应被处理")
        XCTAssertEqual(fabricatedTotal, 0, "不得虚构 Ground Truth 中不存在的字段")
        XCTAssertGreaterThan(nonEmptyOCR, 0, "全部案例 OCR 为空，链路或数据不可用")
    }

    // MARK: - 辅助

    private func requireLocalDataset() throws {
        try XCTSkipIf(
            RealCardEvaluationDataset.cardTestRoot == nil,
            "card_test/ 仅本机存在（已 .gitignore），CI 跳过真实名片评估"
        )
    }

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
        nonEmptyOCR: Int,
        detectionSucceeded: Int
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
            "datasetVersion": RealCardEvaluationDataset.version,
            "source": "real-local",
            "cases": cases,
            "casesWithOCRTex": nonEmptyOCR,
            "detectionSucceeded": detectionSucceeded,
            "fabricatedTotal": fabricated,
            "fields": fields
        ]
    }

    private func writeRawDetails(_ details: [[String: Any]]) {
        // 模拟器沙盒写不了仓库目录；写到临时目录，并作为附件留在 xcresult。
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("real-eval-raw", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            for detail in details {
                guard let id = detail["id"] as? String else { continue }
                let data = try JSONSerialization.data(withJSONObject: detail, options: [.sortedKeys, .prettyPrinted])
                try data.write(to: directory.appendingPathComponent("\(id).json"))
            }
            print("REAL_EVAL_RAW_DIR: \(directory.path)")
        } catch {
            let attachment = XCTAttachment(string: String(describing: details))
            attachment.name = "real-eval-raw-details-fallback"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
