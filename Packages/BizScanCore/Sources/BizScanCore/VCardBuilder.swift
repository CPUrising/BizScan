import Foundation

/// 生成 vCard 3.0。默认只导出字段映射，不生成任何原图中不存在的值。
public enum VCardBuilder {
    public static func vCard(for card: BusinessCard) -> String {
        var lines: [String] = []
        lines.append("BEGIN:VCARD")
        lines.append("VERSION:3.0")

        lines.append("FN:\(escape(card.displayTitle()))")

        if let name = nonEmpty(card.name) {
            let parts = splitName(name)
            lines.append("N:\(escape(parts.family));\(escape(parts.given));;;")
        } else {
            lines.append("N:;;;;")
        }

        if let company = nonEmpty(card.company) {
            if let department = nonEmpty(card.department) {
                lines.append("ORG:\(escape(company));\(escape(department))")
            } else {
                lines.append("ORG:\(escape(company))")
            }
        }

        if let title = nonEmpty(card.jobTitle) {
            lines.append("TITLE:\(escape(title))")
        }

        for phone in card.mobiles where !phone.isEmpty {
            lines.append("TEL;TYPE=CELL:\(escape(phone))")
        }
        for phone in card.officePhones where !phone.isEmpty {
            lines.append("TEL;TYPE=WORK:\(escape(phone))")
        }
        for phone in card.faxes where !phone.isEmpty {
            lines.append("TEL;TYPE=FAX:\(escape(phone))")
        }

        for email in card.emails where !email.isEmpty {
            lines.append("EMAIL;TYPE=INTERNET:\(escape(email))")
        }

        if let website = nonEmpty(card.website) {
            lines.append("URL:\(escape(website))")
        }

        if let address = nonEmpty(card.address) {
            let components = [
                "",
                "",
                escape(address),
                "",
                "",
                escape(nonEmpty(card.postalCode) ?? ""),
                ""
            ]
            lines.append("ADR;TYPE=WORK:" + components.joined(separator: ";"))
        }

        if let notes = nonEmpty(card.notes) {
            lines.append("NOTE:\(escape(notes))")
        }

        lines.append("END:VCARD")

        let folded = lines.flatMap { fold($0) }
        return folded.joined(separator: "\r\n") + "\r\n"
    }

    public static func vCards(for cards: [BusinessCard]) -> String {
        cards.map { vCard(for: $0) }.joined()
    }

    /// vCard 3.0 转义：反斜杠、分号、逗号、换行。
    public static func escape(_ value: String) -> String {
        var result = value
        result = result.replacingOccurrences(of: "\\", with: "\\\\")
        result = result.replacingOccurrences(of: ";", with: "\\;")
        result = result.replacingOccurrences(of: ",", with: "\\,")
        result = result.replacingOccurrences(of: "\r\n", with: "\\n")
        result = result.replacingOccurrences(of: "\n", with: "\\n")
        result = result.replacingOccurrences(of: "\r", with: "\\n")
        return result
    }

    /// 按 UTF-8 字节折行（RFC 6350：75 字节，续行以空格开头）。
    public static func fold(_ line: String, limit: Int = 75) -> [String] {
        guard line.utf8.count > limit else { return [line] }

        var result: [String] = []
        var current = ""
        var currentBytes = 0

        for character in line {
            let characterBytes = String(character).utf8.count
            if currentBytes + characterBytes > limit, !current.isEmpty {
                result.append(current)
                current = " " + String(character)
                currentBytes = 1 + characterBytes
            } else {
                current.append(character)
                currentBytes += characterBytes
            }
        }

        if !current.isEmpty {
            result.append(current)
        }
        return result
    }

    private static func splitName(_ name: String) -> (family: String, given: String) {
        let parts = name
            .split(whereSeparator: { $0 == " " || $0 == "\u{3000}" })
            .map(String.init)
        guard parts.count >= 2 else { return (name, "") }
        let family = parts.last ?? name
        let given = parts.dropLast().joined(separator: " ")
        return (family, given)
    }

    private static func nonEmpty(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
