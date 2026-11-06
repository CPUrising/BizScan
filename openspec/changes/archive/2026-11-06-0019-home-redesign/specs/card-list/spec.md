## MODIFIED Requirements

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

## ADDED Requirements

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
