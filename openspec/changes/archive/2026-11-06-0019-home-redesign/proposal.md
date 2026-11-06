# Proposal

## Why

主页当前是系统 `NavigationStack + List` 的默认外观：大标题「名片夹」、右上放大镜、标签胶囊、右下系统色 FAB、系统空状态。Figma 新稿是完全自定义的深色列表，包含常驻搜索框、分组行、按创建日期分组的卡片行、底部居中蓝色 FAB 和新的空状态。0017/0018 只补齐了行为，视觉仍是旧样式。

## What Changes

- 新增 `DesignSystem/Theme.swift`：颜色、字号、间距、圆角令牌（仅深色）
- 主页改为自定义头部：标题「名片」26/700 + 40×40「+」按钮
- 常驻搜索框（350×46，`#252525`，r12），点击进入搜索页
- 分组行：当前分组名 + 数量 + 「分组管理」入口
- 列表改为 `ScrollView + LazyVStack`：按 `createdAt` 日期倒序分组，行高 108，缩略图 98×64，姓名 19/500，职位/公司最多两行，右侧 `…` 菜单
- 空状态改为线稿图标 + 一行提示，不再提供按钮
- 扫描入口改为底部居中 68pt 蓝色圆钮（`#3478F6`）
- 强制深色外观
- 标题由「名片夹」改为「名片」

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-list`：列表展示改为按创建日期分组；首次启动空状态与扫描入口改为常驻 FAB；新增日期分组与深色外观需求
- `card-model`：展示层排序由 `updatedAt` 改为 `createdAt`

## Impact

- 代码：新增 `BizScan/Views/DesignSystem/Theme.swift`、`BizScan/Views/Components/CardListRow.swift`、`HomeEmptyState.swift`；重写 `BizScan/Views/HomeView.swift`、`BizScan/Views/Components/CardRowView.swift`；`HomeViewModel` 增加日期分组；`AppCopy` 更新标题
- 测试：`HomeViewModelTests`（排序/分组）、`CardListUITests` / `LaunchUITests` / `SearchTagsUITests` / `DetailUITests` / `CaptureUITests` / `DetectionUITests` / `PersistenceUITests` 的启动等待条件与标题断言
- 文档：`docs/traceability.md`（T01/T24/T25）、`docs/verify/0019-home-redesign.md`、`README.md`
- 不在范围：详情页视觉（0020）、浅色主题、搜索页视觉重做
