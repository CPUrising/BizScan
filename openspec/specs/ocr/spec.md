# OCR 文字识别 Capability Spec

## Purpose

定义从校正后的名片图像中提取原始文字的能力。OCR 为概率性功能：本规范不要求逐字与参考 App 相同，但要求原始输出可追溯、可评估、可人工修正。

## Requirements

### Requirement: 原始文本留痕

系统 SHALL 保存 OCR 原始输出，不得只保留解析后的字段。

#### Scenario: T07 标准名片产生原始文本

- **GIVEN** 一张校正后的中文或英文名片
- **WHEN** 用户触发识别
- **THEN** 系统 MUST 产出原始文本（按行或按文本块）
- **AND** MUST 保存每条文本的识别框坐标与置信度
- **AND** 原始结果 MUST 可被后续字段解析读取，且不被解析过程覆盖

#### Scenario: 原始结果与最终记录分离

- **GIVEN** 用户完成人工校正并保存
- **WHEN** 查看该名片
- **THEN** 系统 MUST 能区分「OCR 原始文本」与「最终保存字段」
- **AND** 人工修改 MUST NOT 反向改写 OCR 原始文本

### Requirement: 中英识别

系统 SHALL 同时支持简体中文与英文名片，包含中英混排。

#### Scenario: 中英混排名片

- **GIVEN** 名片同时包含中文姓名与英文公司名
- **WHEN** 执行 OCR
- **THEN** 中文与英文 MUST 都被识别为文本
- **AND** 不得因语言设置丢弃任一侧文字

#### Scenario: 竖版名片

- **GIVEN** 已通过方向校正的竖版名片图像
- **WHEN** 执行 OCR
- **THEN** 文本行顺序 MUST 按阅读方向输出

### Requirement: 识别过程可观察

系统 SHALL 展示识别进度，并在失败时给出可执行的下一步。

#### Scenario: 识别耗时可见

- **GIVEN** 用户确认校正结果
- **WHEN** OCR 正在执行
- **THEN** 界面 MUST 展示进度状态
- **AND** MUST 禁止重复提交同一张图

#### Scenario: 未识别到文字

- **GIVEN** 图像模糊或无文字
- **WHEN** OCR 返回空结果
- **THEN** 系统 MUST 提示「未识别到文字」
- **AND** MUST 提供重拍、重新校正、手工录入三个出口
- **AND** MUST NOT 生成空名片记录

### Requirement: 线程与资源约束

系统 SHALL 在主线程之外执行图像处理与 OCR。

#### Scenario: 识别期间界面不卡死

- **GIVEN** 一张高分辨率名片图
- **WHEN** 系统执行检测与 OCR
- **THEN** 主线程 MUST 保持可响应
- **AND** 取消操作 MUST 能中断等待并回到上一页
