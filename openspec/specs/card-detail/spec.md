# 名片详情与编辑 Capability Spec

## Purpose

定义已保存名片的查看、编辑与删除行为，包括拨号、邮件、浏览器等外部系统调用的可观察结果，并保证详情页与列表数据始终一致。

## Requirements

### Requirement: 详情页展示

系统 SHALL 展示名片原图与全部已保存字段。

#### Scenario: T13 Detail

- **GIVEN** 本地存在一条已保存名片
- **WHEN** 用户打开其详情页
- **THEN** MUST 展示原始名片图
- **AND** MUST 展示全部非空字段
- **AND** 空字段 MUST NOT 以占位符或空行出现

#### Scenario: 长文本与标签展示

- **GIVEN** 名片地址较长且包含多个标签
- **WHEN** 打开详情页
- **THEN** 地址 MUST 完整可读（可换行，不截断为省略号）
- **AND** 标签 MUST 全部可见

### Requirement: 外部动作

系统 SHALL 支持从详情页发起拨号、发邮件与打开网址，并交由系统原生组件处理。

#### Scenario: 点击电话号码

- **GIVEN** 名片包含手机号码
- **WHEN** 用户点击该号码
- **THEN** 系统 MUST 调起系统电话应用并预填号码
- **AND** 返回应用后 MUST 停留在原详情页

#### Scenario: 点击邮箱与网址

- **GIVEN** 名片包含邮箱或网址
- **WHEN** 用户点击对应字段
- **THEN** MUST 调起系统邮件或浏览器
- **AND** 字段为空时点击 MUST NOT 触发任何动作，也 MUST NOT 崩溃

### Requirement: 编辑与保存

系统 SHALL 允许在详情页编辑字段并持久化修改结果。

#### Scenario: T14 Edit

- **GIVEN** 用户打开某名片详情
- **WHEN** 用户修改姓名或公司并保存
- **THEN** 详情页 MUST 立即显示新值
- **AND** 返回列表后 MUST 显示新值
- **AND** 重启应用后 MUST 仍为新值

#### Scenario: 编辑后取消

- **GIVEN** 用户进入编辑态并修改字段
- **WHEN** 用户取消编辑
- **THEN** 详情 MUST 恢复为修改前的值
- **AND** 不得更新 `updatedAt`

### Requirement: 删除

系统 SHALL 在详情页提供删除入口，并要求二次确认。

#### Scenario: 详情页删除

- **GIVEN** 用户位于某名片详情页
- **WHEN** 用户点击删除并确认
- **THEN** 记录 MUST 被删除且返回列表
- **AND** 对应图像文件 MUST 被清理

#### Scenario: 删除后返回不可恢复

- **GIVEN** 用户已确认删除
- **WHEN** 用户通过返回手势回到上一页
- **THEN** 系统 MUST NOT 展示已删除名片
- **AND** MUST NOT 崩溃或出现空白详情页

### Requirement: 返回一致性

系统 SHALL 保证详情页与列表数据一致。

#### Scenario: 详情页返回列表

- **GIVEN** 用户从列表进入详情
- **WHEN** 用户返回
- **THEN** 列表 MUST 反映最新数据与排序
- **AND** MUST 保持进入前的筛选条件
