# Design

## Context

`BusinessCard` 目前用 `tags: [String]` 表达组织关系，主页 `HomeViewModel.selectedTag` 过滤，`HomeView.tagBar` 以胶囊展示。新稿要求单一分组语义：

- 主页：「全部名片 2」+「分组管理」入口；分组即筛选器
- 详情：「未分组」独立行
- 分组管理：新稿未提供页面，需要自绘

## Decisions

### 1. 分组用单一可空字符串，而不是复用 tags

`BusinessCard.group: String?`，`nil` = 未分组。理由：设计语义是「一张名片只属一个分组」；复用 tags 在「一卡多标签」时无法确定展示哪一个。

标签继续保留在模型与编辑页，只是不再作为主页/详情展示与筛选入口。

### 2. 独立 `CardGroupEntity` 保存分组清单

只从名片反推分组会导致「新建但还没放名片的分组」消失，也无法重命名。新增：

```swift
@Model final class CardGroupEntity {
    @Attribute(.unique) var name: String
    var createdAt: Date
}
```

- `createGroup(name)`：trim + 半角化 + 大小写不敏感去重，空名抛 `RepositoryError.emptyGroup`
- `renameGroup(from:to:)`：目标名已存在时抛 `RepositoryError.duplicateGroup`，不静默合并
- `deleteGroup(name)`：删除分组记录，并把该组名片的 `group` 置为 `nil`（回到未分组）
- `setGroup(cardID:to:)`：`nil`/空串 = 未分组
- `allGroups()`：按名称升序返回 `CardGroupEntity`
- `fetchCards(group:)`：`nil` 返回全部

### 3. 迁移

新增 `groupName: String?`（默认 `nil`）与新增实体，属于 SwiftData 轻量迁移。沿用 `0016` 的容器重建测试：旧数据打开后 `group == nil`（未分组），无崩溃。

### 4. 主页筛选状态

`HomeViewModel.selectedGroup: String?` 替代 `selectedTag`：

- `nil` = 全部名片
- 非 `nil` = 只显示 `card.group == 该分组`
- 分组被删除后，若当前选中该分组，重置为 `nil`
- 计数：当前分组的名片数

0017 只做行为与最小组件，主页整体视觉（颜色/字体/间距/FAB）留给 0019；分组行先沿用现有 `List` 的 section header 位置，保证功能可验收。

### 5. 分组管理页

无设计稿，采用与新稿一致的深色令牌（0019 落地主题后统一替换为 `Theme`）：分组列表 + 数量、顶部「新建分组」、左滑重命名/删除、点击进入该分组的名片列表（复用主页筛选）。本次只实现必要交互，不做排序/颜色/图标。

### 6. T16 合同调整

`search-tags` 的 T16 原为「添加标签并按标签筛选」。新稿移除标签筛选入口，改为：

- T16「添加标签并保留在编辑页」：编辑页可创建/删除标签，保存后重新打开仍在
- 分组筛选由新场景 T21 覆盖

## Risks / Trade-offs

- **数据语义变化**：已有 `tags` 不会自动变成 `group`，老用户升级后全部为「未分组」。本次不做自动映射（标签是多值，映射规则不可判定），在迁移说明中记录。
- **T16 合同变化**：属于行为变更，已在 `search-tags` 写 `## MODIFIED`。
- **0019 会重写主页**：0017 的分组行是功能性中间态，视觉在 0019 统一。
- **删除分组不可撤销**：名片不会丢，只回到未分组；UI 需二次确认。

## Migration Plan

1. 新增字段与实体后，用旧 store 启动一次，断言名片可读且 `group == nil`
2. 保存/重命名/删除分组后 terminate → relaunch，断言分组与归属仍在
3. 回滚策略：只新增可空字段与实体，不删除旧字段；回退版本忽略新字段即可

## Open Questions

无。
