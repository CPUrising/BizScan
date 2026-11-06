## ADDED Requirements

### Requirement: 详情展示分组

系统 SHALL 在名片详情展示该名片所属分组；未设置分组时 MUST 显示「未分组」。

#### Scenario: T23 详情展示分组

- **GIVEN** 名片属于分组「客户」
- **WHEN** 用户打开该名片详情
- **THEN** MUST 展示分组名称「客户」
- **AND** 分组为空时 MUST 显示「未分组」
- **AND** 分组信息 MUST 在重启应用后保持
