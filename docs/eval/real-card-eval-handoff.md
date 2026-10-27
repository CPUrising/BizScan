# 真实名片评估 · 交接说明

> 用途：新对话开始前，把本文件全文贴给 AI。
> 主题：用 `card_test/` 里的 14 张真实名片补 OCR/字段准确率证据。
> 状态：`card_test/` 仅存在于本机、已加入 `.gitignore`，未入库。

---

## 1. 一句话背景

BizScan 的自动化测试已全绿（core 62 + L2 50 + UI 11），全部 14 个 OpenSpec change 已归档（0001–0014）。唯一遗留的验收缺口是：**准确率证据只有自建合成数据（`synthetic-001`），没有真实名片**。`card_test/` 就是补这块的素材。

---

## 2. 必读文档

### 2.1 第一层：必须完整读完（决定你不能做什么）

| 文件 | 为什么必读 |
|---|---|
| `openspec/AGENTS.md` | 工作循环（Plan→Check→Build→Verify→Merge）、禁止放宽断言/跳过用例/伪造结果、第 7 节「编辑端 ↔ 验证端」分工与模拟器故障处理 |
| `openspec/project.md` | 项目边界（In/Out of scope）、锁定技术栈、工程标准（第 4 节）、数据与隐私（第 5 节：**测试名片必须合成数据，禁止真实个人信息**）、规范资产约定（第 6 节）、AI 协作纪律（第 8 节） |
| `README.md` | 第 2 节阶段看板（唯一进度口径）、第 8 节 Gate 判定（G4 要求准确率基线、G7 要求 T01–T20 20/20）、第 11 节概率性功能评估的 5 个步骤 |
| `要求/01.md` | 课程验收原文：确定性功能需 Reference Test Suite 100% 通过；概率性功能需「固定名片集 + Ground Truth」并**与参考 App 结果比较**、保存原始输出、错误分析、允许人工校正 |
| `docs/eval/ocr-field-baseline.md` | 现有评估口径（归一化规则、correct/wrong/missing/fabricated 定义、`EVAL_SUMMARY` 结构、误差分类）。新报告必须同口径，否则两份无法比较 |

> `要求/01.md` 是**单行超长文本**（无换行符），`grep ^#` 找不到章节。用编辑器直接打开，或用 Python 按关键词定位。

### 2.2 第二层：按需精读（写代码/写报告前必看）

| 文件 | 用途 |
|---|---|
| `openspec/specs/ocr/spec.md` | T07 的行为合同（OCR 只输出原始文本+坐标，不做字段映射） |
| `openspec/specs/field-extraction/spec.md` | T08–T10 的字段分类合同，含「不得虚构」硬约束 |
| `openspec/specs/card-detection/spec.md` | T06 检测合同与八类拍摄条件 |
| `openspec/specs/capture/spec.md` | T02–T05、T20 权限/拍摄/导入/退出 |
| 其余 7 个 spec | `card-list`、`card-detail`、`card-model`、`export`、`persistence`、`search-tags`、`verification`；真实名片评估只直接涉及前四个，其余可不读 |
| `fixtures/README.md` | 目录约定、case id 规范（`c001`）、manifest 字段取值（`language` 只允许 `zh-Hans / en / mixed`）、评估口径、接收检查清单 |
| `fixtures/ground_truth.schema.json` | GT 的合法结构：`id` 必须匹配 `^c[0-9]{3}$`，未出现的字段必须省略或 null |
| `fixtures/manifest.json` | 当前只有 c001–c003 三条**占位**声明，`cards/` 与 `ground_truth/` 实际为空 |
| `BizScanTests/OCREvaluationDataset.swift` | 合成 15 例的构造方式 + `EvalNormalizer` 归一化实现 |
| `BizScanTests/OCREvaluationTests.swift` | 计数逻辑、`EVAL_SUMMARY` 输出格式、明细落盘方式；新用例应复用这套结构 |
| `docs/verify/TEMPLATE.md` | 验证报告五节结构（基本信息 / 需求覆盖 / 回归 / 偏差与风险 / 结论） |
| `docs/verify/0014-ocr-eval-baseline.md` | 评估类 change 的报告范本 |
| `docs/traceability.md` | T01–T20 的当前状态与测试映射，结论要回填到这里 |
| `docs/verification-debt.md` | 未验证项台账，含 K1 已知产品偏差 |
| `docs/regression-log.md` | 回归基线追加规则 |

### 2.3 第三层：知道存在即可（需要时再查）

| 路径 | 说明 |
|---|---|
| `openspec/changes/archive/2026-10-27-*/` | 14 个已归档 change，含 proposal/design/tasks。查「为什么这样设计」时读 `0011`–`0014` |
| `docs/reference-env.md` | 参考环境锁定表，**只填了实现环境，CamCard 版本/语言/免费边界仍为「待填写」** |
| `docs/observation/README.md` | 黑盒观察记录，内容基本为「待补」 |
| `要求/02.md` | CamCard 界面与操作流程解析，写观察记录时参考 |
| `要求/03SDD.md` | SDD 方法论与 OpenSpec 五阶段案例，理解报告格式来源 |
| `Makefile`、`scripts/verify.sh`、`scripts/verify-core.ps1` | `make unit / ui / verify / specs` 的入口 |
| `.github/workflows/ios.yml` | CI 定义 |

---

## 3. 当前尚未满足的验收要求（不要在不知情下宣称已完成）

| 要求 | 出处 | 现状 |
|---|---|---|
| 30–50 张名片统一测试 | `要求/01.md` | 只有 14 张（原 15 张，c009 已删除），且部分非实拍 |
| 与参考 App（CamCard）结果比较 | `要求/01.md` | **完全未做**，`docs/reference-env.md` 版本未锁定 |
| AI 协作记录 | `要求/01.md`、`README.md` 第 12 节 | `docs/ai-collaboration/` **为空目录** |
| AI 能力边界分析 | `要求/01.md` | 未产出 |
| 检测报告 / 校正报告 | `README.md` 第 11 节、`0009` tasks 2.2 | `docs/eval/` 只有 OCR+字段合并版 |
| 真机 5 项 | `docs/verify/manual-device-checklist.md` | T03–T05、T06 倾斜、T18 kill、T19 分享、T20 重拍，全部未执行 |

> 这 6 项中，**真实名片评估只能推进第 1 项**。其余不要顺手扩张，也不要因为做了评估就宣称 G4 或 G7 通过。

---

## 4. `card_test/` 的已知事实

```
card_test/
├─ english/  6 张
├─ zh_sp/    4 张（简体；原 5 张，c009 已删除）
└─ zh_tw/    4 张（繁体）
```

- 共 14 张：`.jpg` 13、`.png` 1（原 `.webp` 的 c009 已删除）。
- 分辨率：最小 400×236，最大 1000×695，多数 400–800，**偏低**，Vision 检测可能失败。
- 至少 2 张是设计稿/模擬图而非实拍（`zh_tw/BUA1LS0009-letterpress名片正面模擬-20231019.jpg`、`english/emily-thompson-business-card-designed-by-zoviz-business-card-maker.jpg`），可能含假信息或水印。
- 文件名含空格、括号、中文，且多个同名 `images*.jpg`，**不能直接入库**，需重命名为 `c001`… 规范。

---

## 5. 硬约束（不可违反）

1. **Ground Truth 必须人工确认**。AI 可读图起草，但必须由你逐条核对；报告注明「AI 起草 + 人工确认」。**禁止**把 App 自己的 OCR 输出反填成 GT —— 自证循环，评估作废。
2. **真实个人信息不得入库**。`card_test/` 已在 `.gitignore`；不得原样拷进 `fixtures/cards/`。要入库必须先脱敏（替换姓名/号码/邮箱/地址）。
3. **不设准确率阈值**。只报实测值；`fabricated == 0` 是唯一硬门槛。
4. **不改产品代码调参**。准确率低就记录原因与改进项，另开 change 修 `FieldParser`。
5. **不宣称 G7 通过**。真实名片评估只补 G4 的准确率证据。
6. **不改 `openspec/specs/`**。本任务只补证据，`.openspec.yaml` 写 `skip_specs: true`。

---

## 6. 分工

### AI 可以做

- 读图、起草每张卡片的字段草稿与 GT JSON 草稿（显著标注「待人工确认」）。
- 写评估测试：新增用例从磁盘读取图片 + GT，复用 `EvalNormalizer` 与 `correct/wrong/missing/fabricated` 计数。
- 写报告骨架、归一化说明、误差分类表、局限与改进项。
- 编译校验：`xcodegen generate` + `xcodebuild build-for-testing`（智能体终端可跑通）。
- `openspec validate --all --strict`。
- 重命名文件、生成 manifest、维护 `.gitignore`。

### 必须由你做（AI 不能替代）

| 事项 | 原因 |
|---|---|
| 逐条确认 Ground Truth | AI 读图会出错，GT 错则整份评估作废 |
| 决定 `card_test/` 是否入库、是否脱敏 | 隐私与合规由你判断 |
| 判定哪些图算有效样本 | 设计稿/模擬图/带水印图是否算数，是产品判断 |
| 判定模糊语义 | 人名 vs 公司、繁体字形、竖版阅读顺序，属语义而非 OCR 能力 |
| 在本地终端执行 `bash scripts/verify.sh` | 智能体终端无法驱动模拟器（见第 9 节） |
| 决定真实集是替换还是并列于 `synthetic-001` | 影响 README 与 Gate 口径 |
| 决定是否补「与 CamCard 结果比较」 | 需要先锁定参考版本，属你的决策 |

---

## 7. 推荐执行路径

1. 先回答第 8 节的 5 个问题，再动代码。
2. 新建 change（建议 `0015-real-card-eval`，`skip_specs: true`）：proposal 写数据集来源、隐私处理、与 `synthetic-001` 的关系；design 写 GT 标注流程与归一化口径（必须与 `0014` 一致）。
3. 重命名 + 生成 `fixtures/manifest.json`（若决定入库）；否则在 `docs/eval/real-cards/` 只放 GT 与聚合结果，图片路径写本地绝对路径并注明「图片不入库」。
4. 新增 `RealCardEvaluationTests`，输出与 `0014` 相同的 `EVAL_SUMMARY` 结构；`OCREvaluationDataset` 的合成数据保持不变。
5. 由你在本地终端跑 `bash scripts/verify.sh --scope unit --change 0015-real-card-eval`，把日志尾部贴回。
6. 回填 `docs/eval/real-card-baseline.md`、`docs/verify/0015-*.md`、`docs/traceability.md`、`docs/verification-debt.md`、`docs/regression-log.md`、README 第 2/11 节。
7. `openspec validate --all --strict`，然后**等用户批准**再 `openspec archive`。

---

## 8. 开工前必须问用户的 5 个问题

1. `card_test/` 是否允许入库？若允许，是否接受先脱敏（替换姓名/电话/邮箱/地址）？
2. 14 张里那几张设计稿/模擬图/带水印图，算有效样本还是排除？
3. 这份真实集是**替换** `synthetic-001` 作为唯一基线，还是**并列**保留两份？
4. `zh_tw/` 繁体样本，`manifest.json` 的 `language` 目前只允许 `zh-Hans / en / mixed`，是新增 `zh-Hant`（需改 `fixtures/README.md`），还是并入 `zh-Hans`？
5. 是否同时补「与 CamCard 参考 App 结果比较」？若补，需要你先锁定 `docs/reference-env.md` 的 CamCard 版本。

---

## 9. 已踩过的坑

| 现象 | 结论 |
|---|---|
| 智能体终端跑 `xcodebuild test` 必卡 `DTServiceHubClient failed to bless service hub` / `The test runner hung before establishing connection` | 环境限制，非代码问题。**所有 `verify.sh` 由用户在本地终端执行**；AI 只用 `build-for-testing` 做编译校验 |
| `ImageCorrectorTests` 尺寸断言曾恒为期望值 3 倍 | `UIGraphicsImageRenderer` 默认 scale=3；造图必须 `format.scale = 1` |
| `CropViewModelTests` 报 `Cannot find 'OCRObservation'` | 测试文件需 `import BizScanCore` |
| zsh 里 `echo ===` 报 `== not found` | 用 `echo "---"` 或加引号 |
| 模拟器白屏/装不上 | `simctl shutdown all` + `simctl erase <udid>` 重建，作为偏差记入报告 |
| `CoreData: fault: Could not materialize ...` / `vnode unlinked while in use` | `PersistenceTests` 临时库反复建删的噪声，不影响结论 |
| `要求/01.md` 用 grep 查章节查不到 | 单行超长文本，用编辑器或 Python 定位 |

---

## 10. 交付物清单

- `openspec/changes/<id>/` 四件套 + `.openspec.yaml`（`skip_specs: true`）
- 评估测试代码（新文件，不改 `OCREvaluationDataset` 的合成数据）
- `docs/eval/real-card-baseline.md` + 逐例明细 JSON
- `docs/verify/<id>.md`（五节结构，含实际日志与 `.xcresult` 路径）
- `docs/traceability.md` / `docs/verification-debt.md` / `docs/regression-log.md` / `README.md` 四处口径更新
- 若图片入库：`fixtures/manifest.json` + `fixtures/ground_truth/c0xx.json`（须符合 schema）
