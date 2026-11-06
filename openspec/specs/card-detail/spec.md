# 名片详情与编辑 Capability Spec

## Purpose

定义已保存名片的查看、编辑与删除行为，包括拨号、邮件、浏览器等外部系统调用的可观察结果，并保证详情页与列表数据始终一致。

## Requirements

### Requirement: 详情页展示

系统 SHALL 以自定义深色详情页展示名片：蓝色顶栏、姓氏头像与核心资料、分组、备注与全部已保存字段；空字段 MUST NOT 出现。名片原图 SHALL 通过「查看原图」入口按需展示。

#### Scenario: T13 Detail

- **GIVEN** 本地存在一条已保存名片
- **WHEN** 用户打开其详情页
- **THEN** MUST 展示姓名（缺失时回退公司）、职务与公司
- **AND** MUST 展示全部非空字段
- **AND** 空字段 MUST NOT 以占位符或空行出现
- **AND** 顶部 MUST 展示「名片详情」标题与返回入口

#### Scenario: 长文本与标签展示

- **GIVEN** 名片地址较长且包含多个标签
- **WHEN** 打开详情页
- **THEN** 地址 MUST 完整可读（可换行，不截断为省略号）
- **AND** 标签 MUST NOT 在详情页展示（自 0017 起改为仅在编辑页维护）
- **AND** 该名片所属分组 MUST 可见

### Requirement: 外部动作

系统 SHALL 支持从详情页发起拨号、发邮件、打开网址与打开地图，并交由系统原生组件处理。

#### Scenario: 点击电话号码

- **GIVEN** 名片包含手机号码
- **WHEN** 用户点击该号码或「电话」快捷按钮
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

### Requirement: 详情展示分组

系统 SHALL 在名片详情展示该名片所属分组；未设置分组时 MUST 显示「未分组」。

#### Scenario: T23 详情展示分组

- **GIVEN** 名片属于分组「客户」
- **WHEN** 用户打开该名片详情
- **THEN** MUST 展示分组名称「客户」
- **AND** 分组为空时 MUST 显示「未分组」
- **AND** 分组信息 MUST 在重启应用后保持

### Requirement: 收藏名片

系统 SHALL 支持在详情页收藏/取消收藏名片，并持久化该状态。

#### Scenario: T27 收藏状态持久化

- **GIVEN** 用户打开一张未收藏名片的详情
- **WHEN** 用户点击顶栏星标
- **THEN** 星标 MUST 变为选中态
- **AND** 重新打开该名片时 MUST 仍为选中态
- **AND** 再次点击 MUST 取消收藏

### Requirement: 查看原图

系统 SHALL 在存在名片图像时提供「查看原图」入口，并以全屏方式展示；无图像时 MUST 隐藏该入口。

#### Scenario: T28 查看原图

- **GIVEN** 名片包含原始图像
- **WHEN** 用户点击「查看原图」
- **THEN** MUST 全屏展示该图像
- **AND** 用户 MUST 能通过关闭手势或按钮返回详情页
- **AND** 无图像的名片 MUST NOT 展示该入口

### Requirement: 详情快捷操作

系统 SHALL 在核心资料区提供「电话 / 地址 / 备注 / 编辑」四个快捷操作，缺少对应数据时该操作 MUST 禁用。

#### Scenario: T26 详情核心资料与快捷操作

- **GIVEN** 名片包含姓名、职务、公司与手机号
- **WHEN** 用户打开详情页
- **THEN** MUST 展示姓氏头像与姓名、职务、公司
- **AND** MUST 展示「电话 / 地址 / 备注 / 编辑」四个快捷操作
- **AND** 缺少地址时「地址」MUST 处于禁用态
- **AND** 点击「编辑」MUST 打开编辑表单

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

### Requirement: 存入系统通讯录

系统 SHALL 在详情页提供「存入通讯录」主按钮，把名片字段写入系统通讯录，并在权限拒绝或联系人已存在时给出明确反馈。

#### Scenario: T31 存入通讯录成功

- **GIVEN** 名片包含姓名、公司、职位与手机号
- **WHEN** 用户点击「存入通讯录」并允许通讯录权限
- **THEN** 系统 MUST 写入一条联系人，字段与名片一致
- **AND** 按钮 MUST 变为「已存入」且不可再次提交
- **AND** MUST NOT 写入第二条重复记录

#### Scenario: T32 权限拒绝时引导设置

- **GIVEN** 用户已拒绝通讯录权限
- **WHEN** 用户点击「存入通讯录」
- **THEN** 系统 MUST 提示需要通讯录权限
- **AND** MUST 提供前往系统设置的入口
- **AND** MUST NOT 崩溃或静默失败

#### Scenario: T33 重复联系人提示已存在

- **GIVEN** 通讯录中已存在同姓名且号码相同的联系人
- **WHEN** 用户点击「存入通讯录」
- **THEN** 系统 MUST 提示「该联系人已在通讯录中」
- **AND** MUST NOT 新增重复联系人
