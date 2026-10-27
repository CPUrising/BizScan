# AI 协作记录

> 依据：`README.md` 第 12 节、`要求/01.md` 第六章与第十八章。
> 规则：一个 change 一份记录，写清「prompt 范围 → AI 产出 → 人工修正点 → 回归结果」，并对高风险判断单独留痕。
> 未建立独立记录的历史 change 在下方索引里标注原因，不补写、不推测 prompt 原文。

## 1. 索引

| change | 记录文件 | prompt 来源 | 说明 |
|---|---|---|---|
| `0001`–`0008` | — | 无独立 prompt 留痕 | 八个 change 均无独立验证批次（各自报告 D1 已声明），代码由同一轮连续生成；不补写 prompt，避免事后编造 |
| `0009-acceptance-hardening` | [0009](0009-acceptance-hardening.md) | `chat_history/Chat01.md` | 验收硬化、UI 测试补齐 |
| `0010-toolchain-compile-fixes` | [0010](0010-toolchain-compile-fixes.md) | `chat_history/Chat01.md` | 首次真实编译与工具链修复 |
| `0011-l2-test-coverage` | [0011](0011-l2-test-coverage.md) | `chat_history/chat02.md` | L2 测试补齐 |
| `0013-service-layer-coverage` | [0013](0013-service-layer-coverage.md) | `chat_history/chat02.md` | 服务层测试与人工清单 |
| `0014-ocr-eval-baseline` | [0014](0014-ocr-eval-baseline.md) | `chat_history/chat02.md` | 合成评估基线 |
| `0015-real-card-eval` | [0015](0015-real-card-eval.md) | `chat_history/chat03.md` | 真实名片评估基线 |

## 2. 记录格式

每份记录包含四节，缺一不可：

1. **prompt 范围**：本次授权改哪些文件、明确不做什么。引用用户原话或对话摘要，注明出处。
2. **AI 产出**：新增/修改的文件与关键决策。
3. **人工修正点**：人类改了什么、驳回了什么、补了什么判断。
4. **回归结果**：`docs/verify/<change>.md` 的用例数与失败数，链接到证据。

## 3. 高风险判断留痕

`README.md` 第 12 节要求对四类高风险判断专门记录。当前证据：

| 风险类型 | 用例 | 结论 | 证据 |
|---|---|---|---|
| 字段歧义（`Apple` 是公司还是产品） | `FieldParserTests.testAmbiguousSingleWordStaysUnresolved` | 不猜测，进 `unresolvedLines` | L1 通过（`0010`） |
| 人名 / 公司混淆（`Jordan Lee` / `Lee Consulting`） | `FieldParserTests.testPersonNameVersusCompanyName` | 合成样例可区分 | L1 通过；真实名片 c001、c014、c015 仍发生跨字段误判，见 [能力边界分析](../eval/ai-capability-boundary.md) |
| 无标签多号码 | `FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests` | 标签优先，无标签按号码形态 | L1 通过；真实名片出现一行两号被拼成一个号码 |
| 字段缺失时「合理猜测」 | `NoFabricationTests`（7 项） | 禁止补全，缺字段保持 nil | L1 通过；真实名片 `fabricatedTotal = 0`（`0015`） |

## 4. 当前缺口

- `0001`–`0008` 没有逐 change 的 prompt 原文，只有提案与验证报告；本目录不补造。
- `0012-evidence-and-doc-alignment` 是纯文档 change，无 `docs/verify/` 报告，故未建记录。
- 真机人工项（T03–T05、T18、T19）尚无执行记录，不能算「AI 协作已验证」。
