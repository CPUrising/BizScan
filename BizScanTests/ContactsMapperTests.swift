import XCTest
import Contacts
import BizScanCore
@testable import BizScan

final class ContactsMapperTests: XCTestCase {
    private func makeCard() -> BusinessCard {
        BusinessCard(
            originalImagePath: nil,
            name: "唐冰",
            company: "北京小满云创文化产业有限公司",
            jobTitle: "董事长",
            department: "管理层",
            mobiles: ["13504119001"],
            officePhones: ["010-88880000"],
            faxes: ["010-88880001"],
            emails: ["debiletang@xiaoman.com"],
            website: "xiaoman.com",
            address: "百子湾 东朝时代广场 西区 6号楼",
            postalCode: "100022"
        )
    }

    func testMapsIdentityFields() {
        let contact = ContactsMapper.makeContact(from: makeCard())

        XCTAssertEqual(contact.givenName, "唐冰")
        XCTAssertEqual(contact.organizationName, "北京小满云创文化产业有限公司")
        XCTAssertEqual(contact.jobTitle, "董事长")
        XCTAssertEqual(contact.departmentName, "管理层")
    }

    func testMapsPhonesWithLabels() {
        let contact = ContactsMapper.makeContact(from: makeCard())

        XCTAssertEqual(contact.phoneNumbers.count, 3)
        XCTAssertEqual(contact.phoneNumbers[0].label, CNLabelPhoneNumberMobile)
        XCTAssertEqual(contact.phoneNumbers[0].value.stringValue, "13504119001")
        XCTAssertEqual(contact.phoneNumbers[1].label, CNLabelWork)
        XCTAssertEqual(contact.phoneNumbers[2].label, CNLabelPhoneNumberWorkFax)
    }

    func testMapsEmailWebsiteAndAddress() {
        let contact = ContactsMapper.makeContact(from: makeCard())

        XCTAssertEqual(contact.emailAddresses.first?.value as String?, "debiletang@xiaoman.com")
        XCTAssertEqual(contact.urlAddresses.first?.value as String?, "xiaoman.com")

        let postal = contact.postalAddresses.first?.value
        XCTAssertEqual(postal?.street, "百子湾 东朝时代广场 西区 6号楼")
        XCTAssertEqual(postal?.postalCode, "100022")
    }

    func testOmitsEmptyFields() {
        let card = BusinessCard(originalImagePath: nil, name: "   ")
        let contact = ContactsMapper.makeContact(from: card)

        XCTAssertTrue(contact.givenName.isEmpty)
        XCTAssertTrue(contact.organizationName.isEmpty)
        XCTAssertTrue(contact.phoneNumbers.isEmpty)
        XCTAssertTrue(contact.emailAddresses.isEmpty)
        XCTAssertTrue(contact.urlAddresses.isEmpty)
        XCTAssertTrue(contact.postalAddresses.isEmpty)
    }

    func testComparableValuesNormalizePhonesAndEmails() {
        let values = ContactsMapper.comparableValues(for: makeCard())

        XCTAssertTrue(values.contains("13504119001"))
        XCTAssertTrue(values.contains("01088880000"))
        XCTAssertTrue(values.contains("debiletang@xiaoman.com"))
        XCTAssertEqual(ContactsMapper.normalizePhone("135 0411-9001"), "13504119001")
    }
}
