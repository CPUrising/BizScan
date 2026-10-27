import UIKit

/// `real-001`：本机 `card_test/` 的 15 张真实名片。
/// 图片与 Ground Truth 都不入库；仓库里只保留 `docs/eval/real-cards/index.json` 的路径索引。
enum RealCardEvaluationDataset {
    static let version = "real-001"
    static let fieldNames = OCREvaluationDataset.fieldNames

    static var repoRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    /// 测试跑在模拟器沙盒里，读不到仓库路径。
    /// `project.yml` 把 `card_test/` 与 `docs/eval/real-cards/` 作为可选资源打进测试 bundle；
    /// 本机直接跑（非模拟器）时回退到仓库路径。
    static var cardTestRoot: URL? {
        let bundle = Bundle(for: RealCardBundleToken.self)
        if let bundled = bundle.url(forResource: "card_test", withExtension: nil) {
            return bundled
        }
        let direct = bundle.bundleURL.appendingPathComponent("card_test", isDirectory: true)
        if FileManager.default.fileExists(atPath: direct.path) {
            return direct
        }
        let host = repoRoot.appendingPathComponent("card_test", isDirectory: true)
        return FileManager.default.fileExists(atPath: host.path) ? host : nil
    }

    static var indexURL: URL? {
        let bundle = Bundle(for: RealCardBundleToken.self)
        if let bundled = bundle.url(forResource: "index", withExtension: "json", subdirectory: "real-cards") {
            return bundled
        }
        let direct = bundle.bundleURL.appendingPathComponent("real-cards/index.json")
        if FileManager.default.fileExists(atPath: direct.path) {
            return direct
        }
        let host = repoRoot.appendingPathComponent("docs/eval/real-cards/index.json")
        return FileManager.default.fileExists(atPath: host.path) ? host : nil
    }

    static func load() throws -> [EvalCase] {
        guard let indexURL, let indexData = try? Data(contentsOf: indexURL) else {
            throw RealCardDatasetError.indexMissing
        }
        guard let cardTestRoot else {
            throw RealCardDatasetError.datasetMissing
        }
        let index = try JSONDecoder().decode(RealCardIndex.self, from: indexData)

        return try index.cases.map { meta in
            let truthURL = cardTestRoot
                .appendingPathComponent("ground_truth", isDirectory: true)
                .appendingPathComponent("\(meta.id).json")
            guard let truthData = try? Data(contentsOf: truthURL) else {
                throw RealCardDatasetError.groundTruthMissing(meta.id)
            }
            let truth = try JSONDecoder().decode(RealCardGroundTruth.self, from: truthData)

            let imageURL = cardTestRoot.appendingPathComponent(meta.image)
            guard let image = UIImage(contentsOfFile: imageURL.path) else {
                throw RealCardDatasetError.imageUnavailable(meta.image)
            }

            var tags = meta.tags ?? []
            if let language = meta.language { tags.insert(language, at: 0) }
            return EvalCase(
                id: truth.id,
                tags: tags,
                image: image,
                groundTruth: truth.fields
            )
        }
    }
}

enum RealCardDatasetError: LocalizedError {
    case indexMissing
    case datasetMissing
    case groundTruthMissing(String)
    case imageUnavailable(String)

    var errorDescription: String? {
        switch self {
        case .indexMissing:
            return "缺少索引 docs/eval/real-cards/index.json（或未打进测试 bundle）"
        case .datasetMissing:
            return "缺少 card_test/（本机素材目录，或未打进测试 bundle）"
        case .groundTruthMissing(let id):
            return "缺少 Ground Truth：card_test/ground_truth/\(id).json（需先完成人工确认）"
        case .imageUnavailable(let name):
            return "无法读取图片：card_test/\(name)"
        }
    }
}

/// `Bundle(for:)` 需要一个类来定位测试 bundle。
private final class RealCardBundleToken {}

struct RealCardIndex: Decodable {
    struct Case: Decodable {
        let id: String
        let image: String
        let language: String?
        let orientation: String?
        let tags: [String]?
        let notes: String?
    }

    let datasetVersion: String
    let source: String
    let cases: [Case]
}

/// 与 `fixtures/ground_truth.schema.json` 对齐；未出现的字段为 nil。
struct RealCardGroundTruth: Decodable {
    let id: String
    let name: String?
    let company: String?
    let jobTitle: String?
    let department: String?
    let mobiles: [String]?
    let officePhones: [String]?
    let faxes: [String]?
    let emails: [String]?
    let website: String?
    let address: String?
    let postalCode: String?
    let notes: String?

    var fields: [String: [String]] {
        var result: [String: [String]] = [:]
        func put(_ key: String, _ value: String?) {
            guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            result[key] = [value]
        }
        func put(_ key: String, _ values: [String]?) {
            let cleaned = (values ?? []).filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            guard !cleaned.isEmpty else { return }
            result[key] = cleaned
        }

        put("name", name)
        put("company", company)
        put("jobTitle", jobTitle)
        put("department", department)
        put("mobiles", mobiles)
        put("officePhones", officePhones)
        put("faxes", faxes)
        put("emails", emails)
        put("website", website)
        put("address", address)
        put("postalCode", postalCode)
        return result
    }
}
