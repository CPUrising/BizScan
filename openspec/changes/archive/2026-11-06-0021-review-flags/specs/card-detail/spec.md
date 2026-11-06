## ADDED Requirements

### Requirement: 待核对标记

系统 SHALL 在详情页对 `unverifiedValues` 中的联系方式值展示「待核对」标记与修正提示。

#### Scenario: T29 低置信度字段展示待核对

- **GIVEN** 名片保存时记录了待核对电话
- **WHEN** 用户打开该名片详情
- **THEN** 该电话行 MUST 展示橙色「待核对」标签
- **AND** MUST 展示「原始识别内容，可在编辑中修正」
- **AND** 其余高置信度字段 MUST NOT 展示该标签

#### Scenario: T30 编辑修正后标记消失

- **GIVEN** 电话行展示「待核对」
- **WHEN** 用户把该号码改为正确值并保存
- **THEN** 该行 MUST NOT 再展示「待核对」与提示
- **AND** 详情页 MUST 展示修改后的号码
