## ADDED Requirements

### Requirement: 手动新建名片

系统 SHALL 在名片夹首页提供手动新建入口，允许用户在没有名片图像的情况下录入并保存联系人信息。

#### Scenario: T34 手动新建并保存

- **GIVEN** 用户位于名片夹首页
- **WHEN** 用户点击「+」，填写姓名「手录联系人」与手机号后保存
- **THEN** 列表 MUST 出现「手录联系人」
- **AND** 列表缩略图 MUST 使用占位图
- **AND** 打开详情 MUST 展示姓名与手机号，且 MUST NOT 展示空图片区
- **AND** 重启应用后该名片 MUST 仍存在

#### Scenario: T35 手动新建空卡需确认

- **GIVEN** 用户打开手动新建表单且未填写任何字段
- **WHEN** 用户点击保存
- **THEN** 系统 MUST 弹出二次确认
- **AND** 取消后 MUST NOT 产生记录
- **AND** 确认后 MUST 保存为「未命名名片」

#### Scenario: 手动新建取消

- **GIVEN** 用户已填入手动新建表单
- **WHEN** 用户点击取消
- **THEN** MUST 返回名片夹
- **AND** MUST NOT 产生新记录
