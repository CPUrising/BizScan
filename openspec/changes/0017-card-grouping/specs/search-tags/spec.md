## REMOVED Requirements

### Requirement: 标签管理

**Reason**: 新稿主页与详情不再展示标签，主页筛选能力由「分组」承担；原「按标签筛选」场景不再成立。

**Migration**: 标签数据保留在名片记录中，编辑页仍可创建/删除标签；主页筛选请使用「分组」。见下方新增的「标签编辑与保留」需求。

## ADDED Requirements

### Requirement: 标签编辑与保留

系统 SHALL 允许在编辑页创建、删除标签并持久化；标签 MUST 仅用于数据保留，主页与详情 MUST NOT 展示标签或提供标签筛选入口。

#### Scenario: T16 添加标签并保留在编辑页

- **GIVEN** 用户打开某张名片的编辑页
- **WHEN** 用户新建标签 `Conference` 并保存
- **THEN** 重新打开编辑页 MUST 仍能看到该标签
- **AND** 重启应用后标签 MUST 仍存在
- **AND** 主页与详情 MUST NOT 展示该标签

#### Scenario: 删除标签

- **GIVEN** 标签 `Conference` 已被两张名片使用
- **WHEN** 用户在编辑页删除该标签
- **THEN** 两张名片的该标签 MUST 被移除
- **AND** 其余字段 MUST 不受影响
- **AND** MUST NOT 删除名片记录

#### Scenario: 重复标签

- **GIVEN** 已存在标签 `Customer`
- **WHEN** 用户再次创建同名标签
- **THEN** 系统 MUST 复用已有标签
- **AND** MUST NOT 产生重复项
