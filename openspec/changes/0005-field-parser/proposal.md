# Proposal

## Why

OCR 输出是一串文本，而产品需要的是结构化联系人。直接把整段文本存下来既不可检索也不可编辑。本 change 把文本映射为八个字段，并把"无法确定"显式暴露给用户，同时用规则约束禁止 AI 式补全。

## What Changes

- 新增 `FieldLabels`：中英标签词典与标签行拆分。
- 新增 `ContactNormalizer`：全角半角、号码/邮箱/网址归一化。
- 新增 `PhoneClassifier`：手机/办公电话/传真判定，标签优先。
- 新增 `FieldParser`：八字段映射、多值处理、待定区、解析诊断。
- 新增 `ParsingDiagnostics`：记录每条文本的归类依据。
- 提供不虚构保证：缺失字段保持 `nil`；无法判断的内容进入 `unresolvedLines`。

不包含：人工校正 UI（见 `0006`）、准确率报告生成脚本。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/field-extraction` 与 `openspec/specs/card-model` 中"禁止虚构字段"的既有合同。

### Modified Capabilities

无。

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/{FieldLabels,ContactNormalizer,PhoneClassifier,FieldParser,ParsingDiagnostics}.swift`
- 测试：`FieldParserTests`、`NoFabricationTests`、`PhoneClassifierTests`、`ContactNormalizerTests`
- 影响：`ScanPipeline` 的 `ScanResult.parsed` 成为校正页的数据来源
