# 名片夹首页 Capability Spec

## Purpose

定义应用启动后的主入口行为：名片列表、空状态、扫描入口、以及新增/删除后的列表一致性。该能力全部为确定性功能，要求 Reference Test Suite 100% 通过。

## Requirements

### Requirement: 首次启动进入空名片夹

系统 SHALL 在没有任何名片时展示空状态，并提供常驻的拍摄入口。

#### Scenario: T01 First Launch

- **GIVEN** 应用为首次安装且本地无任何名片
- **WHEN** 用户启动应用
- **THEN** 系统 MUST 进入名片夹首页
- **AND** MUST 展示「点击下方相机拍摄您的第一张名片」
- **AND** MUST 展示底部居中的相机按钮
- **AND** MUST NOT 展示额外的文字按钮

### Requirement: 名片列表展示

系统 SHALL 在存在名片时以列表展示，每项至少包含缩略图、姓名或公司、职位与公司信息。

#### Scenario: 列表缩略信息可读

- **GIVEN** 本地已有至少一条名片
- **WHEN** 用户回到名片夹首页
- **THEN** 每一项 MUST 展示 98×64 缩略图（无图时使用占位图）
- **AND** 姓名缺失时 MUST 回退展示公司名，两者都缺失时展示「未命名名片」
- **AND** MUST 展示职位与公司（存在时），最多两行

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

### Requirement: 按创建日期分组展示

系统 SHALL 按 `createdAt` 的日期倒序分组展示名片，并在每个分组前展示 `yyyy-MM-dd` 日期标题。

#### Scenario: T24 主页按日期分组展示

- **GIVEN** 本地存在两张创建于不同日期的名片
- **WHEN** 用户打开名片夹首页
- **THEN** 较新日期的分组 MUST 出现在上方
- **AND** 每个分组 MUST 展示日期标题与该日期的名片
- **AND** 编辑某张名片后 MUST NOT 改变其所在分组

### Requirement: 主页深色外观

系统 SHALL 以深色外观展示名片夹主页，页面背景 MUST 为 `#191919`，列表分隔线 MUST 为 `#2B2B2B`。

#### Scenario: T25 主页深色外观与常驻入口

- **GIVEN** 系统处于浅色模式
- **WHEN** 用户打开名片夹首页
- **THEN** 页面 MUST 仍以深色背景展示
- **AND** 搜索框、分组行、相机按钮 MUST 常驻可见
- **AND** 搜索框 MUST 展示占位「请输入姓名/公司/职位搜索」
