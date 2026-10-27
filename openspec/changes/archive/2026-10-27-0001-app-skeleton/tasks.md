# Tasks

## 1. 工程与依赖

- [x] 1.1 编写 `project.yml`（iOS 17、SwiftUI、XcodeGen、本地 SwiftPM 包依赖）
- [x] 1.2 编写 `Packages/BizScanCore/Package.swift` 与核心模型骨架
- [x] 1.3 建立 `BizScan/{App,Models,ViewModels,Views,Services,Repositories}` 分层目录
- [x] 1.4 在 `scripts/verify.sh` 与 CI 中加入 `swift test` 步骤

## 2. 数据层

- [x] 2.1 实现 `BusinessCardEntity`、`TagEntity` 及 `BusinessCard` 映射
- [x] 2.2 实现 `ImageStoring` / `FileImageStore` / `InMemoryImageStore`
- [x] 2.3 实现 `BusinessCardRepository` 协议与内存实现
- [x] 2.4 实现 `SwiftDataBusinessCardRepository`（保存、删除、标签增删）

## 3. 界面骨架

- [x] 3.1 实现 `AppEnvironment` 依赖容器与 `BizScanApp` 启动装配
- [x] 3.2 实现名片夹首页：列表、空态、标签筛选、删除确认、扫描入口
- [x] 3.3 实现详情页：字段展示、编辑、删除、导出入口
- [x] 3.4 实现搜索页与导航（`NavigationStack` + `navigationDestination`）
- [x] 3.5 为 `-ui-testing` 提供内存容器，保证首次启动为空态

## 4. 测试

- [x] 4.1 `BizScanTests/RepositoryTests.swift`：保存/排序/删除/标签
- [x] 4.2 `BizScanUITests/LaunchUITests.swift`：T01 首次启动空名片夹
- [ ] 4.3 在 macOS/CI 执行 `bash scripts/verify.sh --scope unit --change 0001-app-skeleton`
- [ ] 4.4 在 macOS/CI 执行 `bash scripts/verify.sh --scope ui --change 0001-app-skeleton`
- [ ] 4.5 回填 `docs/verify/0001-app-skeleton.md`，逐条标注 T12/T13 相关场景结果

## 5. 收尾

- [ ] 5.1 更新 `docs/traceability.md` 中 T01/T12/T13 的状态
- [ ] 5.2 验证通过后执行 `openspec archive 0001-app-skeleton`
