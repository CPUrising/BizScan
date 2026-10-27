# 验证债台账

> 背景：验证在 macOS 26.3.1 + Xcode 26.1.1 + iPhone 16 模拟器（iOS 18.0）上执行；早期仅有 Windows 编辑端，可读代码但无法构建 iOS 工程，那段时期产出的代码现已由 `0009`–`0011` 补跑。
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
| `BusinessCard` | 字段契约、标题回退、空判定、时间戳 | `BusinessCardTests` | 通过 | 5 项，`0010` 验证 |
| `ContactNormalizer` | 全角半角、号码归一、邮箱/网址校验 | `ContactNormalizerTests` | 通过 | 7 项，`0010` 验证 |
| `PhoneClassifier` | 手机/办公/传真判定、标签优先 | `PhoneClassifierTests` | 通过 | 8 项，`0010` 验证 |
| `FieldParser` | T08/T09/T10、中英混排、人名公司混淆、多行地址 | `FieldParserTests` | 通过 | 13 项，`0010` 验证 |
| `FieldParser`（不虚构） | 缺失字段、歧义保留、无占位符 | `NoFabricationTests` | 通过 | 7 项，阻断级要求已满足 |
| `VCardBuilder` | T19 映射、多值、转义、75 字节折行 | `VCardBuilderTests` | 通过 | 7 项，`0010` 验证 |
| `SearchQuery` | T15 多字段搜索、格式无关匹配 | `SearchQueryTests` | 通过 | 8 项，`0010` 验证 |
| `TagStore` | T16 标签创建/复用/删除/筛选 | `TagStoreTests` | 通过 | 7 项，`0010` 验证 |

证据：[docs/verify/0010-toolchain-compile-fixes.md](verify/0010-toolchain-compile-fixes.md)（core 62 项全绿）

执行命令：

```bash
swift test --package-path Packages/BizScanCore     # macOS / CI
powershell -File scripts/verify-core.ps1           # Windows（需先装 Swift 工具链）
```

### 2.2 L2：iOS 层（必须 macOS 或 GitHub Actions）

| 模块 | 应测项 | 计划测试 | 状态 | 备注 |
|---|---|---|---|---|
| `Persistence/BusinessCardRepository` | T12/T17/T18、重启保持、文件清理 | `RepositoryTests`（6 项）+ `PersistenceTests`（4 项）+ `PersistenceUITests`（待写） | 部分通过 | `RepositoryTests` 6 项（`0010`）与 `PersistenceTests` 4 项（`0011`，SwiftData 真实落盘、同 URL 重建容器）均通过；真机 kill 进程未验证 |
| `ViewModels/ReviewViewModel` | T11 校正落库、T12 首次保存写图、空名片二次确认、连点不重复 | `ReviewViewModelTests`（5 项） | 通过 | `0011`，L2；校正页 UI 未自动化 |
| `ViewModels/DetailViewModel` | T13/T14/T16/T17、备注 | `DetailViewModelTests`（5 项） | 部分通过 | `0011`，L2；备注新增/编辑/清空未测 |
| `ViewModels/HomeViewModel` | 列表排序、删除、标签筛选 | `HomeViewModelTests`（3 项） | 通过 | `0011`，L2 |
| `Services/CardDetector` | T06 边界检测、八类拍摄条件 | `CardDetectorTests`（4 项） | 通过 | `0013`，L2；清晰/倾斜/无边界/错误透传；八类拍摄条件靠真机人工清单补充 |
| `Services/ImageCorrector` | 透视/方向校正 | `ImageCorrectorTests`（3 项） | 通过 | `0013`，L2；透视输出尺寸、四档旋转、nil quad 原样 |
| `Services/OCRService` | T07 原始文本与坐标 | `OCRServiceTests`（3 项）+ `OCREvaluationTests`（15 例） | 通过 | `0013`/`0014`，L2；真实 Vision，评估基线见 `docs/eval/ocr-field-baseline.md` |
| `Services/ScanPipeline` | 检测→校正→OCR→解析接线 | `ScanPipelineTests`（4 项） | 通过 | `0013`，L2；替身接线、OCR 失败保留原图、无效图拒绝 |
| OCR/字段准确率基线 | 字段级精确率/召回率、虚构字段计数 | `OCREvaluationTests`（15 例合成） | 通过 | `0014`，`synthetic-001`；虚构字段 0，样本 < 30 只报绝对值；待教师数据集重跑 |
| `Services/VCardExporter` | 文件写出与分享 | `VCardExporterTests`（5 项） | 通过 | `0011`，L2；系统分享面板未自动化 |
| `Views/*` + `ViewModels/*` | T01–T20 全链路 | `LaunchUITests`、`CardListUITests`、`DetailUITests`、`SearchTagsUITests`、`CaptureUITests`（已写）；检测/校正/持久化/导出 UI 测试待写 | 部分通过 | 11 个用例全绿（`0009`），覆盖 T01/T02/T13/T14/T15/T16/T17/T20（中途退出）；其余场景待写 |
| `BizScanApp` 种子数据 | T12–T17 的确定性初始状态 | 通过 `-ui-testing-seed` 注入 3 张名片 | 部分通过 | 内存容器；T13–T17 已用种子数据跑通（`0009`） |
| `project.yml` | XcodeGen 生成与编译 | `xcodebuild build` | 通过 | G0 冒烟通过，单层工程，编译 0 error（`0010` 验证） |

证据：[docs/verify/0009-acceptance-hardening.md](verify/0009-acceptance-hardening.md)（core 62 + UI 11 全绿）、[docs/verify/0011-l2-test-coverage.md](verify/0011-l2-test-coverage.md)（L2 29 项全绿）、[docs/verify/0013-service-layer-coverage.md](verify/0013-service-layer-coverage.md)（服务层 19 项，L2 累计 50 项）、[docs/verify/0014-ocr-eval-baseline.md](verify/0014-ocr-eval-baseline.md)（评估基线 + 全量回归）。T03–T05、T18 真机 kill、T19 分享面板仍待人工执行，步骤见 [manual-device-checklist.md](verify/manual-device-checklist.md)。

已知产品偏差（不属测试缺口，但会影响判定）：

| 编号 | 现象 | 影响 | 状态 |
|---|---|---|---|
| K1 | `ReviewViewModel.isEmptyCard` 未统计 `faxes`，仅含传真号的名片会被判为空卡并触发二次确认 | T20「空名片保存」的判定边界 | 未修复，需单独立项 |

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
