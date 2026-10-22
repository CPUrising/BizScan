# 名片区域检测与校正 Capability Spec

## Purpose

定义从名片图像中定位名片四边形、完成透视与方向校正、并允许人工微调的行为。该能力是概率性模块，验收以教师测试集上的可观察结果与人工可校正性为准。

## Requirements

### Requirement: 自动边界检测

系统 SHALL 在图像中检测名片四边形，并给出四个角点。

#### Scenario: T06 倾斜名片自动识别

- **GIVEN** 用户提交一张倾斜拍摄的名片图
- **WHEN** 系统执行检测
- **THEN** MUST 输出四个角点构成的四边形
- **AND** MUST 在校正页把检测结果显示为可拖拽的控制点
- **AND** 检测置信度 MUST 与结果一同保存，供偏差分析

#### Scenario: 浅色/深色背景

- **GIVEN** 名片位于浅色或深色桌面背景上
- **WHEN** 系统执行检测
- **THEN** MUST 优先返回名片边界而非桌面轮廓
- **AND** 若无法区分，MUST 返回低置信结果并进入手动调整

#### Scenario: 复杂背景或部分遮挡

- **GIVEN** 名片边缘被手指遮挡或背景纹理复杂
- **WHEN** 检测失败或置信度低于阈值
- **THEN** 系统 MUST 回退到手动四点调整模式
- **AND** MUST NOT 直接进入 OCR

### Requirement: 自动裁剪与透视校正

系统 SHALL 依据确认后的四边形生成正向矩形图像。

#### Scenario: 透视校正输出

- **GIVEN** 用户确认了四个角点
- **WHEN** 系统执行校正
- **THEN** 输出图像 MUST 为矩形且长宽比接近名片标准比例
- **AND** 文字方向 MUST 为水平可读
- **AND** 校正后的图像 MUST 作为 `processedImage` 保存

### Requirement: 方向校正

系统 SHALL 支持 90 度旋转，并在保存时记录最终方向。

#### Scenario: 竖版名片旋转

- **GIVEN** 输入为竖版名片
- **WHEN** 用户点击旋转
- **THEN** 预览 MUST 立即旋转 90 度
- **AND** 再次点击 MUST 继续同方向旋转
- **AND** 保存的图像方向 MUST 与最终预览一致

### Requirement: 手动调整

系统 SHALL 允许用户拖拽角点，并在拖动时提供放大镜或局部放大。

#### Scenario: 拖拽角点实时更新

- **GIVEN** 系统已显示四个控制点
- **WHEN** 用户拖拽任一控制点
- **THEN** 四边形 MUST 实时更新
- **AND** 角点 MUST 被限制在图像范围内
- **AND** 用户确认后 MUST 使用最新角点重新裁剪

#### Scenario: 检测结果不可用

- **GIVEN** 检测未返回四边形
- **WHEN** 用户进入校正页
- **THEN** 系统 MUST 以整图四边形作为初始值
- **AND** MUST 允许手动调整或选择重新拍摄

### Requirement: 重新拍摄与撤销

系统 SHALL 允许从校正页返回重新拍摄，且不丢失已保存的其他名片。

#### Scenario: T20 校正页重拍

- **GIVEN** 用户处于校正页
- **WHEN** 用户点击重新拍摄
- **THEN** 系统 MUST 返回相机预览
- **AND** MUST 清理本次临时图像与角点状态
