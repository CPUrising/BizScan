# OCR 与字段准确率基线（synthetic-001）

> 生成方式：`BizScanTests.OCREvaluationTests.testEvaluateSyntheticCardSet` 真实执行 Vision 全链路后输出。
> 原始指标：`artifacts/verify-0014-ocr-eval-baseline-20261027-200320.log` 中的 `EVAL_SUMMARY` 段。
> 逐例明细：`docs/eval/raw/e01.json` … `e15.json`。

## 1. 数据集

| 项 | 值 |
|---|---|
| 来源 | **自建合成**（`fixtures/` 仍为空，教师资产未下发） |
| 版本 | `synthetic-001` |
| 样本量 | 15 例（< 30，仅报告绝对值，不宣称统计显著） |
| 合成方式 | `BizScanTests/OCREvaluationDataset.swift` 用 `UIGraphicsImageRenderer` 绘制 1400×900（竖版 900×1400）白底黑字名片，Ground Truth 与绘制文本同源 |
| 个人信息 | 无：号码统一 `138 0000 0000` 段，域名统一 `example.com` |

覆盖特征：

| id | 特征 | id | 特征 |
|---|---|---|---|
| e01 | 英文全字段 | e09 | 复杂噪声背景 |
| e02 | 中文全字段 | e10 | 两行地址 + 邮编 |
| e03 | 中英混排 | e11 | 人名/公司混淆（Jordan Lee / Lee Consulting） |
| e04 | 缺 website | e12 | 无标签号码 |
| e05 | 缺 email | e13 | 含部门行 |
| e06 | 两个手机 + 办公 + 传真 | e14 | 仅姓名 + 公司 |
| e07 | 竖版 | e15 | 全角字母/数字 |
| e08 | 低对比灰字 | | |

## 2. 环境

macOS 26.3.1 / Xcode 26.1.1（17B100）/ iPhone 16 模拟器 iOS 18.0；Vision `VNRecognizeTextRequest`，`recognitionLevel = .accurate`，`recognitionLanguages = ["zh-Hans", "en-US"]`，`usesLanguageCorrection = true`。

## 3. 逐字段指标

归一化口径：全角转半角、trim、折叠空白、小写；电话只留数字；邮箱小写；网址去协议/尾斜杠/`www.` 前缀。多值字段按集合比对。

| 字段 | 正确 | 错误 | 漏识 | 虚构 | 精确率 | 召回率 |
|---|---|---|---|---|---|---|
| name | 14 | 0 | 1 | 0 | 1.000 | 0.933 |
| company | 13 | 1 | 1 | 0 | 0.929 | 0.929 |
| jobTitle | 13 | 0 | 0 | 0 | 1.000 | 1.000 |
| department | 1 | 0 | 0 | 0 | 1.000 | 1.000 |
| mobiles | 12 | 0 | 0 | 0 | 1.000 | 1.000 |
| officePhones | 2 | 0 | 0 | 0 | 1.000 | 1.000 |
| faxes | 1 | 0 | 0 | 0 | 1.000 | 1.000 |
| emails | 9 | 1 | 2 | 0 | 0.900 | 0.818 |
| website | 2 | 0 | 0 | 0 | 1.000 | 1.000 |
| address | 6 | 0 | 0 | 0 | 1.000 | 1.000 |
| postalCode | 3 | 0 | 0 | 0 | 1.000 | 1.000 |

汇总：

- 虚构字段总数：**0**（README 第 11 节的阻断级要求已满足）。
- OCR 原始文本非空：**15/15**。
- 数据集用时：9.586 秒（15 例 × 检测 + 透视校正 + OCR + 解析）。

## 4. 逐例偏差

| 案例 | 字段 | 现象 | 归类 |
|---|---|---|---|
| e06 | emails | `wang.fang@example.com` 被识别为 `wana.fanq@example.com` | OCR 错字（字符级） |
| e09 | company | `Iota Studios` 被识别为 `lota Studios` | OCR 错字（`I`/`l` 混淆） |
| e15 | name | 全角 `Ｔｏｍ Ｌｉ` 经 OCR 输出为 `TomLi`（空格丢失），解析器单 token 非中文时不认作姓名，落入 `unresolvedLines` | OCR 分词 + 解析规则边界 |
| e15 | emails | OCR 在 `example` 中间插入空格（`examp le.com`），邮箱正则不匹配 | OCR 分词 |
| e10 | address | 第二行 `Chaoyang District, Beijing` 未并入地址，落入 `unresolvedLines` | 解析规则：地址只取单行（不虚构，但完整性不足） |

> 口径说明：e10 的 Ground Truth 只登记首行地址，因此该行未计入 `missing`；此项作为「地址续行合并」的改进项单独记录，不粉饰为通过。

## 5. 误差分类统计

| 类别 | 次数 | 说明 |
|---|---|---|
| OCR 错字（字符级） | 2 | e06 邮箱、e09 公司 |
| OCR 分词（空格丢失/插入） | 2 | e15 姓名、e15 邮箱 |
| 人名/公司混淆 | 0 | e11 未混淆 |
| 字段歧义 | 0 | — |
| 多号码分流 | 0 | e06/e12 全部分流正确 |
| 中英混排 | 0 | e03 全字段正确 |
| 字段缺失（应缺未虚构） | 0 | e04/e05 未虚构 |
| 解析规则缺口 | 1 | e10 地址续行未合并 |

## 6. 局限与改进项

1. **样本 < 30**：只报绝对值，不能据此宣称正式准确率；教师数据集（30–50 例真实照片）到位后必须按同一套口径重跑并替换本报告。
2. **合成图偏差**：字体、对比度、背景均优于真实拍摄，本基线的精确率不能外推到真实照片。
3. **改进项**：
   - OCR 分词导致单 token 姓名（`TomLi`）无法进入 name → 可考虑在解析前按大写字母边界拆分，或对 `unresolvedLines` 做二次匹配。
   - 邮件中的空格插入 → 邮箱正则可容忍单词内单个空格后再归一化。
   - 地址续行合并（e10）→ 需要新的 change 修改 `FieldParser`，不在本轮范围。
4. 不设准确率阈值：概率性指标设门槛会诱导调参（`AGENTS.md` 第 7 节）。

## 7. 复现

```bash
bash scripts/verify.sh --scope all --change 0014-ocr-eval-baseline
grep -A 100 "EVAL_SUMMARY" artifacts/verify-0014-ocr-eval-baseline-<timestamp>.log
```

逐例明细由测试直接写入 `docs/eval/raw/<id>.json`（含 `rawLines`、`parsed`、`groundTruth`）。
