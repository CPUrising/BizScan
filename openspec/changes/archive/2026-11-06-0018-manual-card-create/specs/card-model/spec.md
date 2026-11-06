## MODIFIED Requirements

### Requirement: 名片记录结构

系统 SHALL 在保存时生成一条唯一的名片记录，字段集合、类型与必填性 MUST 与「数据模型」一节一致；所有未识别字段 MUST 为 nil 或空数组。

`originalImagePath` 的必填性 MUST 区分来源：扫描/导入来源 MUST 写入非空相对路径；手动新建来源 MUST 允许为 `nil`。

#### Scenario: T12 保存后字段完整可读

- **GIVEN** 用户已完成字段校正并点击保存（扫描来源）
- **WHEN** 系统创建名片记录
- **THEN** 记录 MUST 包含 `id`、两张图像路径、`createdAt`
- **AND** 所有未识别字段 MUST 为 `nil` 或空数组，而非空字符串占位

#### Scenario: 图像以相对路径持久化

- **GIVEN** 一张名片图像已写入应用沙盒
- **WHEN** 记录被持久化
- **THEN** 模型 MUST 只保存相对路径
- **AND** 读取时 MUST 基于当前沙盒根目录解析，保证换设备/换容器路径后仍可访问

#### Scenario: T34 手动新建允许无原图

- **GIVEN** 用户通过「+」手动新建一张名片
- **WHEN** 系统保存该记录
- **THEN** `originalImagePath` MUST 为 `nil`
- **AND** 记录 MUST 包含 `id`、`createdAt`
- **AND** 详情与列表 MUST NOT 因缺少图像而崩溃
