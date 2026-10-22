import SwiftUI
import SwiftData

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
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            return makeInMemoryContainer()
        }

        do {
            return try ModelContainer(for: BusinessCardEntity.self, TagEntity.self)
        } catch {
            return makeInMemoryContainer()
        }
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
