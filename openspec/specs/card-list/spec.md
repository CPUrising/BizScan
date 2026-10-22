# 名片夹首页 Capability Spec

## Purpose

定义应用启动后的主入口行为：名片列表、空状态、扫描入口、以及新增/删除后的列表一致性。该能力全部为确定性功能，要求 Reference Test Suite 100% 通过。

## Requirements

### Requirement: 首次启动进入空名片夹

系统 SHALL 在没有任何名片时展示空状态，并提供扫描入口。

#### Scenario: T01 First Launch

- **GIVEN** 应用为首次安装且本地无任何名片
- **WHEN** 用户启动应用
- **THEN** 系统 MUST 进入名片夹首页
- **AND** MUST 展示空状态说明（中文）
- **AND** MUST 展示可点击的「扫描名片」入口

### Requirement: 名片列表展示

系统 SHALL 在存在名片时以列表展示，每项至少包含缩略图、姓名或公司、更新时间。

#### Scenario: 列表缩略信息可读

- **GIVEN** 本地已有至少一条名片
- **WHEN** 用户回到名片夹首页
- **THEN** 每一项 MUST 展示缩略图
- **AND** 姓名缺失时 MUST 回退展示公司名，两者都缺失时展示「未命名名片」
- **AND** MUST 展示相对更新时间

#### Scenario: 点击进入详情

- **GIVEN** 列表中存在某条名片
- **WHEN** 用户点击该卡片
- **THEN** 系统 MUST 进入该名片的详情页
- **AND** 返回后 MUST 保持列表滚动位置

### Requirement: 新增名片后列表更新

系统 SHALL 在保存成功后立即反映到列表，无需重启应用。

#### Scenario: T12 Save 后返回名片夹

- **GIVEN** 用户从扫描流程保存了一张名片
- **WHEN** 系统返回名片夹
- **THEN** 新名片 MUST 出现在列表首位
- **AND** 其缩略图与字段 MUST 与刚保存内容一致

### Requirement: 删除名片后列表更新

系统 SHALL 在删除确认后移除记录并刷新列表。

#### Scenario: T17 Delete

- **GIVEN** 列表中有一张名片
- **WHEN** 用户执行删除并确认
- **THEN** 该名片 MUST 从列表消失
- **AND** 关联图像文件 MUST 被清理
- **AND** 列表为空时 MUST 切回空状态

#### Scenario: 取消删除不产生副作用

- **GIVEN** 用户触发了删除确认弹窗
- **WHEN** 用户选择取消
- **THEN** 记录 MUST 保持不变
- **AND** 列表 MUST 不发生刷新或跳动

### Requirement: 搜索入口常驻

系统 SHALL 在名片夹首页提供搜索入口，且在空状态下仍可访问（空结果集）。

#### Scenario: 空状态下的搜索入口

- **GIVEN** 本地没有任何名片
- **WHEN** 用户点击搜索入口
- **THEN** 系统 MUST 进入搜索页并展示空结果提示
- **AND** MUST NOT 崩溃或停留在加载状态
