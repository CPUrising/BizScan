# Tasks

## 1. 数据模型与迁移

- [x] 1.1 `Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift`：新增 `group: String?`（默认 `nil`）
- [x] 1.2 `BizScan/Models/BusinessCardEntity.swift`：新增 `groupName: String?`，并在 `init` / `apply` / `domainModel` 三个方向同步
- [x] 1.3 新增 `CardGroupEntity`（`name` 唯一、`createdAt`），在 `BizScan/App/BizScanApp.swift` 的容器 schema 中注册
- [x] 1.4 `BizScanTests/PersistenceTests.swift`：旧数据重建容器后 `group == nil`，分组实体可读写

## 2. 仓储

- [x] 2.1 `BusinessCardRepository` 协议新增 `allGroups` / `createGroup` / `renameGroup` / `deleteGroup` / `setGroup(cardID:to:)` / `fetchCards(group:)`
- [x] 2.2 `SwiftDataBusinessCardRepository` 实现（trim + 半角化 + 大小写不敏感去重；删除分组把名片 `group` 置 `nil`）
- [x] 2.3 `InMemoryBusinessCardRepository` 同步实现
- [x] 2.4 `RepositoryTests`：分组 CRUD、重名、删除后归属清空、`fetchCards(group:)`

## 3. 分组管理

- [x] 3.1 新增 `BizScan/ViewModels/GroupViewModel.swift`（分组列表、计数、新建、重命名、删除、当前筛选）
- [x] 3.2 新增 `BizScan/Views/GroupManagementView.swift`（列表 + 新建 + 左滑重命名/删除 + 点击查看）
- [x] 3.3 `BizScanTests/GroupViewModelTests.swift`：新建/重名/重命名/删除/选中态重置

## 4. 主页

- [x] 4.1 `HomeViewModel`：`selectedTag` 改为 `selectedGroup`，`groupedCards` 按当前分组过滤并给出计数
- [x] 4.2 `HomeView`：移除标签胶囊条，改为分组行（分组名 + 数量 + 「分组管理」入口）
- [x] 4.3 分组删除后若正处于该分组，筛选重置为「全部名片」

## 5. 详情

- [x] 5.1 `DetailView`：新增分组行（`user-round` 图标 + 名称，空显示「未分组」）
- [x] 5.2 `DetailViewModel`：暴露 `groupDisplayName`

## 6. 测试

- [x] 6.1 `BizScanUITests/CardListUITests.swift`：T21 创建分组并筛选、T22 删除分组回到未分组
- [x] 6.2 `BizScanUITests/DetailUITests.swift`：T23 详情展示分组
- [x] 6.3 调整 `SearchTagsUITests.testT16` 为「编辑页保留标签」

## 7. 文档

- [x] 7.1 `docs/traceability.md`：更新 T16，新增 T21–T23
- [x] 7.2 `docs/verify/0017-card-grouping.md`：逐条场景 PASS/FAIL
- [x] 7.3 `README.md`：阶段看板记录 0017

## 8. 校验

- [x] 8.1 `openspec validate 0017-card-grouping --strict`
- [x] 8.2 `bash scripts/verify.sh --change 0017-card-grouping`
