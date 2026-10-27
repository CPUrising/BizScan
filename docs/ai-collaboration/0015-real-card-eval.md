# 0015-real-card-eval · AI 协作记录

## 1. prompt 范围

出处：`chat_history/chat03.md`。

关键指令（按原意引用）：

1. "根据交接文档，完成项目任务，不是完成交接文档" —— 授权范围从写文档转为执行评估。
2. "禁止你亲自读图，交给另外一个子 agent" —— 主 AI 不接触图片内容，读图与 GT 起草全部下放给子 agent。
3. "核对 GT 完成，并且删除了 c009 及其对应图片" —— 人类完成 GT 确认并收缩数据集。
4. 三个决策：图片不入库（交由另一个 AI 完成标注）、与 `synthetic-001` 并列、不与 CamCard 对比。

授权范围：新增真实名片评估数据集、测试与报告；不改产品代码、不改 `openspec/specs/`、不改 `fixtures/`。

明确不做：不入库真实图片、不做图片脱敏重绘、不设准确率阈值、不做 CamCard 结果比较。

## 2. AI 产出

- `docs/eval/real-cards/README.md`：标注规则、case 映射、人工确认清单。
- `docs/eval/real-cards/index.json`：`c001`–`c015`（`c009` 已删）的路径、语言、方向、标签。
- `BizScanTests/RealCardEvaluationDataset.swift`：从 bundle 或仓库路径加载 14 例，复用 `EvalCase` / `EvalNormalizer`。
- `BizScanTests/RealCardEvaluationTests.swift`：跑 `ScanPipeline`，输出 `EVAL_SUMMARY`，明细写临时目录并附到 `.xcresult`。
- `docs/eval/real-card-baseline.md`、`docs/verify/0015-real-card-eval.md`。
- `project.yml`：把 `card_test/` 与 `docs/eval/real-cards/` 作为可选资源打进测试 bundle。

## 3. 人工修正点

| 事项 | 人类动作 |
|---|---|
| 读图与 GT 起草 | 明确禁止主 AI 读图，改由子 agent 逐张转写；主 AI 只做结构校验 |
| GT 核对 | 人类逐条确认，并删除 `c009` 及其图片 |
| 首轮失败 | AI 判断为「测试自身错误」（模拟器沙盒读不到仓库路径），人类重跑后确认修复成立 |
| 样本范围 | 人类决定设计稿与模板全部计入，不排除 |
| 归档 | 人类确认后 AI 执行 `openspec archive 0015-real-card-eval` |

## 4. 高风险判断

| 风险 | 本 change 的表现 |
|---|---|
| 字段歧义 | c001 把公司名解析成 `name`，人名行落入 `unresolvedLines` |
| 人名/公司混淆 | c014、c015 把职称当成 `name` |
| 无标签多号码 | c001 一行两号被拼成一个号码；c015 办公电话与传真互换 |
| 合理猜测 | 未发生：`fabricatedTotal = 0` |

详见 [真实名片基线 · 误差分类](../eval/real-card-baseline.md) 与 [AI 能力边界分析](../eval/ai-capability-boundary.md)。

## 5. 回归结果

core 62 + L2 52（新增 2 项）+ UI 11，0 失败；`detectionSucceeded = 11/14`、`casesWithOCRTex = 12/14`、`fabricatedTotal = 0`。
证据：[docs/verify/0015-real-card-eval.md](../verify/0015-real-card-eval.md)、[docs/eval/real-card-baseline.md](../eval/real-card-baseline.md)。
