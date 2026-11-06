# Design

## Context

`BusinessCard.originalImagePath` 是必填 `String`，`SwiftDataBusinessCardRepository.delete` 直接用它删除文件，`DetailViewModel.image()` 与列表缩略图默认路径一定可读。手动新建需要「无图名片」，必须把这条不变量改成「有图必填、无图可空」。

## Decisions

### 1. `originalImagePath: String?`

- 初始化参数改为 `String?`，`BusinessCard(originalImagePath: "x.jpg")` 等既有调用保持编译
- 扫描保存链路在写入图片后赋值，非空；手动新建保持 `nil`
- 校验：模型不再保证非空，改为「扫描保存后的记录必须非空」由 `ReviewViewModelTests` 断言

### 2. 无图分支

| 位置 | 行为 |
|---|---|
| `SwiftDataBusinessCardRepository.delete` | `if let path { imageStore.delete(path) }` |
| `HomeViewModel.thumbnail` / `SearchViewModel.thumbnail` | 路径为空直接返回 `nil`，由 `CardRowView` 显示占位 |
| `DetailViewModel.image()` | 路径为空返回 `nil` |
| `DetailView` | 无图时不渲染顶部图片区；0020 的「查看原图」入口同样按 nil 隐藏 |

### 3. 新建表单

`NewCardViewModel` 复用编辑页字段集合，额外支持分组；保存时：

```swift
var card = BusinessCard(originalImagePath: nil, createdAt: Date())
card.name = ...
card.group = normalizedGroup
try repository.save(card)
```

- 空卡判定与 `ReviewViewModel` 一致（所有结构化字段为空）
- 空卡保存先弹二次确认，确认后仍保存为「未命名名片」
- 标签保留编辑能力，但主页/详情不展示（沿用 0017）

### 4. 入口

主页标题栏右侧新增 `+`（0019 再按设计稿改为 40×40 圆角按钮）；底部 FAB 仍是拍摄入口，两者语义分离。

### 5. 迁移

`originalImagePath` 从非可选改为可选属于轻量迁移；旧记录全部有值，读取不受影响。回滚版本忽略空值记录即可。

## Risks / Trade-offs

- **公开接口变更**：`BusinessCard` 的存储属性类型变化，需全仓编译验证；已确认所有字符串写入点仍然兼容。
- **无图名片导出**：vCard 不含图片，T19 不受影响。
- **列表缩略图占位**：`CardRowView` 已有占位逻辑，无图不会崩溃。

## Migration Plan

1. 旧 store 启动，断言既有名片 `originalImagePath` 仍有值
2. 手动新建无图名片 → terminate → relaunch，断言记录仍在且详情不崩溃
3. 删除无图名片，断言不因空路径删除异常

## Open Questions

无。
