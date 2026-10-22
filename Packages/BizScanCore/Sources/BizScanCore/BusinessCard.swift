import Foundation

/// 一张已保存名片的完整记录。
///
/// 该类型是 OCR、字段解析、人工校正、持久化与导出之间的唯一契约。
/// 未识别字段必须保持 `nil` 或空数组，禁止使用空字符串或推测值占位。
public struct BusinessCard: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var originalImagePath: String
    public var processedImagePath: String?

    public var name: String?
    public var company: String?
    public var jobTitle: String?
    public var department: String?

    public var mobiles: [String]
    public var officePhones: [String]
    public var faxes: [String]
    public var emails: [String]

    public var website: String?
    public var address: String?
    public var postalCode: String?

    public var tags: [String]
    public var notes: String?

    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        originalImagePath: String,
        processedImagePath: String? = nil,
        name: String? = nil,
        company: String? = nil,
        jobTitle: String? = nil,
        department: String? = nil,
        mobiles: [String] = [],
        officePhones: [String] = [],
        faxes: [String] = [],
        emails: [String] = [],
        website: String? = nil,
        address: String? = nil,
        postalCode: String? = nil,
        tags: [String] = [],
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.originalImagePath = originalImagePath
        self.processedImagePath = processedImagePath
        self.name = name
        self.company = company
        self.jobTitle = jobTitle
        self.department = department
        self.mobiles = mobiles
        self.officePhones = officePhones
        self.faxes = faxes
        self.emails = emails
        self.website = website
        self.address = address
        self.postalCode = postalCode
        self.tags = tags
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt ?? createdAt
    }

    /// 列表与详情页的主标题：姓名优先，其次公司，最后回退文案。
    public func displayTitle(fallback: String = "未命名名片") -> String {
        for candidate in [name, company] {
            if let value = candidate?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty {
                return value
            }
        }
        return fallback
    }

    /// 列表第二行：公司优先，其次职位，再退到第一个联系方式。
    public var displaySubtitle: String? {
        for candidate in [company, jobTitle, mobiles.first, officePhones.first, emails.first] {
            if let value = candidate?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty {
                return value
            }
        }
        return nil
    }

    /// 所有结构化字段均为空时视为空名片（仍允许保存，但 UI 必须提示）。
    public var isEmpty: Bool {
        let textFields = [name, company, jobTitle, department, website, address, postalCode, notes]
        let hasText = textFields.contains { value in
            guard let value else { return false }
            return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return !hasText
            && mobiles.isEmpty
            && officePhones.isEmpty
            && faxes.isEmpty
            && emails.isEmpty
    }

    public mutating func touch(at date: Date = Date()) {
        updatedAt = date
    }
}
