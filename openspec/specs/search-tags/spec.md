# 搜索、标签与备注 Capability Spec

## Purpose

定义名片检索与轻量组织能力，覆盖多字段搜索、标签的创建与筛选、备注的增删，形成「保存后还能找回来」的管理闭环。

## Requirements

### Requirement: 多字段搜索

系统 SHALL 支持按姓名、公司、职位、电话、邮箱进行包含匹配，忽略大小写。

#### Scenario: T15 按姓名搜索

- **GIVEN** 本地存在姓名包含「David」的名片
- **WHEN** 用户在搜索框输入 `david`
- **THEN** 结果 MUST 包含该名片
- **AND** 匹配 MUST 忽略大小写

#### Scenario: 按公司与号码搜索

- **GIVEN** 名片包含公司 `ABC University` 与手机号 `138xxxx0000`
- **WHEN** 分别输入 `ABC` 与 `138` 搜索
- **THEN** 两次搜索 MUST 都能命中该名片
- **AND** 结果项 MUST 高亮命中字段

#### Scenario: 无结果

- **GIVEN** 输入的关键词不存在于任何名片
- **WHEN** 执行搜索
- **THEN** MUST 展示空结果提示
- **AND** MUST 提供清空搜索的入口

#### Scenario: 清空搜索恢复列表

- **GIVEN** 搜索结果处于筛选态
- **WHEN** 用户清空关键词
- **THEN** 列表 MUST 恢复为全部名片
- **AND** 排序 MUST 与进入搜索前一致

### Requirement: 标签管理

系统 SHALL 支持创建标签、给名片打标签、按标签筛选与删除标签。

#### Scenario: T16 添加标签并按标签筛选

- **GIVEN** 用户打开某张名片的编辑页
- **WHEN** 用户新建标签 `Conference` 并保存
- **THEN** 该标签 MUST 出现在标签选择列表
- **AND** 在名片夹按 `Conference` 筛选 MUST 返回该名片

#### Scenario: 删除标签

- **GIVEN** 标签 `Conference` 已被两张名片使用
- **WHEN** 用户删除该标签
- **THEN** 标签 MUST 从筛选栏消失
- **AND** 两张名片的其余字段 MUST 不受影响
- **AND** MUST NOT 删除名片记录

#### Scenario: 重复标签

- **GIVEN** 已存在标签 `Customer`
- **WHEN** 用户再次创建同名标签
- **THEN** 系统 MUST 复用已有标签
- **AND** MUST NOT 产生重复项

### Requirement: 备注

系统 SHALL 允许为名片添加、编辑与清空备注。

#### Scenario: 添加备注

- **GIVEN** 用户编辑某张名片
- **WHEN** 用户输入备注 `Follow up next week` 并保存
- **THEN** 详情页 MUST 展示该备注
- **AND** 重启应用后备注 MUST 仍存在

#### Scenario: 清空备注

- **GIVEN** 名片已有备注
- **WHEN** 用户删除全部备注文本并保存
- **THEN** 备注 MUST 变为 `nil`
- **AND** 详情页 MUST NOT 展示空的备注区块
