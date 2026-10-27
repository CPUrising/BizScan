import XCTest
import SwiftData
import BizScanCore
@testable import BizScan

/// T18 的 L2 证据：真实落盘 + 同 URL 重建容器模拟 Kill App 重启。
@MainActor
final class PersistenceTests: XCTestCase {
    private func makeSchema() -> Schema {
        Schema([BusinessCardEntity.self, TagEntity.self])
    }

    private func reopenContainer(at url: URL) throws -> ModelContainer {
        let schema = makeSchema()
        return try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(schema: schema, url: url)
        )
    }

    func testT18DataSurvivesContainerReopen() throws {
        let pair = try TestSupport.makeTemporaryContainer()
        let directory = pair.directory
        defer { try? FileManager.default.removeItem(at: directory) }

        let url = directory.appendingPathComponent("store.sqlite")
        let imageStore = InMemoryImageStore()
        let card = BusinessCard(
            originalImagePath: "CardImages/original.jpg",
            processedImagePath: "CardImages/processed.jpg",
            name: "David Chen",
            company: "ABC Technologies",
            mobiles: ["+86 138 0000 0000"],
            emails: ["david.chen@example.com"],
            tags: ["Customer"],
            notes: "Follow up next week"
        )

        var container: ModelContainer? = pair.container
        var repository: SwiftDataBusinessCardRepository? = SwiftDataBusinessCardRepository(
            context: ModelContext(container!),
            imageStore: imageStore
        )
        try repository?.save(card)

        // 释放容器与仓库，等价于进程退出。
        repository = nil
        container = nil

        let reopened = try reopenContainer(at: url)
        let reopenedRepository = SwiftDataBusinessCardRepository(
            context: ModelContext(reopened),
            imageStore: imageStore
        )
        let restored = try XCTUnwrap(try reopenedRepository.fetch(id: card.id))

        XCTAssertEqual(restored.name, "David Chen")
        XCTAssertEqual(restored.company, "ABC Technologies")
        XCTAssertEqual(restored.mobiles, ["+86 138 0000 0000"])
        XCTAssertEqual(restored.emails, ["david.chen@example.com"])
        XCTAssertEqual(restored.tags, ["Customer"])
        XCTAssertEqual(restored.notes, "Follow up next week")
        XCTAssertEqual(restored.originalImagePath, "CardImages/original.jpg")
        XCTAssertEqual(restored.processedImagePath, "CardImages/processed.jpg")
    }

    func testT18TagsSurviveReopen() throws {
        let pair = try TestSupport.makeTemporaryContainer()
        let directory = pair.directory
        defer { try? FileManager.default.removeItem(at: directory) }

        let url = directory.appendingPathComponent("store.sqlite")

        var container: ModelContainer? = pair.container
        var repository: SwiftDataBusinessCardRepository? = SwiftDataBusinessCardRepository(
            context: ModelContext(container!),
            imageStore: InMemoryImageStore()
        )
        _ = try repository?.createTag("Conference")

        repository = nil
        container = nil

        let reopened = try reopenContainer(at: url)
        let reopenedRepository = SwiftDataBusinessCardRepository(
            context: ModelContext(reopened),
            imageStore: InMemoryImageStore()
        )

        XCTAssertEqual(try reopenedRepository.allTags(), ["Conference"])
    }

    func testFileImageStoreRoundTrip() throws {
        let store = FileImageStore()
        let image = TestSupport.makeImage(color: .red, size: CGSize(width: 1, height: 1))
        let data = try XCTUnwrap(image.jpegData(compressionQuality: 1))
        let cardID = UUID()

        let path = try store.saveImageData(data, cardID: cardID, kind: .original)
        defer { store.delete(relativePath: path) }

        XCTAssertEqual(path, "CardImages/\(cardID.uuidString)-original.jpg")
        XCTAssertNotNil(store.data(forRelativePath: path))
        XCTAssertNotNil(store.image(forRelativePath: path))

        store.delete(relativePath: path)

        XCTAssertNil(store.data(forRelativePath: path))
    }

    func testDeleteCardRemovesImageFiles() throws {
        let pair = try TestSupport.makeTemporaryContainer()
        let directory = pair.directory
        defer { try? FileManager.default.removeItem(at: directory) }

        let store = FileImageStore()
        let cardID = UUID()
        let data = try XCTUnwrap(
            TestSupport.makeImage(color: .blue, size: CGSize(width: 1, height: 1))
                .jpegData(compressionQuality: 1)
        )
        let originalPath = try store.saveImageData(data, cardID: cardID, kind: .original)
        let processedPath = try store.saveImageData(data, cardID: cardID, kind: .processed)

        let repository = SwiftDataBusinessCardRepository(
            context: ModelContext(pair.container),
            imageStore: store
        )
        let card = BusinessCard(
            id: cardID,
            originalImagePath: originalPath,
            processedImagePath: processedPath,
            name: "David Chen"
        )
        try repository.save(card)
        XCTAssertNotNil(store.data(forRelativePath: originalPath))

        try repository.delete(id: cardID)

        XCTAssertNil(try repository.fetch(id: cardID))
        XCTAssertNil(store.data(forRelativePath: originalPath))
        XCTAssertNil(store.data(forRelativePath: processedPath))
    }
}
