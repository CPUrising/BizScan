## REMOVED Requirements

### Requirement: 更新时间语义

**Reason**: 新稿主页按 `createdAt` 日期分组展示，编辑名片不再让记录前移；原「按 updatedAt 倒序」契约与设计冲突。

**Migration**: `updatedAt` 仍用于记录最近修改时间与导出/排序的辅助展示，但主页展示顺序改由 `createdAt` 决定；见下方新增的「更新时间与展示排序」需求。

## ADDED Requirements

### Requirement: 更新时间与展示排序

系统 SHALL 在字段、标签、备注或分组发生变化时更新 `updatedAt`；主页展示 SHALL 按 `createdAt` 倒序分组，编辑 MUST NOT 改变名片所在的日期分组。

#### Scenario: 编辑后更新时间变化但排序不变

- **GIVEN** 名片夹中有三条记录
- **WHEN** 用户编辑最早创建的一条并保存
- **THEN** 该记录的 `updatedAt` MUST 更新
- **AND** 该记录 MUST 仍留在原创建日期分组内
- **AND** 其余名片的相对顺序 MUST 不变
