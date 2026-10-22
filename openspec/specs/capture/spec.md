# 名片采集 Capability Spec

## Purpose

定义从名片夹进入采集、完成一次拍摄或相册导入，并把图像交给后续检测环节的行为。包含权限、预览、重拍、取消与中途退出等确定性路径。

## Requirements

### Requirement: 进入扫描器

系统 SHALL 从名片夹进入相机预览页，并在进入前完成相机权限申请。

#### Scenario: T02 Enter Scanner

- **GIVEN** 用户在名片夹首页
- **WHEN** 用户点击「扫描名片」
- **THEN** 系统 MUST 进入相机预览页
- **AND** MUST 展示返回、快门、相册导入三个入口
- **AND** 若权限尚未决定，MUST 先发起系统权限请求

### Requirement: 相机权限处理

系统 SHALL 对权限的允许、拒绝、受限三种结果给出确定行为，且不得崩溃。

#### Scenario: T03 Permission 允许

- **GIVEN** 用户首次进入相机页
- **WHEN** 用户在系统弹窗中选择允许
- **THEN** 预览 MUST 开始渲染
- **AND** 快门 MUST 可点击

#### Scenario: T03 Permission 拒绝

- **GIVEN** 用户拒绝相机权限
- **WHEN** 用户进入相机页
- **THEN** 系统 MUST 展示权限说明与「前往设置」入口
- **AND** MUST NOT 展示空白预览
- **AND** MUST 保留相册导入入口

#### Scenario: 从设置返回后恢复

- **GIVEN** 用户在设置中开启了相机权限
- **WHEN** 用户返回应用
- **THEN** 系统 MUST 自动恢复预览，无需重启

### Requirement: 拍摄与结果确认

系统 SHALL 在拍摄后进入结果预览，并提供确认、重拍、取消三条路径。

#### Scenario: T04 Capture 确认进入识别

- **GIVEN** 相机预览已就绪
- **WHEN** 用户点击快门
- **THEN** 系统 MUST 定格一帧并进入结果预览
- **AND** 用户点击确认后 MUST 把该图像交给名片检测环节

#### Scenario: 拍摄后重拍

- **GIVEN** 用户处于拍摄结果预览
- **WHEN** 用户点击重拍
- **THEN** 系统 MUST 丢弃当前帧并返回实时预览
- **AND** MUST NOT 生成任何待保存记录

#### Scenario: 拍摄后取消

- **GIVEN** 用户处于拍摄结果预览
- **WHEN** 用户点击取消
- **THEN** 系统 MUST 返回名片夹
- **AND** MUST NOT 保留临时图像

### Requirement: 相册导入

系统 SHALL 支持从照片库选择一张图像并进入同一识别链路。

#### Scenario: T05 Import

- **GIVEN** 相机页已打开
- **WHEN** 用户选择相册中的一张名片照片
- **THEN** 系统 MUST 进入结果预览
- **AND** 确认后 MUST 与拍摄路径进入相同的检测流程

#### Scenario: 相册权限拒绝

- **GIVEN** 用户拒绝照片库读取权限
- **WHEN** 用户点击相册导入
- **THEN** 系统 MUST 提示权限不足并提供设置入口
- **AND** 相机拍摄能力 MUST 保持可用

### Requirement: 中途退出不产生脏数据

系统 SHALL 在任意采集步骤退出时清理临时状态。

#### Scenario: T20 中途退出

- **GIVEN** 用户已拍摄但尚未保存
- **WHEN** 用户连续返回直至名片夹
- **THEN** 系统 MUST 释放相机会话
- **AND** MUST NOT 在名片夹中出现草稿记录
- **AND** 再次进入相机 MUST 正常工作
