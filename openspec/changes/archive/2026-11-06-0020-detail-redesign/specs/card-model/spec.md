## ADDED Requirements

### Requirement: 收藏标记

系统 SHALL 在名片记录中保存收藏标记，默认 `false`，并在重启后保持。

#### Scenario: 收藏标记持久化

- **GIVEN** 名片初始未收藏
- **WHEN** 用户收藏该名片并重启应用
- **THEN** 记录 MUST 仍为已收藏
- **AND** 旧数据 MUST 默认视为未收藏
