## MODIFIED Requirements

### Requirement: 重启后数据完整

系统 SHALL 使用本地持久化存储，保证重启后记录可读取；存储初始化失败时 MUST 显式报错，MUST NOT 静默回退到内存存储继续运行。

#### Scenario: T18 Kill App 后重启

- **GIVEN** 用户已完成一张名片的保存与人工校正
- **WHEN** 系统杀死应用进程并重新启动
- **THEN** 名片 MUST 出现在列表
- **AND** 打开详情后 MUST 展示全部校正后的字段
- **AND** 原始名片图像 MUST 仍可显示

#### Scenario: 存储初始化失败

- **GIVEN** 应用无法创建本地持久化存储
- **WHEN** 应用启动
- **THEN** 应用 MUST 显式报错或终止启动
- **AND** MUST NOT 使用内存存储静默继续运行
