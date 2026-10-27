# Design

## 1. 为什么不落 `fixtures/`

`fixtures/` 的语义是「教师下发的固定测试集」，`manifest.json` 里 `source` 只有 `teacher | synthetic` 两个取值。把自建集放进去会与正式集混淆，也会让「数据集来源」这一评分点含糊。本轮数据集留在测试代码里，报告显著标注 `synthetic-001`；教师资产到位后按同一套评估口径重跑并替换报告即可。

## 2. 数据构造

- 画布 1400×900（e07 竖版 900×1400），白底黑字 40pt semibold，行距 95。
- Ground Truth 与绘制文本使用同一组常量，避免手抄错位。
- 确定性噪声（固定 LCG 种子）用于 e09，保证多次运行图像一致。
- 不使用任何真实手机号/邮箱：号码统一 `138 0000 0000` 段，域名统一 `example.com`。

## 3. 评估口径

| 字段类型 | 归一化 |
|---|---|
| 文本（name/company/jobTitle/department/address/postalCode） | 全角转半角、trim、折叠连续空白、小写 |
| 电话 | 只保留数字 |
| 邮箱 | trim + 小写 |
| 网址 | 小写、去 `http(s)://`、去尾部 `/`、去前缀 `www.` |

比对按集合：GT 与输出均为多值字段时忽略顺序。

计数定义：

- `correct`：输出 ∩ GT
- `wrong`：输出中不在 GT 的值
- `missing`：GT 中未被输出的值
- `fabricated`：GT 该字段为空但输出非空 → 该字段精确率记 0，并计入总数

## 4. 硬门槛只有两条

1. `fabricated == 0`（README §11：虚构字段视为阻断缺陷）。
2. 至少 12/15 例 OCR 原始文本非空（否则说明数据集本身不可用，属测试错误）。

不设「准确率 ≥ N%」门槛：概率性指标设阈值会诱导调参或放宽断言（AGENTS.md §7）。

## 5. 明细落盘

`docs/eval/raw/<case-id>.json` 保存 `rawLines / parsed / groundTruth / tags`，供审计与后续对比。路径由 `#filePath` 推导仓库根；写入失败时退化为 `XCTAttachment`，测试不因此失败。

## 6. 不做的事

- 不接入教师数据集，不宣称正式准确率。
- 不修改 `FieldParser` 或 OCR 参数来「凑分」。
- 不为达标而删除困难案例（e08/e09/e11 保留）。
