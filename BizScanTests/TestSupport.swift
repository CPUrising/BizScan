import Foundation
import UIKit
import SwiftData
import BizScanCore
@testable import BizScan

/// L2 测试共用的构造器。只放工厂方法，不放断言。
enum TestSupport {
    /// 生成纯色小图；不依赖任何 fixture 文件。
    static func makeImage(
        color: UIColor,
        size: CGSize = CGSize(width: 8, height: 8)
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    /// 逐字段构造 `ParsedCard`（`ParsedCard` 只暴露 `init()`，字段需逐个赋值）。
    static func makeParsedCard(
        name: String? = "David Chen",
        company: String? = "ABC Technologies",
        jobTitle: String? = "Technical Director",
        department: String? = "Engineering",
        mobiles: [String] = ["+86 138 0000 0000"],
        officePhones: [String] = ["021-8888-0000"],
        faxes: [String] = ["021-8888-0001"],
        emails: [String] = ["david.chen@example.com"],
        website: String? = "example.com",
        address: String? = "123 Market Street, San Francisco",
        postalCode: String? = "200000",
        unresolvedLines: [String] = []
    ) -> ParsedCard {
        var parsed = ParsedCard()
        parsed.name = name
        parsed.company = company
        parsed.jobTitle = jobTitle
        parsed.department = department
        parsed.mobiles = mobiles
        parsed.officePhones = officePhones
        parsed.faxes = faxes
        parsed.emails = emails
        parsed.website = website
        parsed.address = address
        parsed.postalCode = postalCode
        parsed.unresolvedLines = unresolvedLines
        return parsed
    }

    /// 构造管线结果；图像为内存生成的纯色图，不触碰磁盘与相机。
    static func makeScanResult(
        name: String? = "David Chen",
        company: String? = "ABC Technologies",
        jobTitle: String? = "Technical Director",
        department: String? = "Engineering",
        mobiles: [String] = ["+86 138 0000 0000"],
        officePhones: [String] = ["021-8888-0000"],
        faxes: [String] = ["021-8888-0001"],
        emails: [String] = ["david.chen@example.com"],
        website: String? = "example.com",
        address: String? = "123 Market Street, San Francisco",
        postalCode: String? = "200000"
    ) -> ScanResult {
        ScanResult(
            originalImage: makeImage(color: .white),
            processedImage: makeImage(color: .gray),
            quad: nil,
            observations: [],
            parsed: makeParsedCard(
                name: name,
                company: company,
                jobTitle: jobTitle,
                department: department,
                mobiles: mobiles,
                officePhones: officePhones,
                faxes: faxes,
                emails: emails,
                website: website,
                address: address,
                postalCode: postalCode
            )
        )
    }

    /// 在临时目录下建一个真实落盘的 SwiftData 容器。
    /// 「重建同一 URL 的容器」用于模拟 Kill App 后重启（T18）。
    static func makeTemporaryContainer() throws -> (container: ModelContainer, directory: URL) {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("BizScanPersistenceTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let schema = Schema([BusinessCardEntity.self, TagEntity.self])
        let url = directory.appendingPathComponent("store.sqlite")
        let container = try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(schema: schema, url: url)
        )
        return (container, directory)
    }
}
