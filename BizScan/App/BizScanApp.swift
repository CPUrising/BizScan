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
            let container = makeInMemoryContainer()
            if arguments.contains("-ui-testing-seed") {
                seed(container)
            }
            return container
        }

        do {
            return try ModelContainer(for: BusinessCardEntity.self, TagEntity.self)
        } catch {
            return makeInMemoryContainer()
        }
    }

    /// UI 测试用的确定性数据；只在内存容器中写入，不影响真实用户数据。
    private static func seed(_ container: ModelContainer) {
        let context = ModelContext(container)
        let cards = [
            BusinessCard(
                originalImagePath: "seed/david.jpg",
                name: "David Chen",
                company: "ABC Technologies",
                jobTitle: "Technical Director",
                mobiles: ["+86 138 0000 0000"],
                officePhones: ["021-8888-0000"],
                emails: ["david.chen@example.com"],
                website: "example.com",
                tags: ["Customer"]
            ),
            BusinessCard(
                originalImagePath: "seed/zhu.jpg",
                name: "朱宏明",
                company: "同济大学",
                jobTitle: "教授",
                mobiles: ["139 0000 0000"],
                emails: ["zhu@example.edu"],
                tags: ["Professor"]
            ),
            BusinessCard(
                originalImagePath: "seed/alice.jpg",
                name: "Alice Wu",
                company: "Northwind Studio",
                jobTitle: "Designer",
                emails: ["alice@example.com"],
                notes: "Follow up next week",
                tags: ["Partner"]
            )
        ]

        var insertedTags: Set<String> = []
        for card in cards {
            context.insert(BusinessCardEntity(card: card))
            for tag in card.tags where !insertedTags.contains(tag.lowercased()) {
                context.insert(TagEntity(name: tag))
                insertedTags.insert(tag.lowercased())
            }
        }
        try? context.save()
    }

    private static func makeInMemoryContainer() -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(
                for: BusinessCardEntity.self,
                TagEntity.self,
                configurations: configuration
            )
        } catch {
            fatalError("无法创建 SwiftData 容器：\(error)")
        }
    }
}
