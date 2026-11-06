## ADDED Requirements

### Requirement: 按分组筛选名片

系统 SHALL 在名片夹首页展示当前分组与名片数量，并提供分组管理入口；用户可以按单一分组筛选名片，每张名片 MUST 最多属于一个分组。

#### Scenario: T21 创建分组并按分组筛选

- **GIVEN** 本地已有至少一张未分组名片
- **WHEN** 用户在分组管理中新建「客户」，并把一张名片移入该分组
- **THEN** 主页分组行 MUST 显示「客户」与该组名片数
- **AND** 选择「客户」后 MUST 只显示该组名片
- **AND** 选择「全部名片」后 MUST 显示全部名片

#### Scenario: T22 删除分组后名片回到未分组

- **GIVEN** 分组「客户」下有一张名片
- **WHEN** 用户删除该分组并确认
- **THEN** 该分组 MUST 从分组清单消失
- **AND** 该名片 MUST 仍然存在
- **AND** 打开详情 MUST 显示「未分组」
- **AND** MUST NOT 删除名片记录或图像文件

#### Scenario: 分组名去重

- **GIVEN** 已存在分组「客户」
- **WHEN** 用户再次创建「客户」
- **THEN** 系统 MUST 复用已有分组或提示重名
- **AND** MUST NOT 产生重复分组
