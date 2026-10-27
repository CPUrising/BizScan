# 验证报告：0003-boundary-perspective

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0003-boundary-perspective` |
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
| `card-detection` | T06 倾斜名片 → 检测并显示区域 | — | NOT RUN | `CardDetectorTests` 与 `DetectionUITests.testShowDetectedQuad` 均未写 |
| `card-detection` | T20 校正页重拍 | — | NOT RUN | `DetectionUITests.testRetakeFromAdjust` 未写 |
| `card-detection` | 检测失败 / 置信度不足 → 整图四边形 + 强制人工确认 | — | NOT RUN | 无自动化；该回退分支从未被执行过 |
| `card-detection` | 透视校正后 90° 方向校正 | — | NOT RUN | 需真实图像输入，当前无 fixture |

说明：`ScanResult.quad` 字段虽在既有测试中被构造（`TestSupport.makeScanResult` 传 `quad: nil`），但这只是编译期形状验证，不能作为 T06 的证据。

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败（不含检测相关用例） |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；本 change 相关能力从未有通过项 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | 本 change 的**全部**场景无自动化证据，检测与校正从未被执行验证过 | 阻断 | 未关闭：需新增 `CardDetectorTests`（至少 1 张倾斜图 fixture）与 `DetectionUITests`，已登记 `docs/verification-debt.md` |
| D3 | 无 fixture 图像资产 | 严重 | 未关闭：验证债明确排除「新增 fixtures」，需单独立项 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. 本报告是**零证据**报告：`0003` 的实现（`VisionCardDetector`、`CoreImageCorrector`、`CropViewModel`）虽然已合入且能编译运行，但没有任何用例执行过其行为分支。
2. 待决策项：以「验证债」形式带债归档（选项 A）／先补检测测试再归档（选项 B）／把 T06 从 100% 判定范围下调为概率性评价项（选项 C，需改规范）。
