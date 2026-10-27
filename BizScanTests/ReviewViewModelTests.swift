import XCTest
import BizScanCore
@testable import BizScan

/// T11 / T12 的 L2 证据：人工校正后的落库与图像路径持久化。
@MainActor
final class ReviewViewModelTests: XCTestCase {
    func testInitPrefillsParsedFieldsFromScanResult() throws {
        let repository = InMemoryBusinessCardRepository()
        let imageStore = InMemoryImageStore()
        let viewModel = try ReviewViewModel(
            scanResult: TestSupport.makeScanResult(),
            repository: repository,
            imageStore: imageStore
        )

        XCTAssertEqual(viewModel.name, "David Chen")
        XCTAssertEqual(viewModel.company, "ABC Technologies")
        XCTAssertEqual(viewModel.jobTitle, "Technical Director")
        XCTAssertEqual(viewModel.department, "Engineering")
        XCTAssertEqual(viewModel.mobilesText, "+86 138 0000 0000")
        XCTAssertEqual(viewModel.officePhonesText, "021-8888-0000")
        XCTAssertEqual(viewModel.faxesText, "021-8888-0001")
        XCTAssertEqual(viewModel.emailsText, "david.chen@example.com")
        XCTAssertEqual(viewModel.website, "example.com")
        XCTAssertEqual(viewModel.address, "123 Market Street, San Francisco")
        XCTAssertEqual(viewModel.postalCode, "200000")
    }

    func testT11ManualCorrectionPersistsEditedFields() throws {
        let repository = InMemoryBusinessCardRepository()
        let viewModel = try ReviewViewModel(
            scanResult: TestSupport.makeScanResult(),
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.name = "David C. Chen"
        viewModel.mobilesText = "138 0000 0000\n139 0000 0000"
        viewModel.emailsText = "david@example.com" + "\n" + "dchen@example.com"

        viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        let stored = try XCTUnwrap(try repository.fetchAll().first)
        XCTAssertEqual(stored.name, "David C. Chen")
        XCTAssertEqual(stored.mobiles, ["138 0000 0000", "139 0000 0000"])
        XCTAssertEqual(stored.emails, ["david@example.com", "dchen@example.com"])
        XCTAssertEqual(stored.company, "ABC Technologies")
    }

    func testT12FirstSavePersistsImagePathsAndRecord() throws {
        let repository = InMemoryBusinessCardRepository()
        let imageStore = InMemoryImageStore()
        let viewModel = try ReviewViewModel(
            scanResult: TestSupport.makeScanResult(),
            repository: repository,
            imageStore: imageStore
        )

        viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        let stored = try XCTUnwrap(try repository.fetchAll().first)
        XCTAssertFalse(stored.originalImagePath.isEmpty)
        let processedPath = try XCTUnwrap(stored.processedImagePath)
        XCTAssertFalse(processedPath.isEmpty)
        XCTAssertNotNil(imageStore.data(forRelativePath: stored.originalImagePath))
        XCTAssertNotNil(imageStore.data(forRelativePath: processedPath))
    }

    func testEmptyCardRequiresConfirmation() throws {
        let repository = InMemoryBusinessCardRepository()
        let viewModel = try ReviewViewModel(
            scanResult: TestSupport.makeScanResult(),
            repository: repository,
            imageStore: InMemoryImageStore()
        )

        viewModel.name = ""
        viewModel.company = ""
        viewModel.jobTitle = ""
        viewModel.department = ""
        viewModel.mobilesText = ""
        viewModel.officePhonesText = ""
        viewModel.emailsText = ""
        viewModel.website = ""
        viewModel.address = ""
        viewModel.postalCode = ""

        viewModel.save()

        XCTAssertTrue(viewModel.showsEmptyWarning)
        XCTAssertFalse(viewModel.didSave)
        XCTAssertTrue(try repository.fetchAll().isEmpty)

        viewModel.save(force: true)

        XCTAssertTrue(viewModel.didSave)
        XCTAssertEqual(try repository.fetchAll().count, 1)
    }

    func testSavingExistingCardKeepsIDAndDoesNotDuplicate() throws {
        let existing = BusinessCard(originalImagePath: "CardImages/existing.jpg", name: "Old Name")
        let repository = InMemoryBusinessCardRepository(cards: [existing])
        let viewModel = try ReviewViewModel(
            scanResult: TestSupport.makeScanResult(),
            repository: repository,
            imageStore: InMemoryImageStore(),
            existingCard: existing
        )

        viewModel.name = "New Name"
        viewModel.save()

        let all = try repository.fetchAll()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.id, existing.id)
        XCTAssertEqual(all.first?.name, "New Name")
        XCTAssertEqual(all.first?.originalImagePath, "CardImages/existing.jpg")
    }
}
