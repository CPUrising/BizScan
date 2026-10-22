import Foundation
import Observation
import UIKit
import BizScanCore

@Observable
@MainActor
final class ReviewViewModel {
    private let repository: BusinessCardRepository
    private let imageStore: ImageStoring
    private let existingCard: BusinessCard?
    private let originalData: Data
    private let processedData: Data

    let parsed: ParsedCard
    let previewImage: UIImage

    var name: String
    var company: String
    var jobTitle: String
    var department: String
    var mobilesText: String
    var officePhonesText: String
    var faxesText: String
    var emailsText: String
    var website: String
    var address: String
    var postalCode: String
    var notes: String
    var tags: [String]
    var newTag = ""

    var isSaving = false
    var didSave = false
    var errorMessage: String?
    var showsEmptyWarning = false

    init(
        scanResult: ScanResult,
        repository: BusinessCardRepository,
        imageStore: ImageStoring,
        existingCard: BusinessCard? = nil
    ) throws {
        self.repository = repository
        self.imageStore = imageStore
        self.existingCard = existingCard
        self.parsed = scanResult.parsed
        self.previewImage = scanResult.processedImage

        guard let originalData = scanResult.originalImage.jpegData(compressionQuality: 0.9),
              let processedData = scanResult.processedImage.jpegData(compressionQuality: 0.9) else {
            throw ScanPipelineError.encodeFailed
        }
        self.originalData = originalData
        self.processedData = processedData

        let source = existingCard
        self.name = source?.name ?? scanResult.parsed.name ?? ""
        self.company = source?.company ?? scanResult.parsed.company ?? ""
        self.jobTitle = source?.jobTitle ?? scanResult.parsed.jobTitle ?? ""
        self.department = source?.department ?? scanResult.parsed.department ?? ""
        self.mobilesText = (source?.mobiles ?? scanResult.parsed.mobiles).joined(separator: "\n")
        self.officePhonesText = (source?.officePhones ?? scanResult.parsed.officePhones).joined(separator: "\n")
        self.faxesText = (source?.faxes ?? scanResult.parsed.faxes).joined(separator: "\n")
        self.emailsText = (source?.emails ?? scanResult.parsed.emails).joined(separator: "\n")
        self.website = source?.website ?? scanResult.parsed.website ?? ""
        self.address = source?.address ?? scanResult.parsed.address ?? ""
        self.postalCode = source?.postalCode ?? scanResult.parsed.postalCode ?? ""
        self.notes = source?.notes ?? ""
        self.tags = source?.tags ?? []
    }

    var unresolvedLines: [String] {
        parsed.unresolvedLines
    }

    var isEmptyCard: Bool {
        let text = [name, company, jobTitle, department, website, address, postalCode]
        let hasText = text.contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        return !hasText
            && splitLines(mobilesText).isEmpty
            && splitLines(officePhonesText).isEmpty
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
            let id = existingCard?.id ?? UUID()
            var card = existingCard ?? BusinessCard(id: id, originalImagePath: "")

            if existingCard == nil {
                card.originalImagePath = try imageStore.saveImageData(originalData, cardID: id, kind: .original)
                card.processedImagePath = try imageStore.saveImageData(processedData, cardID: id, kind: .processed)
            }

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
