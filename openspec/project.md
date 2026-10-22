# BizScan iOS Project Context

> 本文件是 OpenSpec 的全局项目上下文（单一真实源之一）。
> 任何 change 的 proposal / design / tasks / delta spec 都必须与本文件一致；冲突时以本文件为准，并通过 change 修改本文件。

## 1. 项目是什么

BizScan 是课程作业「基于 SDD + TRAE 的 CamCard（名片全能王）功能切片 100% 黑盒复刻」的实现工程。

复刻对象是**一个封闭、可测试的业务切片**，不是完整 App：

```
名片夹/Home → 扫描名片 → 拍摄/图片导入 → 名片区域检测 → 透视/方向校正
→ OCR 文字识别 → 联系人字段解析 → 人工确认与修改 → 保存名片
→ 名片夹 → 搜索/标签/查看详情 → 联系人导出
```

验收口径见 `要求/01.md`：确定性功能要求 Reference Test Suite 100% 通过；概率性功能（OCR 与字段抽取）用固定名片集 + Ground Truth 计算字段级准确率，并保留原始输出、解析结果、人工校正与错误分析。

## 2. 复刻边界

In scope（必须实现）：

- 名片夹首页、空状态、列表刷新
- 相机拍摄、相册导入、权限申请与拒绝路径、重拍/取消
- 名片区域检测、自动裁剪、透视校正、方向校正、手动调整
- OCR 原始文本采集与留痕
- 八个必选字段解析：`name` `company` `jobTitle` `mobile` `phone` `email` `website` `address`
- Human-in-the-Loop 校正、保存、详情、编辑、删除
- 搜索、标签、备注
- 本地持久化（Kill App 后数据仍在）
- 联系人导出（VCF/vCard 或系统通讯录）
- T01–T20 全部确定性验收场景

Out of scope（禁止在本项目实现，避免范围漂移）：

- 注册/登录/会员/订阅/支付/广告
- 云端账户同步、多设备同步、团队名片库、CRM/Salesforce 同步
- 数字名片、模板、QR 名片交换、Email Signature、Virtual Background
- AI 企业情报、公司分析、财务分析、AI 商务建议
- 会议录音/总结、销售漏斗

完整排除清单见 `要求/01.md` 第十五章。

## 3. 技术栈（锁定，变更需走 change）

| 项 | 选择 | 说明 |
|---|---|---|
| 平台 | iOS 17.0+ | 使用 SwiftData 与 Observation |
| 语言 | Swift 5.9 | 不使用第三方依赖，除非先在 design.md 论证 |
| UI | SwiftUI | 主界面、导航、状态驱动 |
| 架构 | MVVM + Repository | ViewModel 持有业务状态，View 只读状态与派发意图 |
| 并发 | Swift Concurrency | `async/await`、`@MainActor`；图像处理放后台 Task |
| 持久化 | SwiftData | 图片写入 Application Support 目录，模型只存相对路径 |
| 相机 | AVFoundation | `AVCaptureSession` + `AVCaptureVideoDataOutput` |
| 几何 | Vision + Core Image | `VNDetectRectanglesRequest`（或文档分割）+ `CIPerspectiveCorrection` |
| OCR | Vision | `VNRecognizeTextRequest`，`.accurate`，`recognitionLanguages = ["zh-Hans", "en-US"]` |
| 导出 | Contacts + VCF 文本 | 二选一必须先跑通 VCF（无权限依赖，易测试） |
| 工程生成 | XcodeGen（`project.yml`） | `.xcodeproj` 不入库，Mac 端生成 |
| 单元测试 | XCTest | `BizScanTests` |
| UI 测试 | XCUITest | `BizScanUITests`，对应 T01–T20 |

OCR 选型依据：参考项目 `CardScanner/Classes/CardScanner.swift:288` 使用 Apple `Vision`，无第三方依赖、可离线、可回归；本项目沿用该路线，并补充中文语言参数与名片字段规则。

## 4. 工程标准

- 目录即分层：`App/`、`Models/`、`ViewModels/`、`Views/`、`Services/`、`Repositories/`。新增文件必须落在既有分层内。
- 业务状态只存在于 `@Observable @MainActor final class XxxViewModel`。View 不持有可变业务状态。
- 服务必须可注入：`OCRService`、`CardDetector`、`ContactExporter`、`BusinessCardRepository` 均以协议暴露，便于测试替身。
- 错误必须显式建模（`enum XxxError: LocalizedError`），禁止用空 `try?` 吞掉用户可见失败。
- 用户可见文案中文；代码标识符英文；注释只在解释"为什么"时添加。
- 禁止在 View 内做 OCR、图像几何变换或磁盘 IO。
- 单文件超过 400 行时必须拆分，拆分放在同一 change 内完成。

## 5. 数据与隐私

- 测试名片全部使用合成数据，禁止真实个人电话、邮箱、住址。
- 示例字段值使用 `xxx` 占位（如 `+86 138xxxx0000`、`david.chen@example.com`）。
- 原始名片图与处理后图像保留在本地，不上传任何服务器。

## 6. 规范资产约定

| 路径 | 语义 |
|---|---|
| `openspec/specs/<capability>/spec.md` | **基线规范**：黑盒观察得到、必须被实现的行为合同（as-target） |
| `openspec/changes/<id>/` | **增量**：proposal → specs delta → design → tasks，实施与验证的单位 |
| `openspec/changes/archive/` | 已归档且验证通过的变更 |
| `docs/observation/` | 黑盒观察记录（页面、状态、异常、截图索引） |
| `docs/traceability.md` | T01–T20 ↔ 规范场景 ↔ 测试类 映射 |
| `docs/verify/<change>.md` | 每个 change 的验证证据（03SDD 第四阶段报告） |
| `fixtures/` | 教师名片集、Ground Truth、期望输出 |

规则：

1. `openspec/specs/` 是唯一基线。**禁止在实施阶段直接编辑它**，任何行为变化必须通过 change 的 `## MODIFIED / ## ADDED` 增量表达，并在 `openspec archive` 时合并。
2. 每个 change 的 `tasks.md` 必须能独立验证；一个 change 只解决一个可命名的行为增量。
3. 需求标识使用 `### Requirement: <英文名>`；场景使用 `#### Scenario: Txx <中文描述>`，Txx 必须能在 `docs/traceability.md` 找到。

## 7. 命令

```bash
# 规范
openspec list --specs
openspec validate --all --strict
openspec show <change-id>

# 工程与测试（macOS）
xcodegen generate --spec project.yml --project BizScan.xcodeproj
scripts/verify.sh --change <change-id>          # 全量
scripts/verify.sh --scope unit --change <id>    # 只跑单测
make verify / make unit / make ui / make specs

# 归档（验证通过后）
openspec archive <change-id>
```

Windows 端只做规格与编码，不执行 `xcodebuild`；验证在 macOS 或 GitHub Actions（`.github/workflows/ios.yml`）完成。

## 8. AI 协作纪律

- 一次 prompt 只授权一个 change 的文件范围；禁止"生成整个 App"式请求。
- AI 生成代码进入主线前必须：`openspec validate --strict` + `scripts/verify.sh` + 人工检查证据。
- 字段抽取禁止推断补全：不存在的信息必须为 `nil` 或空字符串，并保留判定依据。
- 每次修改既有模块，必须重跑该模块及全量回归，并在 `docs/verify/<change>.md` 记录"未回归项"。
- 修改前先读现有实现与测试，不得凭想象重写接口。
