# 名片数据模型 Capability Spec

## Purpose

定义 BizScan 保存一张名片时的唯一数据结构。该模型是 OCR、字段解析、人工校正、持久化与导出五个环节的共同契约，并为「不得虚构字段」提供可测试的落点。

## 数据模型

下表为 `BusinessCard` 的字段契约。字段增删、类型变化必须通过 change 的 `## MODIFIED Requirements` 表达，禁止直接修改本节。

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `id` | UUID | 是 | 记录标识 |
| `originalImagePath` | String | 是 | 原始名片图相对路径 |
| `processedImagePath` | String | 否 | 校正/裁剪后图像相对路径 |
| `name` | String? | 否 | 姓名 |
| `company` | String? | 否 | 公司 |
| `jobTitle` | String? | 否 | 职位 |
| `mobiles` | [String] | 否 | 手机号码，允许多个 |
| `officePhones` | [String] | 否 | 办公电话，允许多个 |
| `faxes` | [String] | 否 | 传真，允许多个 |
| `emails` | [String] | 否 | 邮箱，允许多个 |
| `website` | String? | 否 | 网址 |
| `address` | String? | 否 | 地址 |
| `department` | String? | 否 | 部门（可选） |
| `postalCode` | String? | 否 | 邮编（可选） |
| `tags` | [String] | 是 | 标签，默认空数组 |
| `notes` | String? | 否 | 备注 |
| `createdAt` | Date | 是 | 创建时间 |
| `updatedAt` | Date | 是 | 最近修改时间 |

## Requirements

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

### Requirement: 禁止虚构字段

系统 MUST NOT 生成名片原图中不存在的信息。

#### Scenario: T09 缺失字段保持缺失

- **GIVEN** 名片上不存在网址
- **WHEN** 系统完成 OCR 与字段解析
- **THEN** `website` MUST 保持 `nil`
- **AND** 系统 MUST NOT 依据公司名推断域名
- **AND** 人工校正页 MUST NOT 预填任何猜测值

#### Scenario: 歧义内容不得强行归类

- **GIVEN** 名片中出现 `Apple`，无法判定是公司、产品还是地址片段
- **WHEN** 字段解析器无法给出确定归属
- **THEN** 该项 MUST 保留在待定区（原始文本行）而不写入任何结构化字段
- **AND** 解析结果 MUST 记录歧义原因，供人工校正

### Requirement: 多值字段顺序稳定

系统 SHALL 保持同一字段内多个值的输入顺序，且去重时保留首次出现的原始写法。

#### Scenario: T10 多个电话号码顺序稳定

- **GIVEN** OCR 依次得到 `Mobile: +86 138...`、`Office: 021-...`、`Fax: 021-...`
- **WHEN** 解析为结构化字段
- **THEN** `mobiles`、`officePhones`、`faxes` 各自保持出现顺序
- **AND** 重复号码 MUST 在同一字段内去重，不得跨字段合并

### Requirement: 更新时间与展示排序

系统 SHALL 在字段、标签、备注或分组发生变化时更新 `updatedAt`；主页展示 SHALL 按 `createdAt` 倒序分组，编辑 MUST NOT 改变名片所在的日期分组。

#### Scenario: 编辑后更新时间变化但排序不变

- **GIVEN** 名片夹中有三条记录
- **WHEN** 用户编辑最早创建的一条并保存
- **THEN** 该记录的 `updatedAt` MUST 更新
- **AND** 该记录 MUST 仍留在原创建日期分组内
- **AND** 其余名片的相对顺序 MUST 不变

### Requirement: 收藏标记

系统 SHALL 在名片记录中保存收藏标记，默认 `false`，并在重启后保持。

#### Scenario: 收藏标记持久化

- **GIVEN** 名片初始未收藏
- **WHEN** 用户收藏该名片并重启应用
- **THEN** 记录 MUST 仍为已收藏
- **AND** 旧数据 MUST 默认视为未收藏

### Requirement: 待核对值记录

系统 SHALL 在保存名片时记录来自低置信度识别或歧义解析的字段值，MUST NOT 记录未出现在名片上的值。

#### Scenario: 低置信度电话被标记

- **GIVEN** OCR 对某行电话的置信度为 0.5，且该值被写入 `mobiles`
- **WHEN** 用户确认保存
- **THEN** `unverifiedValues` MUST 包含该号码
- **AND** 高置信度字段 MUST NOT 被标记

#### Scenario: 歧义解析被标记

- **GIVEN** 解析器把某行标记为 `ambiguous` 且该行值被归入 `officePhones`
- **WHEN** 用户确认保存
- **THEN** `unverifiedValues` MUST 包含该号码

#### Scenario: 修正后不再标记

- **GIVEN** 名片记录了待核对号码 `13504119bile`
- **WHEN** 用户在编辑页把号码改为 `13504119001` 并保存
- **THEN** `unverifiedValues` MUST NOT 再包含旧值
- **AND** 该记录 MUST 持久化到重启之后
