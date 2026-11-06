# Design

## Context

`FieldParser.parse(observations:)` 已为每行生成 `ParsingDiagnostic`（含 `field`、`reason`、`confidence`），`OCRObservation` 带 `confidence`。`ScanResult` 同时携带 `observations` 与 `parsed`。`ReviewViewModel.init` 只接收 `scanResult`，保存时没有把识别依据写入模型。

## Decisions

### 1. 判定器放在 Core

```swift
public struct UnverifiedValueDetector {
    public static let defaultThreshold: Float = 0.7
    public static func detect(
        parsed: ParsedCard,
        observations: [OCRObservation],
        threshold: Float = defaultThreshold
    ) -> [String]
}
```

只考察四类需要人工核对的字段：`mobiles`、`officePhones`、`faxes`、`emails`、`address`（地址只取整段）。

命中条件（任一）：

1. 解析诊断 `reason ∈ {ambiguous, invalidFormat}` 且 `line` 包含该值（或该值包含 `line`），`field` 为空或属于同类；
2. 存在 `confidence < threshold` 的 OCR 观察，其文本包含该值（去空白后比较）。

约束：

- 只标记已经写入模型的**真实存在的值**，不生成新值（沿用「不虚构」原则）
- 去重且保持字段顺序

### 2. 模型字段

`BusinessCard.unverifiedValues: [String] = []`，`BusinessCardEntity.unverifiedValues: [String] = []`（带默认值，保证轻量迁移）。

### 3. 保存时计算

`ReviewViewModel` 增加 `private let unverifiedValues: [String]`，在 `init` 中由 `scanResult` 计算一次：

```swift
self.detectedUnverifiedValues = UnverifiedValueDetector.detect(
    parsed: scanResult.parsed, observations: scanResult.observations
)
```

`save` 时取交集：只保留仍在对应字段中的值。

```swift
let currentValues = Set(card.mobiles + card.officePhones + card.faxes + card.emails + [card.address].compactMap { $0 })
card.unverifiedValues = detectedUnverifiedValues.filter { currentValues.contains($0) }
```

即用户把 `13504119bile` 改成正确号码后，旧值不再与任何字段相等，标记自动消失；无需额外状态。

### 4. 详情展示

`ContactEntry` 增加 `needsReview: Bool`。行内字段名后追加胶囊：

- 背景 `#3B3021`、文字 `#E7AB52`、12 号、padding 3/7、r6
- 命中时值下方展示提示「原始识别内容，可在编辑中修正」（12 号 `#858A91`）

数据来源：`viewModel.contactEntries` 用 `card.unverifiedValues` 判断。

### 5. 阈值

固定 0.7（写入 design.md），后续用 `docs/eval` 基线校准。单测覆盖 0.69/0.71 两侧。

## Risks / Trade-offs

- **旧数据无标记**：0016 之前保存的名片 `unverifiedValues` 为空，属预期（当时未记录依据）。
- **地址误报**：地址 OCR 置信度普遍偏低，可能频繁命中；阈值与字段范围已在单测中固定，后续按基线调整。
- **编辑保存会重算**：`ReviewViewModel` 复用编辑能力时沿用同一判定器；`DetailViewModel.save` 不重算，仅做交集过滤（不引入新的识别依据）。

## Migration Plan

新增数组字段带默认值，旧 store 轻量迁移后为 `[]`；`PersistenceTests` 补一条重启读取断言。

## Open Questions

无。
