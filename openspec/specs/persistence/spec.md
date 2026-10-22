# 本地持久化 Capability Spec

## Purpose

定义跨进程生命周期的数据可靠性：应用被系统杀死并重启后，名片、图像、校正结果、标签与备注必须完整保留。

## Requirements

### Requirement: 重启后数据完整

系统 SHALL 使用本地持久化存储，保证重启后记录可读取。

#### Scenario: T18 Kill App 后重启

- **GIVEN** 用户已完成一张名片的保存与人工校正
- **WHEN** 系统杀死应用进程并重新启动
- **THEN** 名片 MUST 出现在列表
- **AND** 打开详情后 MUST 展示全部校正后的字段
- **AND** 原始名片图像 MUST 仍可显示

### Requirement: 图像文件生命周期

系统 SHALL 保证图像与记录的引用一致，不出现悬空引用。

#### Scenario: 图像路径可解析

- **GIVEN** 应用沙盒容器路径在系统升级后发生变化
- **WHEN** 应用读取历史记录
- **THEN** 系统 MUST 通过相对路径解析出图像
- **AND** 图像缺失时 MUST 展示占位图并提示，MUST NOT 崩溃

#### Scenario: 删除记录清理文件

- **GIVEN** 用户删除一张名片
- **WHEN** 删除完成
- **THEN** 对应的原始图与处理后图像 MUST 被清理
- **AND** 其他名片的图像 MUST NOT 受影响

### Requirement: 并发与一致性

系统 SHALL 在后台保存与前台读取并发时保持一致。

#### Scenario: 保存过程中的列表刷新

- **GIVEN** 保存操作正在后台写入
- **WHEN** 用户返回列表
- **THEN** 列表 MUST 在写入完成后自动刷新
- **AND** MUST NOT 出现重复记录或部分字段缺失

### Requirement: 数据结构演进

系统 SHALL 保证模型字段扩展不破坏既有数据。

#### Scenario: 新增可选字段后旧数据可读

- **GIVEN** 旧版本保存的名片不含新增字段
- **WHEN** 新版本启动并读取
- **THEN** 旧记录 MUST 可正常打开
- **AND** 新增字段 MUST 取默认值
- **AND** MUST NOT 触发数据清空或崩溃
