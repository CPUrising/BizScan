import SwiftUI
import SwiftData
import BizScanCore

@main
struct BizScanApp: App {
    private let container: ModelContainer
    private let environment: AppEnvironment

    init() {
        let container = BizScanApp.makeContainer()
        self.container = container

        let context = ModelContext(container)
        self.environment = AppEnvironment(
            repository: SwiftDataBusinessCardRepository(context: context),
            imageStore: FileImageStore()
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
        }
        .modelContainer(container)
    }

    private static func makeContainer() -> ModelContainer {
        let arguments = ProcessInfo.processInfo.arguments

        if arguments.contains("-ui-testing") {
            if arguments.contains("-ui-testing-persistent") {
                return makePersistentTestContainer(
                    reset: arguments.contains("-ui-testing-reset"),
                    shouldSeed: arguments.contains("-ui-testing-seed")
                )
            }
            let container = makeInMemoryContainer()
            if arguments.contains("-ui-testing-seed") {
                seed(container)
            }
            return container
        }

        do {
            try ensureApplicationSupportDirectory()
            return try ModelContainer(for: BusinessCardEntity.self, TagEntity.self, CardGroupEntity.self)
        } catch {
            fatalError("无法创建 SwiftData 容器：\(error)")
        }
    }

    @discardableResult
    private static func ensureApplicationSupportDirectory() throws -> URL {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private static func makePersistentTestContainer(reset: Bool, shouldSeed: Bool) -> ModelContainer {
        let directory: URL
        do {
            directory = try ensureApplicationSupportDirectory()
        } catch {
            fatalError("无法准备 UI 测试存储目录：\(error)")
        }

        let storeURL = directory.appendingPathComponent("BizScanUITests.store")

        if reset {
            for suffix in ["", "-shm", "-wal"] {
                try? FileManager.default.removeItem(at: URL(fileURLWithPath: storeURL.path + suffix))
            }
        }

        let schema = Schema([BusinessCardEntity.self, TagEntity.self, CardGroupEntity.self])
        let configuration = ModelConfiguration(schema: schema, url: storeURL)
        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            if shouldSeed {
                seed(container)
            }
            return container
        } catch {
            fatalError("无法创建 UI 测试 SwiftData 容器：\(error)")
        }
    }

    /// UI 测试用的确定性数据；只写入内存容器或专用测试 store，不影响真实用户数据。
    private static func seed(_ container: ModelContainer) {
        let context = ModelContext(container)
        func seedDate(day: Int) -> Date {
            Calendar.current.date(
                from: DateComponents(year: 2026, month: 10, day: day, hour: 10)
            ) ?? Date()
        }
        let davidID = UUID(uuidString: "11111111-1111-1111-1111-111111111111") ?? UUID()
        let zhuID = UUID(uuidString: "22222222-2222-2222-2222-222222222222") ?? UUID()
        let aliceID = UUID(uuidString: "33333333-3333-3333-3333-333333333333") ?? UUID()
        let davidImagePath = seedCardImage(cardID: davidID)
        let cards = [
            BusinessCard(
                id: davidID,
                originalImagePath: davidImagePath,
                name: "David Chen",
                company: "ABC Technologies",
                jobTitle: "Technical Director",
                mobiles: ["+86 138 0000 0000"],
                officePhones: ["021-8888-0000"],
                emails: ["david.chen@example.com"],
                website: "example.com",
                tags: ["Customer"],
                group: "客户",
                createdAt: seedDate(day: 26)
            ),
            BusinessCard(
                id: zhuID,
                originalImagePath: "seed/zhu.jpg",
                name: "朱宏明",
                company: "同济大学",
                jobTitle: "教授",
                mobiles: ["139 0000 0000"],
                emails: ["zhu@example.edu"],
                tags: ["Professor"],
                createdAt: seedDate(day: 27)
            ),
            BusinessCard(
                id: aliceID,
                originalImagePath: "seed/alice.jpg",
                name: "Alice Wu",
                company: "Northwind Studio",
                jobTitle: "Designer",
                emails: ["alice@example.com"],
                tags: ["Partner"],
                group: "合作伙伴",
                notes: "Follow up next week",
                createdAt: seedDate(day: 27)
            )
        ]

        var insertedTags: Set<String> = []
        var insertedGroups: Set<String> = []
        for card in cards {
            context.insert(BusinessCardEntity(card: card))
            for tag in card.tags where !insertedTags.contains(tag.lowercased()) {
                context.insert(TagEntity(name: tag))
                insertedTags.insert(tag.lowercased())
            }
            if let group = card.group, !insertedGroups.contains(group.lowercased()) {
                context.insert(CardGroupEntity(name: group))
                insertedGroups.insert(group.lowercased())
            }
        }
        try? context.save()
    }

    /// 为 UI 测试生成一张确定性的名片图，用于覆盖「查看原图」。
    private static func seedCardImage(cardID: UUID) -> String? {
        let size = CGSize(width: 600, height: 380)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34, weight: .semibold),
                .foregroundColor: UIColor.black
            ]
            NSString(string: "DAVID CHEN").draw(at: CGPoint(x: 32, y: 32), withAttributes: attributes)
            NSString(string: "ABC Technologies").draw(
                at: CGPoint(x: 32, y: 84),
                withAttributes: attributes
            )
        }
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        return try? FileImageStore().saveImageData(data, cardID: cardID, kind: .original)
    }

    private static func makeInMemoryContainer() -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(
                for: BusinessCardEntity.self,
                TagEntity.self,
                CardGroupEntity.self,
                configurations: configuration
            )
        } catch {
            fatalError("无法创建 SwiftData 容器：\(error)")
        }
    }
}
