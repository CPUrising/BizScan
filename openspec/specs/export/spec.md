# 联系人导出 Capability Spec

## Purpose

定义把名片记录导出为通讯录可消费格式的行为，覆盖字段映射、多值字段、批量导出与权限失败回退，是名片数字化闭环的最后一环。

## Requirements

### Requirement: 导出格式

系统 SHALL 至少支持一种导出方式：生成 vCard 文件或写入系统通讯录。首个实现版本 MUST 先完成 vCard，因它不依赖通讯录权限，便于自动化测试。

#### Scenario: T19 导出单张名片为 vCard

- **GIVEN** 用户打开某张名片详情
- **WHEN** 用户选择「导出联系人」
- **THEN** 系统 MUST 生成包含该名片的 vCard 数据（`VERSION:3.0`）
- **AND** MUST 提供系统分享面板或文件保存入口
- **AND** 导出成功后 MUST 给出可见反馈

### Requirement: 字段映射

系统 SHALL 按 vCard 标准映射字段。

| 名片字段 | vCard 属性 |
|---|---|
| `name` | `FN` + `N` |
| `company` | `ORG` |
| `jobTitle` | `TITLE` |
| `mobiles` | `TEL;TYPE=CELL` |
| `officePhones` | `TEL;TYPE=WORK` |
| `faxes` | `TEL;TYPE=FAX` |
| `emails` | `EMAIL;TYPE=INTERNET` |
| `website` | `URL` |
| `address` | `ADR` |
| `notes` | `NOTE` |

#### Scenario: 多号码映射

- **GIVEN** 名片包含两个手机号、一个办公电话、一个传真
- **WHEN** 生成 vCard
- **THEN** MUST 输出对应的多条 `TEL` 记录
- **AND** 每条 MUST 带正确的 `TYPE`
- **AND** MUST NOT 合并或丢弃号码

#### Scenario: 空字段省略

- **GIVEN** 名片不含网址与地址
- **WHEN** 生成 vCard
- **THEN** MUST NOT 输出空的 `URL` 与 `ADR` 行
- **AND** MUST NOT 用公司名推断网址

### Requirement: 批量导出

系统 SHALL 支持从列表批量导出（至少支持全量导出）。

#### Scenario: 全量导出

- **GIVEN** 本地存在三条以上名片
- **WHEN** 用户选择导出全部
- **THEN** 系统 MUST 生成包含全部名片的 vCard 内容
- **AND** 每条记录 MUST 独立分隔且可被系统通讯录导入

### Requirement: 权限与失败处理

系统 SHALL 在写入系统通讯录时处理权限，并在失败时给出可执行反馈。

#### Scenario: 通讯录权限拒绝

- **GIVEN** 用户选择「保存到系统通讯录」
- **WHEN** 通讯录权限被拒绝
- **THEN** 系统 MUST 提示并回退到 vCard 分享
- **AND** MUST NOT 丢失已填写的字段

#### Scenario: 导出中断

- **GIVEN** 用户在分享面板中取消
- **WHEN** 返回应用
- **THEN** 名片数据 MUST 保持不变
- **AND** MUST NOT 重复生成临时文件
