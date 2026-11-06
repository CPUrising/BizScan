# Proposal

## Why

Figma 详情稿底部主按钮为「存入通讯录」，语义是写入系统通讯录，而不是导出一个 vCard 文件再让用户自己处理。当前实现只有 `ellipsis` 菜单里的 vCard 分享，底部按钮处于禁用占位状态，用户无法完成「拍完即存」的闭环。

## What Changes

- 新增 `ContactsSaving` 协议与 `SystemContactsService`（`Contacts` 框架）：权限申请、字段映射、写入、重复检测
- 新增 `ContactsMapper`：`BusinessCard` → `CNMutableContact` 的纯映射，可单测
- 详情页底部按钮启用，三种结果反馈：成功（按钮变「已存入」）、已存在、未授权（引导设置）
- `Info.plist` 的 `NSContactsUsageDescription` 文案改为「写入联系人」
- 新增 `T31`、`T32`、`T33` 场景

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-detail`：新增「存入系统通讯录」需求（含权限拒绝与重复联系人的可观察结果）

## Impact

- 代码：新增 `BizScan/Services/ContactsService.swift`、`BizScan/Services/ContactsMapper.swift`；`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/Views/DetailView.swift`、`BizScan/App/AppEnvironment.swift`、`project.yml`
- 测试：新增 `ContactsMapperTests`、`SystemContactsServiceTests`（假 store）、`DetailViewModelTests` 补充
- 文档：`docs/traceability.md`（T31–T33）、`docs/verify/0022-save-to-contacts.md`、`docs/verify/manual-device-checklist.md`、`README.md`
- 不在范围：通讯录分组（`CNGroup`）写入、双向同步、批量导入、联系人编辑回写
