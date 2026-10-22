import Foundation
import Observation
import UIKit
import BizScanCore

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

    func image() -> UIImage? {
        guard let card = card else { return nil }
        if let processed = card.processedImagePath,
           let image = imageStore.image(forRelativePath: processed) {
            return image
        }
        return imageStore.image(forRelativePath: card.originalImagePath)
    }

    var displayRows: [(String, String)] {
        guard let card = card else { return [] }
        var rows: [(String, String)] = []
        if let name = card.name { rows.append(("姓名", name)) }
        if let company = card.company { rows.append(("公司", company)) }
        if let jobTitle = card.jobTitle { rows.append(("职位", jobTitle)) }
        if let department = card.department { rows.append(("部门", department)) }
        for phone in card.mobiles { rows.append(("手机", phone)) }
        for phone in card.officePhones { rows.append(("办公电话", phone)) }
        for fax in card.faxes { rows.append(("传真", fax)) }
        for email in card.emails { rows.append(("邮箱", email)) }
        if let website = card.website { rows.append(("网址", website)) }
        if let address = card.address { rows.append(("地址", address)) }
        if let postalCode = card.postalCode { rows.append(("邮编", postalCode)) }
        if let notes = card.notes { rows.append(("备注", notes)) }
        return rows
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
        if !tags.contains(where: { .caseInsensitiveCompare(trimmed) == .orderedSame }) {
            tags.append(trimmed)
        }
        newTag = ""
    }

    func removeTag(_ tag: String) {
        tags.removeAll { .caseInsensitiveCompare(tag) == .orderedSame }
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
