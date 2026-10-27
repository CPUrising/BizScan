# 验证报告：0004-ocr-pipeline

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0004-ocr-pipeline` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告。下列结论取自 `0011` 的同一批 `--scope all` 执行。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `ocr` | T07 标准名片 → 产生原始文本 | — | NOT RUN | `OCRServiceTests` 未写；`VisionOCRService` 从未被自动化执行 |
| `ocr` | OCR 输出保留文本块坐标、置信度与行序 | `BizScanCoreTests/FieldParserTests`（13 项，按观察顺序解析） | PASS（L1，仅消费者侧） | 证明 `OCRObservation` 的行序/坐标字段可被解析器正确消费，不证明 OCR 产出正确 |
| `ocr` | OCR 空结果 → 保留原图 + 重拍/手动录入出口 | — | NOT RUN | 无测试 |
| `field-extraction` | T08 OCR → 八字段分类（端到端） | — | NOT RUN | `ScanPipeline` 的 OCR→解析串联无测试；字段解析本身见 `0005` |
| `ocr` | 文本质量（字符准确率 / 行召回） | — | NOT RUN | 属概率性评价项，`docs/eval/ocr-report.md` 未生成 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；本 change 无既有通过项 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | T07 无任何自动化证据，OCR 服务未被真实执行过 | 严重 | 未关闭：需 `OCRServiceTests` + 真实名片图 fixture，已登记 `docs/verification-debt.md` |
| D3 | OCR 质量评估报告（`docs/eval/ocr-report.md`）缺失 | 一般 | 未关闭：属概率性评价项，不进入 100% 判定，但影响「OCR 可用」结论 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. 可验证的部分只有「解析器能消费 `OCRObservation` 序列」，OCR 本体的识别能力、坐标与置信度均无证据。
2. 待决策项：带债归档并保留 `docs/verification-debt.md` 条目（选项 A）／先补 `OCRServiceTests` 与一份 OCR 评估（选项 B）。
