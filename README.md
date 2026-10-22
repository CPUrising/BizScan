# BizScan

> 课程作业：**基于 SDD + TRAE 的名片全能王（CamCard）功能切片 100% 黑盒复刻**
> 方法论：Specification-Driven Development（OpenSpec 1.14，spec-driven schema）
> 平台：iOS 17+ / SwiftUI / Swift 5.9

本仓库不是「一个能识别的名片 App 演示」，而是一条可审查、可验证、可归档的工程链路：

```
黑盒观察 → Specification → Architecture → Implementation → Test → 差异分析 → 修正 → 回归
```

**代码只是产物之一；`openspec/` 下的规范、`docs/verify/` 下的证据，与代码等价重要。**

---

## 1. 复刻范围

只复刻一个封闭切片：

```
名片夹/Home → 扫描名片 → 拍摄/图片导入 → 名片区域检测 → 透视/方向校正
→ OCR 文字识别 → 联系人字段解析 → 人工确认与修改 → 保存名片
→ 名片夹 → 搜索/标签/查看详情 → 联系人导出
```

不实现：注册登录、会员支付、云同步、CRM、数字名片、AI 企业情报等（完整排除清单见 `要求/01.md` 第十五章）。

验收定义：

| 类别 | 范围 | 标准 |
|---|---|---|
| 确定性功能 | UI、导航、状态、保存、编辑、删除、搜索、标签、导出 | T01–T20 **100% 通过** |
| 概率性功能 | OCR、姓名/公司/职位/电话/邮箱/地址识别 | 固定测试集 + Ground Truth，计算字段级准确率，保留全部中间结果 |

---

## 2. 当前阶段

> 唯一进度口径。每个 Gate 必须能点开到证据文件。

| 阶段 | 内容 | 关键 change | 状态 | 证据 |
|---|---|---|---|---|
| P0 | 基线、工程契约、跨机验证链路 | — | 完成（G0 待真实验证） | `project.yml` / `bash scripts/verify.sh` |
| P1 | 黑盒观察与规范冻结（11 份能力规范、T01–T20） | — | 规范完成；观察待补 | `openspec/specs/`、`docs/traceability.md` |
| P2a | 逻辑层 `BizScanCore`（模型、解析、vCard、搜索、标签） | 待建 | **代码完成，未验证** | `Packages/BizScanCore/`、`docs/verification-debt.md` |
| P2b | 应用骨架与数据层 | `0001-app-skeleton` | 代码完成，未验证 | `BizScan/App`、`Repositories/` |
| P3 | 采集与几何校正 | `0002-capture-import`、`0003-boundary-perspective` | 代码完成，未验证 | `Services/CameraService`、`CardDetection`、`ImageCorrection` |
| P4 | OCR 与字段结构化 | `0004-ocr-pipeline`、`0005-field-parser` | 代码完成，未验证 | `Services/OCRService`、`Packages/BizScanCore` |
| P5 | 人工校正与落库 | `0006-verification-save` | 代码完成，未验证 | `Views/ReviewView`、`Repositories/` |
| P6 | 管理闭环与导出 | `0007-manage-search-tags`、`0008-export` | 代码完成，未验证 | `Views/DetailView`、`SearchView`、`Services/VCardExporter` |
| P7 | 验收、回归与归档 | `0009-acceptance-hardening` | 未开始 | — |

> 「未验证」不是完成。所有未执行的测试登记在 **[`docs/verification-debt.md`](docs/verification-debt.md)**，必须由真实执行结果关闭。

Gate 定义见第 8 节。

---

## 3. 参考环境（必须先冻结）

实现行为以锁定的参考版本为准，不跟随 CamCard 升级。逐项填写 `docs/reference-env.md`：
参考版本、iOS 版本、设备/模拟器、App 语言、登录状态、免费功能边界、测试名片集、Reference Test Suite。

> 状态：**待填写**。P1 Gate 要求该表冻结后才允许进入实现阶段。

---

## 4. 技术栈

| 项 | 选择 |
|---|---|
| UI / 架构 | SwiftUI + MVVM（`@Observable`）+ Repository |
| 并发 | Swift Concurrency（`@MainActor` + 后台 `Task`） |
| 持久化 | SwiftData；图像存沙盒相对路径 |
| 相机 | AVFoundation |
| 几何 | Vision 矩形检测 + Core Image 透视校正 |
| OCR | Vision `VNRecognizeTextRequest`（`zh-Hans` + `en-US`，`.accurate`） |
| 导出 | vCard（首选，可自动化测试）；系统通讯录为可选 |
| 工程生成 | XcodeGen（`project.yml`，`.xcodeproj` 不入库） |
| 测试 | XCTest（单测）+ XCUITest（T01–T20） |
| 规范 | OpenSpec 1.14.3（`spec-driven` schema） |

选型依据：参考项目 `CardScanner` 使用 Apple Vision（`CardScanner/Classes/CardScanner.swift:288`），无第三方依赖、可离线、可回归；本项目沿用并补足中文语言参数、名片矩形检测与字段解析。

---

## 5. 目录结构

```
BizScan/
├─ 要求/                      # 原始作业与参考资料（只读）
├─ openspec/
│  ├─ config.yaml             # OpenSpec 配置（zh-CN，spec-driven）
│  ├─ project.md              # 全局上下文：技术栈、边界、工程标准
│  ├─ AGENTS.md               # 智能体操作规程（人机契约）
│  ├─ specs/                  # 基线规范（11 个能力，唯一真实源）
│  └─ changes/                # 增量变更沙箱
│     └─ archive/             # 已验证并归档的变更
├─ docs/
│  ├─ reference-env.md        # 参考环境锁定表
│  ├─ observation/            # 黑盒观察：页面/状态/流程/异常/截图
│  ├─ traceability.md         # T01–T20 ↔ 规范 ↔ 测试
│  ├─ verify/                 # 每个 change 的验证证据
│  ├─ eval/                   # OCR 与字段准确率报告
│  └─ regression-log.md       # 回归基线
├─ fixtures/                  # 测试名片集 + Ground Truth + manifest
├─ Packages/BizScanCore/      # 平台无关逻辑层（SwiftPM，可在 Windows/macOS 测试）
│  ├─ Sources/BizScanCore/    # 模型、字段解析、号码分类、vCard、搜索、标签
│  └─ Tests/BizScanCoreTests/ # L1 单元测试
├─ BizScan/                   # 应用源码（App/Models/ViewModels/Views/Services/Repositories）
├─ BizScanTests/              # 单元测试
├─ BizScanUITests/            # UI 测试（T01–T20）
├─ bash scripts/verify.sh          # 唯一验证入口（macOS）
├─ project.yml                # XcodeGen 工程定义
├─ Makefile                   # 快捷命令
└─ .trae/                     # OpenSpec 生成的 Trae skills/commands
```

---

## 6. SDD 工作流

### 6.1 五阶段闭环

| 阶段 | 本仓库动作 | 命令 | 产物 |
|---|---|---|---|
| Specify | 观察并写基线规范 | 编辑 `openspec/specs/`（仅 P1 允许）、`openspec validate --all --strict` | 11 份能力规范 + T01–T20 |
| Plan | 发起增量变更 | `openspec new change <id>` 或 Trae `/opsx-propose` | `proposal.md` / `design.md` / `tasks.md` / `specs/<cap>/spec.md` |
| Tasks | 原子任务拆解 | 同上 | `tasks.md` 勾选清单 |
| Implement & Test | 受控编码 + 自愈 | Trae `/opsx-apply <id>`；macOS `bash scripts/verify.sh --change <id>` | 代码 + 测试 + `docs/verify/<id>.md` |
| Archive | 合并增量规范 | `openspec archive <id>` | 更新 `openspec/specs/` |

### 6.2 规范语法（OpenSpec 约定）

```markdown
### Requirement: Capture Card
系统 SHALL ...

#### Scenario: T04 Capture 确认进入识别
- **GIVEN** ...
- **WHEN** ...
- **THEN** ...
```

- 需求名英文、正文中文、`SHALL/MUST` 保留英文关键字。
- 场景名必须以 `Txx` 开头，便于 `docs/traceability.md` 追踪。
- 增量变更使用 `## ADDED Requirements` / `## MODIFIED Requirements` / `## REMOVED Requirements`。
- **禁止直接修改 `openspec/specs/`**（P1 冻结期除外）；行为变化必须走 change。

### 6.3 变更命名

`NNNN-kebab-case`，编号单调递增：`0001-app-skeleton`、`0002-capture-import` …

一个 change = 一个可命名的行为增量；超过 8 个任务必须拆分。

---

## 7. 跨机协作（本机编辑 / 他机验证）

本机为 Windows，**无法执行 iOS 构建**。因此约定：

| 角色 | 可以做 | 禁止 |
|---|---|---|
| Windows（编辑机） | 写规范、写 Swift 源码与测试、`openspec validate`、Git 提交 | 声称"已验证"、手写 `.xcodeproj` |
| macOS（验证机）或 GitHub Actions | `xcodegen generate`、`xcodebuild test`、产出证据 | 直接改规范（除非新开 change） |

### 7.1 macOS 验证流程

```bash
git pull
brew install xcodegen                 # 首次
bash scripts/verify.sh --change <change-id>     # 全量
bash scripts/verify.sh --scope unit --change <change-id>
```

> 如果克隆后脚本没有执行权限：`chmod +x scripts/verify.sh`。用 `bash` 前缀调用可绕过该问题。

脚本会：生成工程 → 跑测试 → 写 `artifacts/verify-*.log` 与 `.xcresult` → 提示回填报告。

### 7.2 GitHub Actions

`.github/workflows/ios.yml` 在 push / PR 时于 `macos-14` 上执行同一套测试，并上传 `artifacts/`（保留 14 天）。CI 通过不等于人工验收通过，证据仍需写入 `docs/verify/`。

### 7.3 交接规则

1. 编辑机提交前必须通过：`openspec validate --all --strict`。
2. 验证机拉取后不修改源码；只产出证据并提交 `docs/verify/<id>.md`。
3. 证据必须包含环境（Xcode、模拟器、设备）与每条场景的 PASS/FAIL。
4. 验证失败时：先修实现或测试，再重跑；**禁止**通过放宽断言变绿。

---

## 8. 质量门禁（Gate）

| Gate | 准入条件 | 通过标准 |
|---|---|---|
| G0 | P0 完成 | macOS/CI 能生成工程并跑通冒烟测试；README 交接流程可照做 |
| G1 | P1 完成 | `openspec validate --all --strict` 全绿；T01–T20 全部有规范场景与测试映射；参考环境冻结；测试资产入库 |
| G2 | P2 完成 | 单测 + T01/T13 通过；列表/空态/详情与规范一致 |
| G3 | P3 完成 | T02–T06、T20 相关路径通过；八类拍摄条件有检测报告 |
| G4 | P4 完成 | T07–T10 通过；字段级准确率基线报告产出；虚构字段测试为 0 |
| G5 | P5 完成 | T11/T12/T18 通过；Kill App 后图像、字段、标签、备注完整 |
| G6 | P6 完成 | T14–T17、T19 通过 |
| G7 | P7 完成 | T01–T20 20/20；全量回归通过；全部 change 归档；`openspec/specs/` 与实现一致 |

每个 Gate 完成后必须更新第 2 节的状态表并链接证据。

---

## 9. 验证与证据规范

- 唯一验证入口：`bash scripts/verify.sh`（等价于 `xcodebuild test`）。
- 每个 change 一份 `docs/verify/<change-id>.md`，模板：`docs/verify/TEMPLATE.md`。
- 报告必含：环境、命令、逐条 Requirement/Scenario 结果、回归结果、偏差与等级、结论。
- 偏差等级：**阻断**（不能归档）、**严重**（可归档但必须新开 change 修复）、**一般**（记录即可）。
- 产物目录：`artifacts/`（日志与 `.xcresult`，不入库）。

---

## 10. 测试矩阵

T01–T20 的规范位置与测试类见 **[`docs/traceability.md`](docs/traceability.md)**。

分层策略：

| 层 | 范围 | 数量级 |
|---|---|---|
| 单元测试 | 字段解析、号码分类、vCard 映射、排序、模型约束 | 快，每次提交都跑 |
| 集成测试 | 检测 → 校正 → OCR 管线（固定图片 fixture） | 中等 |
| UI 测试 | T01–T20 全链路 | 慢，提交前与 CI 跑 |

---

## 11. 概率性功能评估

链路必须保留：`原始名片 → OCR Raw Text → Structured Fields → Manual Correction → Final Contact`。

评估步骤：

1. 对 `fixtures/` 全量跑识别，保存原始文本与解析结果（JSON）。
2. 与 `fixtures/ground_truth/*.json` 对比：归一化后按字段判等。
3. 统计每字段精确率/召回率；**虚构字段单独计数并惩罚**。
4. 错误分类：字段歧义、人名/公司混淆、多号码、中英混排、字段缺失、OCR 错字。
5. 报告写入 `docs/eval/`，并在 README 阶段看板登记。

准确率不达标不阻断归档，但必须记录原因与改进项；**虚构字段**视为阻断缺陷。

---

## 12. AI 协作与能力边界

- 每个 change 记录：使用的 prompt（范围）、AI 产出、人工修正点、回归结果。
- 一次 prompt 只授权一个 change 的文件范围；禁止「生成整个 App」。
- AI 代码进入主线前必须通过 `openspec validate --strict` 与 `bash scripts/verify.sh`。
- 对 AI 的高风险判断做专门记录：字段歧义（`Apple`）、人名/公司混淆（`Jordan Lee` / `Lee Consulting`）、无标签多号码、字段缺失时的"合理猜测"。
- 结论写入 `docs/ai-collaboration/`（按 change 建文件）。

---

## 13. 常见问题

| 现象 | 排查 |
|---|---|
| `xcodegen: command not found` | `brew install xcodegen` |
| 模拟器找不到 | `xcrun simctl list devices available`，改 `DESTINATION` 环境变量 |
| UI 测试点不到元素 | 为关键控件补 `accessibilityIdentifier`，命名统一 `BizScan.<区域>.<元素>` |
| `openspec validate` 报 Purpose 过短 | Purpose ≥ 50 字符；严格模式会把 warning 当失败 |
| `openspec validate` 报需求文本过长 | 把表格/示例移到 `## 数据模型` 或场景中 |
| OCR 无输出 | 确认方向校正结果、语言参数、图像对比度；查看 `docs/eval/` 原始文本 |

---

## 14. 已知限制

- 本项目为黑盒行为复刻，**不包含** CamCard 的专有模型、算法与资源。
- OCR 与字段抽取为概率性结果，允许与参考 App 不一致，但必须可解释、可校正、可评估。
- 相机相关场景只能在真机或注入图片的测试路径验证；模拟器无相机。
- 参考项目 `CardScanner` 仅演示"固定取景框 + Vision OCR"，**不含**矩形检测、透视校正、持久化与分层架构；本项目在其基础上重写，不复用其单文件结构。

---

## 15. 参考与致谢

- 作业要求与验收标准：`要求/01.md`
- 同类产品交互参考：`要求/02.md`（扫描全能王，注意：非 CamCard，仅作交互参考）
- SDD / OpenSpec / Agentic Coding 方法论：`要求/03SDD.md`
- 相机与 Vision 集成参考：[`CardScanner`](../CardScanner)（MIT），差异见第 14 节

---

## 16. 许可

课程作业仓库。第三方代码与素材在引入时单独标注来源与许可证。
