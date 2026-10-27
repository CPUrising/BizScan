# 验证报告：0005-field-parser

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0005-field-parser` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无（纯 L1 逻辑包，不需要设备） |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告。下列结论取自 `0011` 的同一批 `--scope all` 执行（`swift test --package-path Packages/BizScanCore`）。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `field-extraction` | T08 标准英文名片 → 八字段分类 | `BizScanCoreTests/FieldParserTests.testT08StandardEnglishCard` | PASS（L1） | 字段级断言，无虚构 |
| `field-extraction` | T09 无 Website → 不得虚构 | `FieldParserTests.testT09MissingWebsiteIsNotFabricated`、`NoFabricationTests`（7 项） | PASS（L1） | 虚构字段为 0 |
| `field-extraction` | T10 多电话 → Mobile/Office/Fax 分流 | `FieldParserTests.testT10MultiplePhonesAreClassified`、`PhoneClassifierTests`（8 项） | PASS（L1） | 标签优先于号码形态 |
| `field-extraction` | 全角/半角、号码/邮箱/网址归一化 | `ContactNormalizerTests`（7 项） | PASS（L1） |  |
| `field-extraction` | 标签行拆分与待定区（`unresolvedLines`） | `FieldParserTests`（13 项合计） | PASS（L1） | 无法归类的内容进入待定区而非丢弃 |
| `card-model` | 解析结果模型字段完整、缺失保持 `nil` | `BusinessCardTests`（5 项） | PASS（L1） |  |
| `field-extraction` | 中英混排名片的真实样本准确率 | — | NOT RUN | 属概率性评价项，`docs/eval/field-report.md` 未生成 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退，与 `0009` 基线一致 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | 准确率评估（字段级精确率/召回率）缺失 | 一般 | 未关闭：属概率性评价项，不阻断归档；`docs/verification-debt.md` 已登记 |
| D3 | 测试样本为构造文本，非真实 OCR 输出 | 一般 | 已声明：L1 只证明规则正确，不证明对真实噪声的鲁棒性 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. 本 change 是 0001–0008 中自动化证据最充分的一个：T08/T09/T10 均为 PASS（L1），62 项 core 用例全部通过。
2. 待决策项：是否以「L1 已充分、准确率评估另立 change」为口径归档（选项 A）／先补真实样本评估（选项 B）。
