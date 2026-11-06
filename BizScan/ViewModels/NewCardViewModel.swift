import Foundation
import Observation
import BizScanCore

@Observable
@MainActor
final class NewCardViewModel {
    private let repository: BusinessCardRepository

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
    var group: String?

    private(set) var groups: [String] = []
    private(set) var isSaving = false
    var didSave = false
    var showsEmptyWarning = false
    var errorMessage: String?

    init(repository: BusinessCardRepository) {
        self.repository = repository
    }

    func loadGroups() {
        do {
            groups = try repository.allGroups()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var isEmptyCard: Bool {
        let text = [name, company, jobTitle, department, website, address, postalCode]
        let hasText = text.contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        return !hasText
            && splitLines(mobilesText).isEmpty
            && splitLines(officePhonesText).isEmpty
            && splitLines(faxesText).isEmpty
            && splitLines(emailsText).isEmpty
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

    func save(force: Bool = false) {
        guard !isSaving else { return }
        if !force && isEmptyCard {
            showsEmptyWarning = true
            return
        }

        isSaving = true
        defer { isSaving = false }

        do {
            var card = BusinessCard(originalImagePath: nil)
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
            card.group = group.flatMap { nilIfEmpty($0) }
            card.touch()

            try repository.save(card)
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
        }
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
