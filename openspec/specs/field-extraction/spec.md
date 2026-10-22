# 联系人字段结构化 Capability Spec

## Purpose

定义把 OCR 文本映射为八个必选字段的规则边界。该能力是概率性功能中风险最高的一环，核心约束是「分类可错，但不得虚构」。

## Requirements

### Requirement: 八字段解析

系统 SHALL 将 OCR 文本解析为 `name`、`company`、`jobTitle`、`mobile`、`phone`、`email`、`website`、`address` 八个字段，并允许补充 `department`、`fax`、`postalCode`。

#### Scenario: T08 标准名片字段分类

- **GIVEN** OCR 文本包含姓名、职位、公司与联系方式
- **WHEN** 字段解析完成
- **THEN** 各项 MUST 归入对应字段，而非拼接为单一字符串
- **AND** 解析结果 MUST 附带每项的来源文本行

#### Scenario: 中英混排字段

- **GIVEN** 文本为 `朱宏明 Professor Tongji University`
- **WHEN** 执行解析
- **THEN** 姓名与职位、公司 MUST 被分开
- **AND** 无法确定归属的片段 MUST 保留在待定区

### Requirement: 多号码分类

系统 SHALL 依据号码前后文标签与格式，区分手机、办公电话与传真。

#### Scenario: T10 多号码分流

- **GIVEN** 文本同时包含 `Mobile`、`Office`、`Fax` 三类标签
- **WHEN** 执行解析
- **THEN** 三类号码 MUST 分别写入 `mobiles`、`officePhones`、`faxes`
- **AND** 同一号码 MUST NOT 同时出现在两个字段

#### Scenario: 无标签多号码

- **GIVEN** 名片上有两个号码但无标签
- **WHEN** 无法确定主次
- **THEN** 系统 MUST 全部保留到 `officePhones` 与 `mobiles` 的待确认集合
- **AND** MUST 在界面上提示用户确认归属
- **AND** MUST NOT 丢弃任一号码

### Requirement: 不虚构原则

系统 MUST NOT 生成原图中不存在的信息。

#### Scenario: T09 无 Website

- **GIVEN** OCR 文本中不存在网址或域名
- **WHEN** 执行解析
- **THEN** `website` MUST 为 `nil`
- **AND** MUST NOT 由公司名拼接域名
- **AND** 单元测试 MUST 覆盖该断言

#### Scenario: 人名与公司混淆

- **GIVEN** 文本为 `Jordan Lee` 与 `Lee Consulting`
- **WHEN** 执行解析
- **THEN** 系统 MUST 采用保守分类：姓名取 `Jordan Lee`，公司取 `Lee Consulting`
- **AND** 若无法区分，MUST 将两者放入待定区并标记歧义

### Requirement: 格式归一化

系统 SHALL 统一去除首尾空白与装饰性分隔符，但保留原始号码写法供核对。

#### Scenario: 标点与空白清理

- **GIVEN** 文本为 `  david.chen@abc.edu  ` 或 `Tel: 021-8888-0000`
- **WHEN** 写入字段
- **THEN** MUST 去除首尾空白与 `Tel:` 等标签前缀
- **AND** MUST 保留原始行文本用于人工核对

### Requirement: 解析结果可解释

系统 SHALL 为每个字段记录解析依据（标签命中、正则命中或版面位置）。

#### Scenario: 错误可定位

- **GIVEN** 某张名片的 `company` 被错误识别为姓名
- **WHEN** 查看解析诊断
- **THEN** 系统 MUST 输出命中的规则与来源文本
- **AND** 该诊断 MUST 进入准确率评估报告
