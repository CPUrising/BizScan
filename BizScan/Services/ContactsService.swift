import Foundation
import Contacts
import BizScanCore

enum ContactsSaveResult: Equatable {
    case saved
    case alreadyExists
}

enum ContactsServiceError: LocalizedError {
    case denied
    case failed(String)

    var errorDescription: String? {
        switch self {
        case .denied:
            return "需要通讯录权限才能存入联系人。"
        case .failed(let reason):
            return reason
        }
    }
}

@MainActor
protocol ContactsSaving {
    func save(_ card: BusinessCard) async throws -> ContactsSaveResult
}

/// 把名片字段映射为系统联系人。纯函数，便于单测。
enum ContactsMapper {
    static func makeContact(from card: BusinessCard) -> CNMutableContact {
        let contact = CNMutableContact()

        if let name = normalized(card.name) {
            contact.givenName = name
        }
        if let company = normalized(card.company) {
            contact.organizationName = company
        }
        if let jobTitle = normalized(card.jobTitle) {
            contact.jobTitle = jobTitle
        }
        if let department = normalized(card.department) {
            contact.departmentName = department
        }

        contact.phoneNumbers = card.mobiles.map {
            CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: $0))
        } + card.officePhones.map {
            CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: $0))
        } + card.faxes.map {
            CNLabeledValue(label: CNLabelPhoneNumberWorkFax, value: CNPhoneNumber(stringValue: $0))
        }

        contact.emailAddresses = card.emails.map {
            CNLabeledValue(label: CNLabelWork, value: $0 as NSString)
        }

        if let website = normalized(card.website) {
            contact.urlAddresses = [CNLabeledValue(label: CNLabelWork, value: website as NSString)]
        }

        if let address = normalized(card.address) {
            let postal = CNMutablePostalAddress()
            postal.street = address
            if let postalCode = normalized(card.postalCode) {
                postal.postalCode = postalCode
            }
            contact.postalAddresses = [CNLabeledValue(label: CNLabelWork, value: postal)]
        }

        return contact
    }

    /// 归一化后的全部可比较值，用于重复判定。
    static func comparableValues(for card: BusinessCard) -> Set<String> {
        var values = Set<String>()
        for phone in card.mobiles + card.officePhones + card.faxes {
            values.insert(normalizePhone(phone))
        }
        for email in card.emails {
            values.insert(email.lowercased())
        }
        values.remove("")
        return values
    }

    static func normalizePhone(_ value: String) -> String {
        value.filter { $0.isNumber }
    }

    private static func normalized(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else { return nil }
        return trimmed
    }
}

/// 真实通讯录实现：权限 → 去重 → 写入。
@MainActor
final class SystemContactsService: ContactsSaving {
    private let store: CNContactStore

    init(store: CNContactStore = CNContactStore()) {
        self.store = store
    }

    func save(_ card: BusinessCard) async throws -> ContactsSaveResult {
        guard try await requestAccess() else {
            throw ContactsServiceError.denied
        }

        if try existingContactExists(for: card) {
            return .alreadyExists
        }

        let request = CNSaveRequest()
        request.add(ContactsMapper.makeContact(from: card), toContainerWithIdentifier: nil)

        do {
            try store.execute(request)
            return .saved
        } catch {
            throw ContactsServiceError.failed(error.localizedDescription)
        }
    }

    private func requestAccess() async throws -> Bool {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .limited:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return try await withCheckedThrowingContinuation { continuation in
                store.requestAccess(for: .contacts) { granted, error in
                    if let error {
                        continuation.resume(throwing: ContactsServiceError.failed(error.localizedDescription))
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            }
        @unknown default:
            return false
        }
    }

    private func existingContactExists(for card: BusinessCard) throws -> Bool {
        let name = card.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !name.isEmpty else { return false }

        let predicate = CNContact.predicateForContacts(matchingName: name)
        let keys: [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor
        ]

        let matches: [CNContact]
        do {
            matches = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        } catch {
            throw ContactsServiceError.failed(error.localizedDescription)
        }

        let target = ContactsMapper.comparableValues(for: card)
        guard !target.isEmpty else { return false }

        for contact in matches {
            var candidate = Set<String>()
            for phone in contact.phoneNumbers {
                candidate.insert(ContactsMapper.normalizePhone(phone.value.stringValue))
            }
            for email in contact.emailAddresses {
                candidate.insert((email.value as String).lowercased())
            }
            candidate.remove("")
            if !candidate.isDisjoint(with: target) {
                return true
            }
        }
        return false
    }
}
