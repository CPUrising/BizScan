# Proposal

## Why

名片数字化的最后一环是"能被别处使用"。没有导出，数据只停留在本应用内。本 change 先实现不依赖通讯录权限的 vCard 导出，保证可自动化测试且能在模拟器验证。

## What Changes

- 新增 `VCardBuilder`（BizScanCore）：vCard 3.0 生成、字段映射、转义、75 字节折行。
- 新增 `VCardFileExporter`：写入临时 `.vcf` 文件。
- 详情页新增「导出联系人」，通过系统分享面板输出文件。
- 空字段省略；多值电话按 `CELL/WORK/FAX` 分别输出。

不包含：直接写入系统通讯录（`0009` 之后视验收需要再加）、批量导出 UI（核心已支持多张）。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/export` 的既有行为合同。

### Modified Capabilities

无。

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/VCardBuilder.swift`、`BizScan/Services/VCardExporter.swift`、`BizScan/Views/Components/ShareSheet.swift`、`BizScan/Views/DetailView.swift`
- 测试：`VCardBuilderTests`、`VCardExporterTests`（待补）、`ExportUITests`（待补）
