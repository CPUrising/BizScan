# 识别结果确认与人工校正 Capability Spec

## Purpose

定义 AI 输出进入可靠软件数据之前的最后一道闸门：Human-in-the-Loop 校正。该能力是确定性的，必须可重复测试。

## Requirements

### Requirement: 校正页先于保存

系统 SHALL 在保存前展示结构化字段供用户检查，禁止识别结果直接落库。

#### Scenario: 识别完成后进入校正页

- **GIVEN** OCR 与字段解析已完成
- **WHEN** 用户进入下一步
- **THEN** 系统 MUST 展示全部已识别字段
- **AND** MUST 展示原始名片图作为对照
- **AND** MUST 在用户点击「保存」前不写入持久化存储

### Requirement: 字段可编辑

系统 SHALL 允许编辑姓名、公司、职位、手机、电话、邮箱、网址与地址，以及标签与备注。

#### Scenario: T11 Manual Correction

- **GIVEN** 校正页中 `company` 识别错误
- **WHEN** 用户修改该字段并点击保存
- **THEN** 保存结果 MUST 使用修改后的值
- **AND** 原始 OCR 文本 MUST 保持不变
- **AND** 详情页 MUST 展示修改后的值

#### Scenario: 多值与空值编辑

- **GIVEN** 某字段识别出两个号码，另一字段为空
- **WHEN** 用户删除其中一个号码并保持空字段不变
- **THEN** 保存结果 MUST 只保留剩余号码
- **AND** 空字段 MUST 保持 `nil`，MUST NOT 被占位符填充

### Requirement: 取消修改可回退

系统 SHALL 在未保存时支持放弃修改。

#### Scenario: 取消编辑恢复原值

- **GIVEN** 用户在校正页修改了多个字段但未保存
- **WHEN** 用户点击取消或返回
- **THEN** 系统 MUST 丢弃本次修改
- **AND** MUST 返回上一环节，且不产生记录

#### Scenario: 二次确认

- **GIVEN** 用户已修改字段并尝试返回
- **WHEN** 修改尚未保存
- **THEN** 系统 MUST 弹出确认，提供「放弃修改」与「继续编辑」
- **AND** 选择继续编辑后 MUST 保留已输入内容

### Requirement: 输入合法性

系统 SHALL 对明显非法的输入给出提示但不阻止保存。

#### Scenario: 非法邮箱格式

- **GIVEN** 用户输入不满足邮箱格式的文本
- **WHEN** 用户点击保存
- **THEN** 系统 MUST 以非阻断方式提示格式可疑
- **AND** 用户确认后 MUST 允许保存原始输入

#### Scenario: 空名片保存

- **GIVEN** 所有字段均为空
- **WHEN** 用户点击保存
- **THEN** 系统 MUST 提示「未填写任何字段」
- **AND** MUST 允许用户返回继续补充或明确放弃

### Requirement: 保存幂等

系统 SHALL 防止重复点击造成重复记录。

#### Scenario: 连点保存只产生一条记录

- **GIVEN** 用户快速连续点击保存两次
- **WHEN** 系统处理保存
- **THEN** 持久化结果 MUST 只有一条记录
- **AND** 第二次点击 MUST 被忽略或复用第一次结果
