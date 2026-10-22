# AGENTS.md

本仓库使用 OpenSpec + SDD。所有 AI 智能体（TRAE、opencode 等）必须按本文件执行。

## 0. 开工前必读

1. `openspec/project.md`（技术栈、边界、工程标准）
2. `openspec/specs/`（当前基线规范）
3. `docs/traceability.md`（验收场景映射）
4. 本文件

任一文件缺失时，先报告，不要靠猜测补齐。

## 1. 角色与边界

- 人类：定义意图、批准 change、审查验证证据、决定归档。
- 智能体：读取上下文、拆解任务、编写代码与测试、运行验证命令、报告偏差。
- 智能体**没有**权限：扩大范围（实现 Out of scope 功能）、跳过测试、直接修改基线规范、伪造验证结果。

## 2. 工作循环（每个增量必须完整走完）

| 阶段 | 命令 | 智能体动作 | 产物 |
|---|---|---|---|
| Plan | `openspec new change <id>` 或 `/opsx-propose` | 写 proposal / design / tasks / 增量 spec | `openspec/changes/<id>/` |
| Check | `openspec validate <id> --strict` | 自检格式与完整性 | 校验通过 |
| Build | `/opsx-apply <id>` | 按 tasks.md 顺序改代码，逐个勾选 | 源码 + 测试 |
| Verify | `bash scripts/verify.sh --change <id>` | 跑测试、分析失败、最小修复、重跑 | 日志 + `docs/verify/<id>.md` |
| Merge | `openspec archive <id>` | 合并增量规范、清理变更目录 | 更新 `openspec/specs/` |

约束：

- Plan 阶段**禁止**修改项目代码（proposal/design/tasks 之外的文件一律不动）。
- Build 阶段只允许改 `tasks.md` 列出的文件；需要越界时先更新 tasks.md 并说明原因。
- Verify 阶段禁止通过"改测试断言"让失败变绿；必须说明是测试错误还是实现错误。
- Merge 只能由人类批准后执行。

## 3. 命名与规模

- change id：`NNNN-kebab-case`，例如 `0001-app-skeleton`、`0005-field-parser`。编号单调递增，不复用。
- 一个 change 只包含一个可命名的行为增量；超过 8 个任务时拆成两个 change。
- 需求名：英文短语（`Capture Card`、`Persist Business Card`）。
- 场景名：`Txx <中文描述>`，必须与 `docs/traceability.md` 一致。

## 4. 硬性技术约束

- 禁止引入第三方依赖，除非 design.md 中列出候选对比、许可证与体积影响，并获人类批准。
- OCR 与字段解析必须分离：`OCRService` 只返回原始文本与观察框，`BusinessCardFieldParser` 只做映射。
- 字段解析遇到不确定时返回 `nil`，**禁止推断名片上不存在的信息**（如凭空生成 `website`）。
- 每个 ViewModel 的公开方法都应有对应单元测试；每个 Txx 必须有对应 UI 测试或单测。
- 图像路径存相对路径；禁止把 `UIImage` 直接塞进持久化模型。
- 不得改动已通过验证的模块公开接口；需要改时新开 change 并写 `## MODIFIED`。

## 5. 验证与证据

- 唯一验证入口：`bash scripts/verify.sh`（macOS/CI）。Windows 端不得声称"已验证"。
- 每次验证必须产出 `docs/verify/<change>.md`，包含：
  - 环境（Xcode、模拟器、设备、系统版本）
  - 逐条 Requirement/Scenario 的 PASS/FAIL 与对应测试名
  - 未覆盖项与已知偏差（等级：阻断/严重/一般）
  - 结论：Ready for archive / 需修复
- 失败时先读日志定位（`artifacts/verify-*.log`），最多做 3 轮自愈；仍失败则停止并报告堆栈与假设。

## 6. 范围纪律（评分点）

- 任何"顺手优化"（重命名、重构、格式化无关文件）必须单独成 change。
- 概率性功能必须保留：`originalImage → OCR Raw Text → Structured Fields → Manual Correction → Final Contact` 全链路留痕。
- 评估报告必须包含错误分类（字段歧义、人名/公司混淆、多号码、中英混排、字段缺失、OCR 错字）。
- 测试数据必须为合成数据；不得提交真实个人信息。

## 7. 交接（Windows ↔ macOS）

Windows 端（本机）只允许：写规范、写 Swift 源码、写测试、跑 `openspec validate`、提交 Git。

macOS 端执行：

```bash
git pull
brew install xcodegen        # 首次
bash scripts/verify.sh --change <id>
```

验证结果回填到 `docs/verify/<id>.md` 并再次提交。README 的"阶段看板"是唯一进度口径。
