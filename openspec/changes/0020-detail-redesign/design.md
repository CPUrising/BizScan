# Design

## Context

Figma `5:863`（390×900）：顶栏 92（蓝色 `#176FD1`）；核心卡 `#202123` padding 28/24/24/24 gap19；头像 66 `#42AD73`；快捷按钮 48（绿/蓝/琥珀/紫）；分段条 8；分组行 56；备注区 padding 18/24/20/24；联系方式条目间距与 1px `#333538` 分隔；底部按钮 342×47 r12 `#42AD73`。

现有 `DetailView` 用 `List(.insetGrouped)`，依赖系统导航栏，`isEditing` 以 sheet 呈现编辑表单。

## Decisions

### 1. 结构

```
ZStack(顶部内容滚动) + safeAreaInset(bottom: 底部按钮)
  ├─ 顶栏（固定，蓝色，返回/标题/星标/更多）
  └─ ScrollView
      ├─ 核心资料卡（头像、姓名、职务、公司、查看原图、4 快捷操作）
      ├─ 8pt 间隔
      ├─ 分组行
      ├─ 备注区（有备注才显示）
      ├─ 8pt 间隔
      ├─ 联系方式区（电话/办公/传真/邮箱/网址/地址/邮编）
      └─ 8pt 间隔
```

顶栏用 `VStack` 置于滚动区之上（非 `safeAreaInset`），避免滚动时被内容覆盖；`.toolbar(.hidden, for: .navigationBar)`。

### 2. 收藏

`BusinessCard.isFavorite: Bool`（默认 false），`BusinessCardEntity.isFavorite: Bool`。ViewModel：

```swift
func toggleFavorite() {
    guard var card else { return }
    card.isFavorite.toggle()
    try repository.save(card)   // 失败回滚
    self.card = card
}
```

星标 `star` / `star.fill`（填充色 `#F5F6F7`）。0019 的主页行菜单暂不加收藏项（无设计稿）。

### 3. 联系方式行

由 `DetailViewModel.contactEntries` 生成：

```swift
struct ContactEntry: Identifiable {
    enum Kind { case mobile, officePhone, fax, email, website, address, postalCode }
    let kind: Kind
    let value: String
    var badge: String?   // Mobile / 办公 / 传真
    var actionURL: URL?  // tel: / mailto: / https: / maps:
    var allowsInlineEdit: Bool  // 电话类
}
```

- 图标：phone / mail / globe / map-pin
- 字段名：手机 / 办公电话 / 传真 / Email / 网址 / 地址 / 邮编
- 胶囊底色 `#292B2E`，文字 `#B5B8BD` 12
- 值点击执行 `openURL`；行业务要求保持在本页（系统负责返回）
- 铅笔仅电话类显示（与稿一致），点击打开编辑 sheet

### 4. 快捷操作

| 按钮 | 行为 | 不可用时 |
|---|---|---|
| 电话 | 第一个有效号码 `tel://` | 置灰并禁用 |
| 地址 | `maps://?q=<encoded>` | 置灰并禁用 |
| 备注 | `ScrollViewReader` 滚动到备注锚点 | 有备注才可点 |
| 编辑 | 打开 `EditCardView` | 始终可用 |

### 5. 查看原图

`CardImageViewer`：`fullScreenCover`，黑色背景，`MagnificationGesture` + `DragGesture`（下滑超过 120 关闭），点击关闭；优先 `processedImagePath`，回退 `originalImagePath`，都为 nil 时不显示入口。

### 6. 编辑表单

沿用 `EditCardView`（Form），保留标签编辑（0017 决定）。表单里 `isFavorite` 不暴露。

### 7. 底部按钮

`safeAreaInset(edge: .bottom)`，`#202123` 底 + 342×47 r12 `#42AD73`，标题「存入通讯录」。本次 `disabled(true)` 并在 0022 接线；禁用态改用 `#42AD73` 40% 不透明度。

## Risks / Trade-offs

- **自绘顶栏后返回手势**：`toolbar(.hidden)` 会关闭系统右滑返回；保留自定义返回按钮，需在测试中明确（T26 用返回按钮）。
- **`isFavorite` 新增字段**：SwiftData 轻量迁移，默认 false。
- **详情页高度超过 844**：内容滚动 + 固定底栏，顶栏固定。
- **待核对胶囊**：0021 前不显示，故与稿有一处差异，已在验证报告中登记。

## Migration Plan

新增可空/带默认值字段，旧数据读取为 `isFavorite = false`；沿用 `0016` 的容器重启测试。

## Open Questions

无。
