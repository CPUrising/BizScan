# Proposal

## Why

完成保存后，如果无法搜索、分类或删除，名片夹只是一个只增不减的列表，无法形成"重新打开与管理"的闭环。本 change 补齐 T15–T17 要求的管理能力。

## What Changes

- 新增 `SearchQuery`（BizScanCore）：多字段包含匹配、号码格式无关匹配。
- 新增 `SearchViewModel` / `SearchView`：搜索入口、空结果、返回详情。
- 名片夹支持按标签筛选；详情与校正页支持新增/移除标签。
- 删除名片时同步清理图像文件并从列表移除。
- 备注支持新增、编辑与清空。

不包含：拼音搜索、模糊纠错、标签重命名。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/search-tags`、`card-list`、`card-detail` 的既有行为合同。

### Modified Capabilities

无。

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/SearchQuery.swift`、`BizScan/ViewModels/{HomeViewModel,SearchViewModel}.swift`、`BizScan/Views/{HomeView,SearchView}.swift`
- 数据：`TagEntity` 的创建、删除与名片标签同步
- 测试：`SearchQueryTests`、`RepositoryTests`、`SearchTagsUITests`（待补）
