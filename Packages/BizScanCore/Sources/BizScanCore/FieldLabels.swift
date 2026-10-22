import Foundation

/// 名片的结构化字段分类。
public enum FieldKind: String, Codable, CaseIterable, Sendable {
    case name
    case company
    case jobTitle
    case department
    case mobile
    case officePhone
    case fax
    case email
    case website
    case address
    case postalCode
}

public struct LabelRule: Sendable {
    public let kind: FieldKind
    public let keywords: [String]

    public init(kind: FieldKind, keywords: [String]) {
        self.kind = kind
        self.keywords = keywords
    }
}

/// 中英标签词典与标签行拆分。
///
/// 设计原则：宁可拆不出来，也不要把正文误当标签——误拆会污染字段。
public enum FieldLabels {
    /// 顺序即优先级：传真/手机必须先于通用电话，邮箱必须先于网址。
    public static let rules: [LabelRule] = [
        LabelRule(kind: .fax, keywords: [
            "传真号码", "传真", "fax no", "fax", "facsimile", "f:"
        ]),
        LabelRule(kind: .mobile, keywords: [
            "手机号码", "手机号", "手机", "移动电话", "mobile", "cellphone", "cell", "mob", "m:"
        ]),
        LabelRule(kind: .officePhone, keywords: [
            "办公电话", "座机", "公司电话", "电话", "tel", "telephone", "phone", "office", "t:", "o:"
        ]),
        LabelRule(kind: .email, keywords: [
            "电子邮件", "电子邮箱", "邮箱", "email", "e-mail", "mail"
        ]),
        LabelRule(kind: .website, keywords: [
            "官方网站", "网址", "官网", "网站", "website", "web", "url", "homepage"
        ]),
        LabelRule(kind: .postalCode, keywords: [
            "邮政编码", "邮编", "zipcode", "zip code", "zip", "postal code", "postal"
        ]),
        LabelRule(kind: .address, keywords: [
            "地址", "住址", "地点", "address", "addr", "add"
        ]),
        LabelRule(kind: .department, keywords: [
            "部门", "科室", "事业部", "department", "dept", "division"
        ]),
        LabelRule(kind: .company, keywords: [
            "公司名称", "公司", "单位", "企业", "company", "co.", "corp.", "corporation", "ltd.", "inc."
        ]),
        LabelRule(kind: .jobTitle, keywords: [
            "职位", "职务", "头衔", "title", "position", "job title"
        ]),
        LabelRule(kind: .name, keywords: [
            "姓名", "名字", "联系人", "name"
        ])
    ]

    public static let jobTitleKeywords: [String] = [
        "professor", "director", "manager", "engineer", "architect", "designer",
        "analyst", "consultant", "president", "founder", "specialist", "scientist",
        "supervisor", "coordinator", "assistant", "ceo", "cto", "cfo", "coo",
        "教授", "副教授", "讲师", "研究员", "工程师", "经理", "总监", "主管",
        "主任", "总裁", "董事长", "首席", "专员", "顾问", "设计师", "架构师"
    ]

    public static let companyKeywords: [String] = [
        "company", "corporation", "technologies", "technology", "university",
        "college", "institute", "consulting", "group", "studios", "labs",
        "limited", "ltd", "inc", "corp", "gmbh",
        "有限公司", "集团", "大学", "学院", "研究院", "事务所", "工作室", "咨询", "科技"
    ]

    public static let addressKeywords: [String] = [
        "road", "street", "avenue", "suite", "floor", "building", "district",
        "province", "postcode",
        "路", "街", "大道", "号", "楼", "室", "层", "区", "市", "省", "镇", "村", "园区"
    ]

    /// 返回标签对应的字段分类；`label` 允许是 "Mobile"、"手机号"、"E-mail" 等。
    public static func kind(forLabel label: String) -> FieldKind? {
        let normalized = ContactNormalizer.halfWidth(label)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard !normalized.isEmpty else { return nil }

        var best: (kind: FieldKind, length: Int)?
        for rule in rules {
            for keyword in rule.keywords where normalized.contains(keyword) {
                if best == nil || keyword.count > best!.length {
                    best = (rule.kind, keyword.count)
                }
            }
        }
        return best?.kind
    }

    /// 拆分 `"Mobile: +86 138..."`、`"手机号：138..."`、`"Tel 021-8888"` 三类写法。
    ///
    /// 仅在冒号前缀足够短、且不像正文/网址时拆分，避免把 `https://...` 当标签。
    public static func splitLabel(from line: String) -> (label: String, value: String)? {
        if let colonIndex = firstColonIndex(in: line) {
            let prefix = ContactNormalizer.trimming(String(line[line.startIndex..<colonIndex]))
            let value = ContactNormalizer.trimming(String(line[line.index(after: colonIndex)...]))
            if isPlausibleLabel(prefix), !value.isEmpty {
                return (prefix, value)
            }
        }

        let candidates = rules
            .flatMap(\.keywords)
            .filter { !$0.isEmpty }
            .sorted { $0.count > $1.count }

        let lowered = ContactNormalizer.halfWidth(line).lowercased()
        for keyword in candidates {
            guard lowered.count >= keyword.count, line.count >= keyword.count else { continue }
            guard lowered.hasPrefix(keyword) else { continue }
            let boundary = lowered.index(lowered.startIndex, offsetBy: keyword.count)
            guard boundary < lowered.endIndex else { continue }
            let next = lowered[boundary]
            guard next == " " || next == "\t" || next == "-" else { continue }

            let originalBoundary = line.index(line.startIndex, offsetBy: keyword.count)
            let value = ContactNormalizer.trimming(String(line[originalBoundary...]))
            if !value.isEmpty {
                return (keyword, value)
            }
        }
        return nil
    }

    private static func firstColonIndex(in line: String) -> String.Index? {
        line.firstIndex(where: { $0 == ":" || $0 == "：" })
    }

    private static func isPlausibleLabel(_ text: String) -> Bool {
        guard !text.isEmpty, text.count <= 12 else { return false }
        guard !text.contains("@"), !text.contains("/"), !text.contains("\\") else { return false }
        guard !text.contains(where: { $0.isNumber }) else { return false }
        return true
    }
}
