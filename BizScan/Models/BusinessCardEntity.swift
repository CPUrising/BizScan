import Foundation
import SwiftData
import BizScanCore

/// SwiftData 持久化实体。与 `BusinessCard` 一一对应，图像只存相对路径。
@Model
final class BusinessCardEntity {
    @Attribute(.unique) var id: UUID
    var originalImagePath: String
    var processedImagePath: String?

    var name: String?
    var company: String?
    var jobTitle: String?
    var department: String?

    var mobiles: [String]
    var officePhones: [String]
    var faxes: [String]
    var emails: [String]

    var website: String?
    var address: String?
    var postalCode: String?

    var tags: [String]
    var notes: String?

    var createdAt: Date
    var updatedAt: Date

    init(card: BusinessCard) {
        self.id = card.id
        self.originalImagePath = card.originalImagePath
        self.processedImagePath = card.processedImagePath
        self.name = card.name
        self.company = card.company
        self.jobTitle = card.jobTitle
        self.department = card.department
        self.mobiles = card.mobiles
        self.officePhones = card.officePhones
        self.faxes = card.faxes
        self.emails = card.emails
        self.website = card.website
        self.address = card.address
        self.postalCode = card.postalCode
        self.tags = card.tags
        self.notes = card.notes
        self.createdAt = card.createdAt
        self.updatedAt = card.updatedAt
    }

    var domainModel: BusinessCard {
        BusinessCard(
            id: id,
            originalImagePath: originalImagePath,
            processedImagePath: processedImagePath,
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
            postalCode: postalCode,
            tags: tags,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func apply(_ card: BusinessCard) {
        originalImagePath = card.originalImagePath
        processedImagePath = card.processedImagePath
        name = card.name
        company = card.company
        jobTitle = card.jobTitle
        department = card.department
        mobiles = card.mobiles
        officePhones = card.officePhones
        faxes = card.faxes
        emails = card.emails
        website = card.website
        address = card.address
        postalCode = card.postalCode
        tags = card.tags
        notes = card.notes
        createdAt = card.createdAt
        updatedAt = card.updatedAt
    }
}

/// 标签独立建表，避免从名片数组反推标签导致删除/重命名困难。
@Model
final class TagEntity {
    @Attribute(.unique) var name: String
    var createdAt: Date

    init(name: String, createdAt: Date = Date()) {
        self.name = name
        self.createdAt = createdAt
    }
}
