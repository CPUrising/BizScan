## ADDED Requirements

### Requirement: 待核对值记录

系统 SHALL 在保存名片时记录来自低置信度识别或歧义解析的字段值，MUST NOT 记录未出现在名片上的值。

#### Scenario: 低置信度电话被标记

- **GIVEN** OCR 对某行电话的置信度为 0.5，且该值被写入 `mobiles`
- **WHEN** 用户确认保存
- **THEN** `unverifiedValues` MUST 包含该号码
- **AND** 高置信度字段 MUST NOT 被标记

#### Scenario: 歧义解析被标记

- **GIVEN** 解析器把某行标记为 `ambiguous` 且该行值被归入 `officePhones`
- **WHEN** 用户确认保存
- **THEN** `unverifiedValues` MUST 包含该号码

#### Scenario: 修正后不再标记

- **GIVEN** 名片记录了待核对号码 `13504119bile`
- **WHEN** 用户在编辑页把号码改为 `13504119001` 并保存
- **THEN** `unverifiedValues` MUST NOT 再包含旧值
- **AND** 该记录 MUST 持久化到重启之后
