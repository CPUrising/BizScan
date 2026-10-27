import UIKit

/// 评估用的一例合成名片。Ground Truth 与绘制文本同源，避免手抄错位。
struct EvalCase {
    let id: String
    let tags: [String]
    let image: UIImage
    /// 字段名 → 值集合；未出现在名片上的字段直接省略。
    let groundTruth: [String: [String]]
}

/// 评估口径的归一化工具（对应 `fixtures/README.md` 第 5 节）。
enum EvalNormalizer {
    static func halfWidth(_ value: String) -> String {
        var result = String.UnicodeScalarView()
        for scalar in value.unicodeScalars {
            if scalar == "\u{3000}" {
                result.append(" ")
            } else if (0xFF01...0xFF5E).contains(scalar.value),
                      let converted = UnicodeScalar(scalar.value - 0xFEE0) {
                result.append(converted)
            } else {
                result.append(scalar)
            }
        }
        return String(result)
    }

    static func text(_ value: String) -> String {
        halfWidth(value)
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
            .lowercased()
    }

    static func phone(_ value: String) -> String {
        halfWidth(value).filter(\.isNumber)
    }

    static func email(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func website(_ value: String) -> String {
        var result = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let range = result.range(of: "://") {
            result = String(result[range.upperBound...])
        }
        while result.hasSuffix("/") { result.removeLast() }
        if result.hasPrefix("www.") { result.removeFirst(4) }
        return result
    }

    static func normalize(field: String, value: String) -> String {
        switch field {
        case "mobiles", "officePhones", "faxes":
            return phone(value)
        case "emails":
            return email(value)
        case "website":
            return website(value)
        default:
            return text(value)
        }
    }
}

/// 代码内合成的评估数据集：`synthetic-001`，15 例。
/// 与 `fixtures/` 隔离，教师资产到位后按同一口径重跑替换。
enum OCREvaluationDataset {
    static let version = "synthetic-001"

    static let fieldNames = [
        "name", "company", "jobTitle", "department",
        "mobiles", "officePhones", "faxes", "emails",
        "website", "address", "postalCode"
    ]

    static func cases() -> [EvalCase] {
        [
            makeCase(
                id: "e01",
                tags: ["en", "full"],
                lines: [
                    "David Chen",
                    "Technical Director",
                    "ABC Technologies",
                    "Mobile: 138 0000 0000",
                    "Email: david.chen@example.com",
                    "Web: www.example.com",
                    "Address: 123 Market Street, San Francisco",
                    "Postal: 200000"
                ],
                truth: [
                    "name": ["David Chen"],
                    "jobTitle": ["Technical Director"],
                    "company": ["ABC Technologies"],
                    "mobiles": ["138 0000 0000"],
                    "emails": ["david.chen@example.com"],
                    "website": ["www.example.com"],
                    "address": ["123 Market Street, San Francisco"],
                    "postalCode": ["200000"]
                ]
            ),
            makeCase(
                id: "e02",
                tags: ["zh", "full"],
                lines: [
                    "朱宏明",
                    "教授",
                    "同济大学",
                    "手机：139 0000 0000",
                    "邮箱：zhu@example.edu",
                    "网址：www.tongji.example.edu",
                    "地址：上海市杨浦区四平路1239号",
                    "邮编：200092"
                ],
                truth: [
                    "name": ["朱宏明"],
                    "jobTitle": ["教授"],
                    "company": ["同济大学"],
                    "mobiles": ["139 0000 0000"],
                    "emails": ["zhu@example.edu"],
                    "website": ["www.tongji.example.edu"],
                    "address": ["上海市杨浦区四平路1239号"],
                    "postalCode": ["200092"]
                ]
            ),
            makeCase(
                id: "e03",
                tags: ["mixed"],
                lines: [
                    "Alice Wu",
                    "Designer",
                    "Northwind Studios",
                    "手机：136 0000 0000",
                    "Email: alice@example.com",
                    "Address: 500 Market Street, San Francisco"
                ],
                truth: [
                    "name": ["Alice Wu"],
                    "jobTitle": ["Designer"],
                    "company": ["Northwind Studios"],
                    "mobiles": ["136 0000 0000"],
                    "emails": ["alice@example.com"],
                    "address": ["500 Market Street, San Francisco"]
                ]
            ),
            makeCase(
                id: "e04",
                tags: ["missing-website"],
                lines: [
                    "Kevin Zhao",
                    "Analyst",
                    "Sigma Group",
                    "Mobile: 135 0000 0000",
                    "Email: kevin.zhao@example.com",
                    "Address: 18 River Road, Hangzhou"
                ],
                truth: [
                    "name": ["Kevin Zhao"],
                    "jobTitle": ["Analyst"],
                    "company": ["Sigma Group"],
                    "mobiles": ["135 0000 0000"],
                    "emails": ["kevin.zhao@example.com"],
                    "address": ["18 River Road, Hangzhou"]
                ]
            ),
            makeCase(
                id: "e05",
                tags: ["missing-email"],
                lines: [
                    "Grace Lin",
                    "Manager",
                    "Delta Consulting",
                    "Mobile: 134 0000 0000",
                    "Address: 6 Lake Avenue, Suzhou"
                ],
                truth: [
                    "name": ["Grace Lin"],
                    "jobTitle": ["Manager"],
                    "company": ["Delta Consulting"],
                    "mobiles": ["134 0000 0000"],
                    "address": ["6 Lake Avenue, Suzhou"]
                ]
            ),
            makeCase(
                id: "e06",
                tags: ["multi-phone"],
                lines: [
                    "Wang Fang",
                    "Manager",
                    "Bright Group",
                    "Mobile: 138 0000 0000",
                    "Mobile: 139 1111 1111",
                    "Tel: 021-8888-0000",
                    "Fax: 021-8888-0001",
                    "Email: wang.fang@example.com"
                ],
                truth: [
                    "name": ["Wang Fang"],
                    "jobTitle": ["Manager"],
                    "company": ["Bright Group"],
                    "mobiles": ["138 0000 0000", "139 1111 1111"],
                    "officePhones": ["021-8888-0000"],
                    "faxes": ["021-8888-0001"],
                    "emails": ["wang.fang@example.com"]
                ]
            ),
            makeCase(
                id: "e07",
                tags: ["portrait"],
                lines: [
                    "Li Wei",
                    "Manager",
                    "Ocean Group",
                    "Mobile: 137 0000 0000",
                    "Email: li.wei@example.com"
                ],
                truth: [
                    "name": ["Li Wei"],
                    "jobTitle": ["Manager"],
                    "company": ["Ocean Group"],
                    "mobiles": ["137 0000 0000"],
                    "emails": ["li.wei@example.com"]
                ],
                portrait: true
            ),
            makeCase(
                id: "e08",
                tags: ["low-contrast"],
                lines: [
                    "Peter Sun",
                    "Engineer",
                    "Gamma Technologies",
                    "Mobile: 133 0000 0000",
                    "Email: peter.sun@example.com"
                ],
                truth: [
                    "name": ["Peter Sun"],
                    "jobTitle": ["Engineer"],
                    "company": ["Gamma Technologies"],
                    "mobiles": ["133 0000 0000"],
                    "emails": ["peter.sun@example.com"]
                ],
                textColor: UIColor(white: 0.45, alpha: 1)
            ),
            makeCase(
                id: "e09",
                tags: ["complex-background"],
                lines: [
                    "Nina Gao",
                    "Designer",
                    "Iota Studios",
                    "Mobile: 132 0000 0000",
                    "Email: nina.gao@example.com"
                ],
                truth: [
                    "name": ["Nina Gao"],
                    "jobTitle": ["Designer"],
                    "company": ["Iota Studios"],
                    "mobiles": ["132 0000 0000"],
                    "emails": ["nina.gao@example.com"]
                ],
                noisy: true
            ),
            makeCase(
                id: "e10",
                tags: ["two-line-address"],
                lines: [
                    "Chen Jie",
                    "Analyst",
                    "Data Labs",
                    "Address: Suite 1201, 88 Jianguo Road",
                    "Chaoyang District, Beijing",
                    "Postal: 100022"
                ],
                truth: [
                    "name": ["Chen Jie"],
                    "jobTitle": ["Analyst"],
                    "company": ["Data Labs"],
                    "address": ["Suite 1201, 88 Jianguo Road"],
                    "postalCode": ["100022"]
                ]
            ),
            makeCase(
                id: "e11",
                tags: ["name-company-ambiguity"],
                lines: [
                    "Jordan Lee",
                    "Founder",
                    "Lee Consulting",
                    "Email: jordan@example.com"
                ],
                truth: [
                    "name": ["Jordan Lee"],
                    "jobTitle": ["Founder"],
                    "company": ["Lee Consulting"],
                    "emails": ["jordan@example.com"]
                ]
            ),
            makeCase(
                id: "e12",
                tags: ["unlabeled-phone"],
                lines: [
                    "Michael Zhang",
                    "138 0000 0000",
                    "021-8888-0000"
                ],
                truth: [
                    "name": ["Michael Zhang"],
                    "mobiles": ["138 0000 0000"],
                    "officePhones": ["021-8888-0000"]
                ]
            ),
            makeCase(
                id: "e13",
                tags: ["department"],
                lines: [
                    "Emily Chen",
                    "Engineer",
                    "Nova Technologies",
                    "Department: Platform",
                    "Email: emily@example.com"
                ],
                truth: [
                    "name": ["Emily Chen"],
                    "jobTitle": ["Engineer"],
                    "company": ["Nova Technologies"],
                    "department": ["Platform"],
                    "emails": ["emily@example.com"]
                ]
            ),
            makeCase(
                id: "e14",
                tags: ["minimal"],
                lines: [
                    "Sarah Kim",
                    "Lumen Labs"
                ],
                truth: [
                    "name": ["Sarah Kim"],
                    "company": ["Lumen Labs"]
                ]
            ),
            makeCase(
                id: "e15",
                tags: ["full-width"],
                lines: [
                    "Ｔｏｍ Ｌｉ",
                    "Ｄｉｒｅｃｔｏｒ",
                    "Ｓｔａｒ Ｔｅｃｈｎｏｌｏｇｉｅｓ",
                    "Ｍｏｂｉｌｅ：１３８ ００００ ００００",
                    "Ｅｍａｉｌ：ｔｏｍ．ｌｉ＠ｅｘａｍｐｌｅ．ｃｏｍ"
                ],
                truth: [
                    "name": ["Tom Li"],
                    "jobTitle": ["Director"],
                    "company": ["Star Technologies"],
                    "mobiles": ["138 0000 0000"],
                    "emails": ["tom.li@example.com"]
                ]
            )
        ]
    }

    // MARK: - 绘制

    private static func makeCase(
        id: String,
        tags: [String],
        lines: [String],
        truth: [String: [String]],
        portrait: Bool = false,
        textColor: UIColor = .black,
        noisy: Bool = false
    ) -> EvalCase {
        EvalCase(
            id: id,
            tags: tags,
            image: render(lines: lines, portrait: portrait, textColor: textColor, noisy: noisy),
            groundTruth: truth
        )
    }

    private static func render(
        lines: [String],
        portrait: Bool,
        textColor: UIColor,
        noisy: Bool
    ) -> UIImage {
        let size = portrait
            ? CGSize(width: 900, height: 1400)
            : CGSize(width: 1400, height: 900)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { context in
            UIColor(white: 0.18, alpha: 1).setFill()
            context.fill(CGRect(origin: .zero, size: size))
            if noisy {
                drawNoise(in: context.cgContext, size: size)
            }

            let card = CGRect(x: 60, y: 60, width: size.width - 120, height: size.height - 120)
            let cardPath = UIBezierPath(roundedRect: card, cornerRadius: 18)
            UIColor.white.setFill()
            cardPath.fill()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                .foregroundColor: textColor
            ]
            for (index, line) in lines.enumerated() {
                (line as NSString).draw(
                    at: CGPoint(x: card.minX + 60, y: card.minY + 70 + CGFloat(index) * 95),
                    withAttributes: attributes
                )
            }
        }
    }

    /// 固定种子的确定性噪声，保证多次运行的图像一致。
    private static func drawNoise(in context: CGContext, size: CGSize) {
        var seed: UInt64 = 0x9E37_79B9_7F4A_7C15
        func next() -> CGFloat {
            seed = seed &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            return CGFloat((seed >> 33) % 1000) / 1000
        }

        for _ in 0..<400 {
            let rect = CGRect(
                x: next() * size.width,
                y: next() * size.height,
                width: 14,
                height: 14
            )
            UIColor(white: 0.3 + next() * 0.4, alpha: 1).setFill()
            context.fill(rect)
        }
    }
}
