import Foundation
import Observation
import UIKit
import BizScanCore

enum ContactKind: String, CaseIterable {
    case mobile
    case officePhone
    case fax
    case email
    case website
    case address
    case postalCode

    var title: String {
        switch self {
        case .mobile: return "手机"
        case .officePhone: return "办公电话"
        case .fax: return "传真"
        case .email: return "Email"
        case .website: return "网址"
        case .address: return "地址"
        case .postalCode: return "邮编"
        }
    }

    var symbolName: String {
        switch self {
        case .mobile, .officePhone, .fax: return "phone"
        case .email: return "envelope"
        case .website: return "globe"
        case .address, .postalCode: return "mappin.and.ellipse"
        }
    }

    var badge: String? {
        switch self {
        case .mobile: return "Mobile"
        case .officePhone: return "办公"
        case .fax: return "传真"
        default: return nil
        }
    }

    var isPhone: Bool {
        switch self {
        case .mobile, .officePhone, .fax: return true
        default: return false
        }
    }
}

struct ContactEntry: Identifiable {
    let id: String
    let kind: ContactKind
    let value: String
    var needsReview: Bool = false
}

@Observable
@MainActor
final class DetailViewModel {
    private let repository: BusinessCardRepository
    private let imageStore: ImageStoring

    let cardID: UUID
    private(set) var card: BusinessCard?
    var isEditing = false
    var errorMessage: String?
    var didDelete = false

    var name = ""
    var company = ""
    var jobTitle = ""
    var department = ""
    var mobilesText = ""
    var officePhonesText = ""
    var faxesText = ""
    var emailsText = ""
    var website = ""
    var address = ""
    var postalCode = ""
    var notes = ""
    var tags: [String] = []
    var newTag = ""

    init(cardID: UUID, repository: BusinessCardRepository, imageStore: ImageStoring) {
        self.cardID = cardID
        self.repository = repository
        self.imageStore = imageStore
    }

    func load() {
        do {
            card = try repository.fetch(id: cardID)
            syncFields()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func beginEditing() {
        syncFields()
        isEditing = true
    }

    func cancelEditing() {
        isEditing = false
        syncFields()
    }

    func save() {
        guard let existing = card else { return }
        var card = existing

        card.name = nilIfEmpty(name)
        card.company = nilIfEmpty(company)
        card.jobTitle = nilIfEmpty(jobTitle)
        card.department = nilIfEmpty(department)
        card.mobiles = splitLines(mobilesText)
        card.officePhones = splitLines(officePhonesText)
        card.faxes = splitLines(faxesText)
        card.emails = splitLines(emailsText)
        card.website = nilIfEmpty(website)
        card.address = nilIfEmpty(address)
        card.postalCode = nilIfEmpty(postalCode)
        card.notes = nilIfEmpty(notes)
        card.tags = tags
        card.unverifiedValues = retainedUnverifiedValues(in: card)
        card.touch()

        do {
            try repository.save(card)
            self.card = card
            isEditing = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete() {
        do {
            try repository.delete(id: cardID)
            didDelete = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite() {
        guard var card else { return }
        let previous = card
        card.isFavorite.toggle()
        do {
            try repository.save(card)
            self.card = card
        } catch {
            self.card = previous
            errorMessage = error.localizedDescription
        }
    }

    func image() -> UIImage? {
        guard let card = card else { return nil }
        if let processed = card.processedImagePath,
           let image = imageStore.image(forRelativePath: processed) {
            return image
        }
        guard let original = card.originalImagePath else { return nil }
        return imageStore.image(forRelativePath: original)
    }

    var hasImage: Bool { image() != nil }

    var displayName: String {
        card?.displayTitle(fallback: AppCopy.unnamedCard) ?? AppCopy.unnamedCard
    }

    /// 头像首字：姓名首字 → 公司首字 → 「名」。
    var avatarInitial: String {
        for candidate in [card?.name, card?.company] {
            guard let text = candidate?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let first = text.first else { continue }
            return String(first)
        }
        return "名"
    }

    var subtitle: String? {
        let jobTitle = card?.jobTitle?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (jobTitle?.isEmpty == false) ? jobTitle : nil
    }

    var companyName: String? {
        let company = card?.company?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (company?.isEmpty == false) ? company : nil
    }

    var notesText: String? {
        let notes = card?.notes?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (notes?.isEmpty == false) ? notes : nil
    }

    var groupDisplayName: String {
        card?.group ?? AppCopy.ungrouped
    }

    var isFavorite: Bool {
        card?.isFavorite ?? false
    }

    var contactEntries: [ContactEntry] {
        guard let card else { return [] }
        let unverified = Set(card.unverifiedValues)
        func entry(_ id: String, _ kind: ContactKind, _ value: String) -> ContactEntry {
            ContactEntry(id: id, kind: kind, value: value, needsReview: unverified.contains(value))
        }

        var entries: [ContactEntry] = []
        for (index, phone) in card.mobiles.enumerated() {
            entries.append(entry("mobile-\(index)", .mobile, phone))
        }
        for (index, phone) in card.officePhones.enumerated() {
            entries.append(entry("office-\(index)", .officePhone, phone))
        }
        for (index, fax) in card.faxes.enumerated() {
            entries.append(entry("fax-\(index)", .fax, fax))
        }
        for (index, email) in card.emails.enumerated() {
            entries.append(entry("email-\(index)", .email, email))
        }
        if let website = card.website, !website.isEmpty {
            entries.append(entry("website", .website, website))
        }
        if let address = card.address, !address.isEmpty {
            entries.append(entry("address", .address, address))
        }
        if let postalCode = card.postalCode, !postalCode.isEmpty {
            entries.append(entry("postal", .postalCode, postalCode))
        }
        return entries
    }

    var primaryPhoneURL: URL? {
        guard let phone = firstPhoneValue else { return nil }
        let digits = phone.filter { "0123456789+".contains($0) }
        return digits.isEmpty ? nil : URL(string: "tel://\(digits)")
    }

    var mapsURL: URL? {
        guard let address = card?.address, !address.isEmpty else { return nil }
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? address
        return URL(string: "maps://?q=\(encoded)")
    }

    func actionURL(for entry: ContactEntry) -> URL? {
        switch entry.kind {
        case .mobile, .officePhone, .fax:
            return phoneURL(for: entry.value)
        case .email:
            return URL(string: "mailto:\(entry.value)")
        case .website:
            let normalized = entry.value.contains("://") ? entry.value : "https://\(entry.value)"
            return URL(string: normalized)
        case .address:
            let encoded = entry.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? entry.value
            return URL(string: "maps://?q=\(encoded)")
        case .postalCode:
            return nil
        }
    }

    private var firstPhoneValue: String? {
        guard let card else { return nil }
        return (card.mobiles + card.officePhones + card.faxes).first { !$0.isEmpty }
    }

    private func phoneURL(for value: String) -> URL? {
        let digits = value.filter { "0123456789+".contains($0) }
        return digits.isEmpty ? nil : URL(string: "tel://\(digits)")
    }

    private func syncFields() {
        guard let card = card else { return }
        name = card.name ?? ""
        company = card.company ?? ""
        jobTitle = card.jobTitle ?? ""
        department = card.department ?? ""
        mobilesText = card.mobiles.joined(separator: "\n")
        officePhonesText = card.officePhones.joined(separator: "\n")
        faxesText = card.faxes.joined(separator: "\n")
        emailsText = card.emails.joined(separator: "\n")
        website = card.website ?? ""
        address = card.address ?? ""
        postalCode = card.postalCode ?? ""
        notes = card.notes ?? ""
        tags = card.tags
    }

    func addTag() {
        let trimmed = ContactNormalizer.trimming(ContactNormalizer.halfWidth(newTag))
        guard !trimmed.isEmpty else { return }
        if !tags.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            tags.append(trimmed)
        }
        newTag = ""
    }

    func removeTag(_ tag: String) {
        tags.removeAll { $0.caseInsensitiveCompare(tag) == .orderedSame }
    }

    private func retainedUnverifiedValues(in card: BusinessCard) -> [String] {
        let current = Set(
            card.mobiles + card.officePhones + card.faxes + card.emails + [card.address].compactMap { $0 }
        )
        return card.unverifiedValues.filter { current.contains($0) }
    }

    private func splitLines(_ text: String) -> [String] {
        text
            .split(whereSeparator: { $0 == "\n" || $0 == "," || $0 == ";" || $0 == "；" })
            .map { ContactNormalizer.trimming(ContactNormalizer.halfWidth(String($0))) }
            .filter { !$0.isEmpty }
    }

    private func nilIfEmpty(_ text: String) -> String? {
        let trimmed = ContactNormalizer.trimming(text)
        return trimmed.isEmpty ? nil : trimmed
    }
}
