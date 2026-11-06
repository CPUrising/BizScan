import XCTest
import BizScanCore
@testable import BizScan

@MainActor
final class NewCardViewModelTests: XCTestCase {
    func testSaveCreatesCardWithoutImage() throws {
        let repository = InMemoryBusinessCardRepository(groups: ["客户"])
        let viewModel = NewCardViewModel(repository: repository)

        viewModel.name = "手录联系人"
        viewModel.company = "示例公司"
        viewModel.mobilesText = "13800001111"
        viewModel.group = "客户"
        viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        let stored = try XCTUnwrap(try repository.fetchAll().first)
        XCTAssertNil(stored.originalImagePath)
        XCTAssertNil(stored.processedImagePath)
        XCTAssertEqual(stored.name, "手录联系人")
        XCTAssertEqual(stored.mobiles, ["13800001111"])
        XCTAssertEqual(stored.group, "客户")
        XCTAssertEqual(try repository.allGroups(), ["客户"])
    }

    func testEmptyCardRequiresConfirmation() throws {
        let repository = InMemoryBusinessCardRepository()
        let viewModel = NewCardViewModel(repository: repository)

        viewModel.save()

        XCTAssertTrue(viewModel.showsEmptyWarning)
        XCTAssertFalse(viewModel.didSave)
        XCTAssertTrue(try repository.fetchAll().isEmpty)

        viewModel.save(force: true)

        XCTAssertTrue(viewModel.didSave)
        let stored = try XCTUnwrap(try repository.fetchAll().first)
        XCTAssertNil(stored.name)
        XCTAssertEqual(stored.displayTitle(), "未命名名片")
    }

    func testNoGroupKeepsNilGroup() throws {
        let repository = InMemoryBusinessCardRepository()
        let viewModel = NewCardViewModel(repository: repository)

        viewModel.name = "仅姓名"
        viewModel.save()

        let stored = try XCTUnwrap(try repository.fetchAll().first)
        XCTAssertNil(stored.group)
    }

    func testTagEditing() {
        let viewModel = NewCardViewModel(repository: InMemoryBusinessCardRepository())

        viewModel.newTag = " 会议 "
        viewModel.addTag()
        viewModel.addTag()

        XCTAssertEqual(viewModel.tags, ["会议"])

        viewModel.removeTag("会议")

        XCTAssertTrue(viewModel.tags.isEmpty)
    }
}
