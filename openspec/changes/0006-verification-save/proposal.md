# Proposal

## Why

识别结果具有概率性，直接落库会把错误变成"可信数据"。必须在保存前强制人工确认，并保证原始图、校正图、字段、标签与备注一起持久化，才能通过 T11、T12、T18 与 `要求/01.md` 第九章的要求。

## What Changes

- 新增 `ReviewViewModel` / `ReviewView`：字段预填、可编辑、待定区展示、标签编辑、空名片提示。
- 新增保存流程：写入原图与校正图 → 组装 `BusinessCard` → 仓库保存；连点只产生一条记录。
- 保存后返回名片夹并刷新列表；取消不产生记录。
- 详情页补充标签编辑能力，编辑后 `updatedAt` 更新。

不包含：批量导入、重复名片合并。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/verification`、`persistence`、`card-model` 的既有行为合同。

### Modified Capabilities

无。

## Impact

- 代码：`BizScan/ViewModels/ReviewViewModel.swift`、`BizScan/Views/ReviewView.swift`、`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/Views/DetailView.swift`、`BizScan/Repositories/ImageStore.swift`
- 数据：`BusinessCardEntity` 写入路径；图像文件写入 Application Support
- 测试：`VerificationUITests`、`PersistenceUITests`（待补）
