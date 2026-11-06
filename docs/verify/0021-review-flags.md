# 验证报告：0021-review-flags

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0021-review-flags` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 15:05–15:09 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0（`BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0021-review-flags` |
| 日志 | `artifacts/verify-0021-review-flags-20261106-150532.log` |
| 结果包 | `artifacts/verify-0021-review-flags-20261106-150532.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 待核对值记录 | 低置信度电话被标记 | `UnverifiedValueDetectorTests.testLowConfidenceObservationIsMarked`、`testThresholdBoundary`、`ReviewViewModelTests.testLowConfidencePhoneIsSavedAsUnverified` | PASS | 阈值 0.7，0.69 命中 / 0.71 不命中 |
| 待核对值记录 | 歧义解析被标记 | `UnverifiedValueDetectorTests.testAmbiguousDiagnosticIsMarked`、`testDiagnosticForOtherFieldDoesNotMark` | PASS | 诊断字段与值必须同类 |
| 待核对值记录 | 修正后不再标记 | `ReviewViewModelTests.testCorrectedValueClearsUnverifiedFlag`、`DetailViewModelTests.testSavingCorrectedValueClearsReviewFlag`、`PersistenceTests.testT18DataSurvivesContainerReopen` | PASS | 保存时与当前字段值取交集 |
| 待核对标记 | T29 低置信度字段展示待核对 | `BizScanUITests/DetailUITests.testT29ReviewBadgeIsShown`、`DetailViewModelTests.testContactEntriesCarryReviewFlag` | PASS | 种子数据带待核对号码 |
| 待核对标记 | T30 编辑修正后标记消失 | `DetailViewModelTests.testSavingCorrectedValueClearsReviewFlag`、`ReviewViewModelTests.testCorrectedValueClearsUnverifiedFlag` | 部分通过 | 无 UI 自动化：手机号为多行 `TextField`，在 Form 中无法稳定取得键盘焦点（已登记） |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | PASS，BizScanCore 69 + BizScanTests 81 |
| 全量 UI 测试 | `make ui` | PASS，26 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T13/T14/T23/T26/T27/T28/T34/T35 全绿 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | T30 只有 L2 证据，缺 UI 自动化 | 一般 | 已登记 `docs/verification-debt.md`；根因是多行输入框焦点问题 |
| D2 | 地址 OCR 置信度普遍偏低，可能较频繁命中「待核对」 | 一般 | 阈值固定 0.7；后续用 `docs/eval` 基线校准 |
| D3 | 0016 之前保存的旧名片无待核对记录 | 一般 | 属预期：当时未保留识别依据，不回填 |

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS 或已登记 L2 替代证据，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：本 change 不改识别策略，只消费既有 `OCRObservation.confidence` 与 `ParsingDiagnostic`，符合「OCR 与字段解析分离」约束。
