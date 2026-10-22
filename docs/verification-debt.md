# 验证债台账

> 背景：当前开发机为 Windows，无 macOS、无 iPhone，代码先行的同时无法执行 iOS 构建与测试。
> 本台账把"未执行的验证"显式记账，避免把未验证代码当成已通过。
> 结算规则：每一行必须由真实执行结果关闭；关闭时把证据链接写入 `docs/verify/`。

## 1. 状态定义

| 状态 | 含义 |
|---|---|
| 未执行 | 代码与测试已存在，但从未真实运行 |
| 执行失败 | 已运行且失败，待修复 |
| 通过 | 已运行且全部断言通过，有日志/报告 |
| 阻塞 | 缺少环境或测试资产，无法执行 |

## 2. 台账

### 2.1 L1：BizScanCore（Windows 装 Swift 即可执行，也可在 macOS/CI 执行）

| 模块 | 应测项 | 测试文件 | 状态 | 备注 |
|---|---|---|---|---|
| `BusinessCard` | 字段契约、标题回退、空判定、时间戳 | `BusinessCardTests` | 未执行 | 纯逻辑 |
| `ContactNormalizer` | 全角半角、号码归一、邮箱/网址校验 | `ContactNormalizerTests` | 未执行 | 纯逻辑 |
| `PhoneClassifier` | 手机/办公/传真判定、标签优先 | `PhoneClassifierTests` | 未执行 | 纯逻辑 |
| `FieldParser` | T08/T09/T10、中英混排、人名公司混淆、多行地址 | `FieldParserTests` | 未执行 | 评分重点 |
| `FieldParser`（不虚构） | 缺失字段、歧义保留、无占位符 | `NoFabricationTests` | 未执行 | 阻断级要求 |
| `VCardBuilder` | T19 映射、多值、转义、75 字节折行 | `VCardBuilderTests` | 未执行 | 纯逻辑 |
| `SearchQuery` | T15 多字段搜索、格式无关匹配 | `SearchQueryTests` | 未执行 | 纯逻辑 |
| `TagStore` | T16 标签创建/复用/删除/筛选 | `TagStoreTests` | 未执行 | 纯逻辑 |

执行命令：

```bash
swift test --package-path Packages/BizScanCore     # macOS / CI
powershell -File scripts/verify-core.ps1           # Windows（需先装 Swift 工具链）
```

### 2.2 L2：iOS 层（必须 macOS 或 GitHub Actions）

| 模块 | 应测项 | 计划测试 | 状态 | 备注 |
|---|---|---|---|---|
| `Persistence/BusinessCardRepository` | T12/T17/T18、重启保持、文件清理 | `RepositoryTests`（内存实现已写）+ `PersistenceUITests`（待写） | 代码完成，未执行 | 含 `InMemoryBusinessCardRepository` |
| `Services/CardDetector` | T06 边界检测、八类拍摄条件 | `CardDetectorTests` | 未开始 | Vision |
| `Services/ImageCorrector` | 透视/方向校正 | `ImageCorrectorTests` | 未开始 | Core Image |
| `Services/OCRService` | T07 原始文本与坐标 | `OCRServiceTests` | 未开始 | 需模拟器 + fixture |
| `Services/ScanPipeline` | 检测→校正→OCR→解析接线 | `ScanPipelineTests` | 未开始 | 注入替身 |
| `Services/VCardExporter` | 文件写出与分享 | `VCardExporterTests` | 未开始 | 文件系统 |
| `Views/*` + `ViewModels/*` | T01–T20 全链路 | `LaunchUITests`（已写）+ 其余 T02–T20 待写 | 代码完成，未执行 | 需模拟器 |
| `project.yml` | XcodeGen 生成与编译 | `xcodebuild build` | 未执行 | G0 冒烟 |

### 2.3 L3：只能人工确认

| 项 | 原因 | 替代方案 |
|---|---|---|
| CamCard 黑盒行为 | 无 iOS 设备 | 教师下发的 Reference Test Suite / 录屏 / `要求/02.md` |
| 真实相机取景与画质 | 模拟器无相机 | 真机手测；测试用图片注入 |
| 权限弹窗文案与时序 | 系统行为随版本变化 | 记录系统版本，以 CI 模拟器版本为准 |

## 3. 结算顺序（还债时按此执行）

1. `swift test --package-path Packages/BizScanCore` → 关闭 2.1 全部行。
2. `bash scripts/verify.sh --scope unit` → 关闭 iOS 单测相关行。
3. `bash scripts/verify.sh --scope all` → 关闭 UI 与集成行。
4. 每关闭一批，更新本表状态并在 `docs/verify/<change>.md` 留下证据。
5. 全部通过后才允许 `openspec archive`。

## 4. 风险提示

- 未编译过的 Swift 代码可能存在语法/类型错误，首次 CI 预计需要 1–2 轮修复。
- `FieldParser` 的启发式规则只能在固定名片集上评估，不能以"看起来对"结案。
- 本台账不能替代 01.md 要求的 `Reference Test Suite 100% 通过`；它只用于管理未验证状态。
