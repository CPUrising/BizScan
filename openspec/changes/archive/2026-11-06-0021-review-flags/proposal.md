# Proposal

## Why

Figma 详情稿在电话值旁展示橙色「待核对」胶囊与「原始识别内容，可在编辑中修正」，用于提示用户该值来自低置信度识别、可能含错字。现有实现保存后不再保留任何识别依据，用户无法区分哪个字段需要复核。

## What Changes

- `BusinessCard` 新增 `unverifiedValues: [String]`（默认空），保存时由识别结果计算并持久化
- Core 新增 `UnverifiedValueDetector`：基于 OCR 置信度（< 0.7）与解析诊断（`ambiguous` / `invalidFormat`）判定电话、邮箱、地址值是否需要复核
- `ReviewViewModel.save` 在首次保存时写入该列表；编辑保存时按当前值重新计算（修正后自动剔除）
- 详情页联系方式行：命中值时展示橙色「待核对」胶囊与提示文案
- 新增 `T29`、`T30` 场景

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-model`：新增 `unverifiedValues` 字段与「不虚构」约束（只标记已识别值）
- `card-detail`：新增「待核对标记」需求

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift`、新增 `UnverifiedValueDetector.swift`、`BizScan/Models/BusinessCardEntity.swift`、`BizScan/ViewModels/ReviewViewModel.swift`、`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/Views/DetailView.swift`
- 测试：新增 `UnverifiedValueDetectorTests`，`ReviewViewModelTests`、`DetailViewModelTests`、`BizScanUITests/DetailUITests.swift`
- 文档：`docs/traceability.md`（T29/T30）、`docs/verify/0021-review-flags.md`、`README.md`
- 不在范围：人工二次校验流程、置信度阈值调参界面、非电话/邮箱/地址字段的标记
