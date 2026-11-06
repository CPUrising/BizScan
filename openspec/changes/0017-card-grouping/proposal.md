# Proposal

## Why

新稿在主页用「当前分组 + 名片数量 + 分组管理」组织名片，详情页展示「未分组 / 分组名」。现有实现只有多标签（`tags`），主页是标签胶囊筛选条，无法表达「一张名片只属于一个分组」的语义，也没有分组管理入口。

## What Changes

- `BusinessCard` 新增 `group: String?`（`nil` = 未分组），`BusinessCardEntity` 新增 `groupName: String?`
- 新增 `CardGroupEntity`，用于保存空分组（尚无名片的分组）并支持重命名/删除
- 仓储新增分组 CRUD：`allGroups`、`createGroup`、`renameGroup`、`deleteGroup`、`setGroup(cardID:to:)`、`fetchCards(group:)`
- 主页新增分组行（「全部名片」+ 数量 + 「分组管理」入口），筛选来源由标签改为分组；标签胶囊条移除
- 新增「分组管理」页：新建、重命名、删除、按分组查看
- 详情页展示分组行
- 标签保留数据与编辑能力，但主页/详情不再展示与筛选

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-list`：新增「按分组筛选名片」需求
- `card-detail`：新增「详情展示分组」需求
- `search-tags`：标签管理改为「仅编辑、不作为主页筛选入口」，T16 场景同步调整

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift`、`BizScan/Models/BusinessCardEntity.swift`、`BizScan/Repositories/*`、`BizScan/ViewModels/HomeViewModel.swift`、`BizScan/Views/HomeView.swift`、`BizScan/Views/DetailView.swift`、新增 `Views/GroupManagementView.swift`、`ViewModels/GroupViewModel.swift`、`App/BizScanApp.swift`（容器 schema）
- 测试：`BizScanTests/RepositoryTests.swift`、`HomeViewModelTests.swift`、新增 `GroupViewModelTests.swift`、`BizScanUITests/CardListUITests.swift`
- 文档：`docs/traceability.md`（T16、T21–T23）、`docs/verify/0017-card-grouping.md`、`README.md`
- 行为：主页筛选从标签改为分组；标签不再出现在主页/详情
- 不在范围：主页/详情视觉重构（0019/0020）、手动新建（0018）、收藏（0020）、系统通讯录（0022）
