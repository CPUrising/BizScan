import XCTest
import BizScanCore
@testable import BizScan

@MainActor
final class GroupViewModelTests: XCTestCase {
    private func makeCard(name: String, group: String?) -> BusinessCard {
        BusinessCard(originalImagePath: "CardImages/\(name).jpg", name: name, group: group)
    }

    func testReloadBuildsCounts() {
        let repository = InMemoryBusinessCardRepository(
            cards: [
                makeCard(name: "Alice", group: "客户"),
                makeCard(name: "Bob", group: "客户"),
                makeCard(name: "Carol", group: nil)
            ],
            groups: ["客户", "空分组"]
        )
        let viewModel = GroupViewModel(repository: repository)

        viewModel.reload()

        XCTAssertEqual(viewModel.totalCount, 3)
        XCTAssertEqual(viewModel.count(for: nil), 3)
        XCTAssertEqual(viewModel.count(for: "客户"), 2)
        XCTAssertEqual(viewModel.count(for: "空分组"), 0)
    }

    func testCreateGroupReusesExistingName() {
        let repository = InMemoryBusinessCardRepository(groups: ["客户"])
        let viewModel = GroupViewModel(repository: repository)

        let created = viewModel.create(" 客户 ")

        XCTAssertEqual(created, "客户")
        XCTAssertEqual(viewModel.groups, ["客户"])
    }

    func testRenameDuplicateReportsError() {
        let repository = InMemoryBusinessCardRepository(groups: ["客户", "合作伙伴"])
        let viewModel = GroupViewModel(repository: repository)
        viewModel.reload()

        viewModel.rename("客户", to: "合作伙伴")

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.groups, ["合作伙伴", "客户"])
    }

    func testDeleteGroupReloadsCounts() {
        let repository = InMemoryBusinessCardRepository(
            cards: [makeCard(name: "Alice", group: "客户")],
            groups: ["客户"]
        )
        let viewModel = GroupViewModel(repository: repository)
        viewModel.reload()

        viewModel.delete("客户")

        XCTAssertEqual(viewModel.totalCount, 1)
        XCTAssertEqual(viewModel.count(for: nil), 1)
        XCTAssertTrue(viewModel.groups.isEmpty)
    }
}
