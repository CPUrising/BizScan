# Proposal

## Why

新稿主页标题栏右侧有「+」按钮，语义是手动新建名片，而不是再次进入拍摄流程。现有模型把 `originalImagePath` 定义为必填字符串，导致「没有照片的名片」无法表达；用户收到电子名片或口头信息时只能先拍一张无关照片。

## What Changes

- `BusinessCard.originalImagePath` / `BusinessCardEntity.originalImagePath` 改为 `String?`；有图流程仍必须写入路径，手动新建允许为 `nil`
- 无图分支：删除时跳过图片清理、列表使用占位缩略图、详情不展示图片与「查看原图」
- 新增 `NewCardView` / `NewCardViewModel`，支持姓名/公司/职位/部门/电话/邮箱/网址/地址/邮编/备注/分组/标签
- 主页标题栏新增「+」入口，打开手动新建表单
- 空名片保存沿用二次确认

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-model`：`originalImagePath` 由必填改为「有图必填、无图可空」
- `card-list`：新增「手动新建名片」需求

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift`、`BizScan/Models/BusinessCardEntity.swift`、`BizScan/Repositories/SwiftDataBusinessCardRepository.swift`、`BizScan/ViewModels/{Home,Search,Detail,Review,NewCard}ViewModel.swift`、`BizScan/Views/NewCardView.swift`、`BizScan/Views/HomeView.swift`、`BizScan/App/AppCopy.swift`
- 测试：`ReviewViewModelTests`、`PersistenceTests`、新增 `NewCardViewModelTests`、`BizScanUITests/CardListUITests.swift`
- 文档：`docs/traceability.md`（T34–T35）、`docs/verify/0018-manual-card-create.md`、`README.md`
- 不在范围：主页/详情视觉重构（0019/0020）、为手动名片补拍照片、OCR 链路
