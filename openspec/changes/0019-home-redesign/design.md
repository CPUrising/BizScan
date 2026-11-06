# Design

## Context

Figma 主页两张画板（空 / 有名片）为 390×844：状态栏 54、标题栏 58、搜索 46、分组行 62、列表行 108、FAB 68。现有 `HomeView` 使用系统 `List` 与导航栏，行高、缩略图、字号均与稿不同。

## Decisions

### 1. 设计令牌

新增 `Theme`，只放主页/详情共用的深色令牌：

```swift
enum Theme {
    enum ColorToken {
        static let page = Color(hex: 0x191919)
        static let pageDetail = Color(hex: 0x171819)
        static let surface = Color(hex: 0x202123)
        static let field = Color(hex: 0x252525)
        static let control = Color(hex: 0x2B2B2B)
        static let dividerStrong = Color(hex: 0x333538)
        static let dividerWeak = Color(hex: 0x2B2B2B)
        static let textPrimary = Color(hex: 0xF1F1F1)
        static let textPrimaryDetail = Color(hex: 0xF5F6F7)
        static let textSecondary = Color(hex: 0xA0A0A0)
        static let textSecondaryDetail = Color(hex: 0xB5B8BD)
        static let textTertiary = Color(hex: 0x777777)
        static let textTertiaryDetail = Color(hex: 0x858A91)
        static let blue = Color(hex: 0x3478F6)
        static let green = Color(hex: 0x42AD73)
        static let amber = Color(hex: 0xE7AB52)
        static let purple = Color(hex: 0x9A7BDB)
    }
}
```

字体使用系统苹方 + SF Pro：通过 `.font(.system(size:weight:))` 指定字号/字重，不打包字体。

### 2. 自定义头部与隐藏系统导航栏

- `NavigationStack` 保留，用于 push 详情与搜索
- 根视图 `.toolbar(.hidden, for: .navigationBar)`
- 头部：`.safeAreaInset(edge: .top)` 或 VStack 顶部，标题 26/700，`+` 40×40 r13（`#2B2B2B`）
- 详情页在 0020 会自绘顶栏；过渡期在 `DetailView` 显式 `.toolbar(.visible, for: .navigationBar)`，保证 T13/T14 可用

### 3. 日期分组

`HomeViewModel.sections: [CardSection]`，`CardSection { day: Date, title: String, cards: [BusinessCard] }`：

- 过滤条件：`selectedGroup`（0017）
- 排序：`createdAt` 倒序（同一天内保持 `createdAt` 倒序）
- 分组键：`Calendar.current.startOfDay(for:)`，标题 `yyyy-MM-dd`
- `reload` 时重建 sections

### 4. 列表行

`CardListRow`：

- 高 108，水平内边距 20，gap 12
- 缩略图 98×64 r7，`scaledToFill` + `clipped`；无图显示 `person.text.rectangle` 占位（`#2B2B2B` 底 + `#777777` 图标）
- 文本：姓名 19/500 `#F1F1F1`；第二行职位 14 `#A0A0A0`；第三行公司 14 `#A0A0A0`，最多两行副标题
- 右侧 `…` 20pt `#A0A0A0`，打开菜单（移动到分组 / 删除）
- 行间分隔线 1px `#2B2B2B`，左右内缩 20

### 5. 空状态与 FAB

- 空状态：64×48 线稿图标（`person.text.rectangle`，描边 `#626262`）+ 「点击下方相机拍摄您的第一张名片」14 `#A0A0A0`，垂直居中
- FAB：68×68 圆，`#3478F6`，白色相机图标 30pt，底部居中，`padding(.bottom, 22)`
- 移除右下角旧 FAB 与空状态按钮

### 6. 搜索与入口

- 搜索框是按钮，点击 push `SearchView`（复用 0017 的 `sheet` 改为 `navigationDestination` 或继续 sheet；本次保持 sheet，避免改动搜索栈）
- `+` 打开 `NewCardView`（0018）

### 7. 深色

`RootView` 或 `WindowGroup` 施加 `.preferredColorScheme(.dark)`；设计未提供浅色稿。

## Risks / Trade-offs

- **标题变更影响 UI 测试**：所有 `launchSeeded()` 等待「名片夹」导航栏的用例要改为等待「名片」标题或 `+` 按钮；属于行为变更，已在规范中同步。
- **隐藏系统导航栏**：详情页依赖显式 `.toolbar(.visible)`；0020 改为自绘顶栏后移除。
- **日期分组与旧排序契约冲突**：`card-model` 的展示排序改为 `createdAt`，编辑不再使名片前移；已写 MODIFIED。
- **列表从 `List` 改为 `ScrollView`**：失去系统左滑删除，改为行菜单删除；T17 用例需改为通过菜单删除。

## Migration Plan

无数据迁移；仅展示层变化。

## Open Questions

无。
