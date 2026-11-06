## MODIFIED Requirements

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

## ADDED Requirements

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
