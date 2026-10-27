# 验证报告：0002-capture-import

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0002-capture-import` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无（模拟器无相机） |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告。下列结论取自 `0011` 的同一批 `--scope all` 执行，基线包含 `0009` 对 `ScannerView` 的关闭入口修复。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `capture` | T02 名片夹 → 扫描 → 相机页 | `BizScanUITests/CaptureUITests.testT02OpenScannerAndReturn` | PASS（UI） | 模拟器走 `.denied` 分支，经关闭入口返回 |
| `capture` | T03 权限允许 / 拒绝 | — | NOT RUN | 需真机或系统权限弹窗，模拟器无法稳定复现；阻断真机验收，不阻断本 change 归档 |
| `capture` | T04 拍摄 → 进入识别 | — | NOT RUN | 模拟器无相机；`CaptureUITests.testCaptureAndConfirm` 未写 |
| `capture` | T05 相册导入 → 进入识别 | — | NOT RUN | `CaptureUITests.testImportFromLibrary` 未写 |
| `capture` | T20 中途退出不产生草稿 | `BizScanUITests/CaptureUITests.testT20ExitWithoutDraft` | PASS（UI） | 退出后既有名片不受影响 |
| `capture` | 权限拒绝时保留相册降级路径 | — | NOT RUN | 无单测；`ScannerViewModel` 状态机未覆盖 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退，`CaptureUITests` 2/2 通过 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次，结论引用 `0011` 同批次证据 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | T03–T05 无自动化证据 | 严重 | 未关闭：需真机与新增测试，已登记 `docs/verification-debt.md`；阻断「相机链路」整体验收 |
| D3 | 模拟器同时展示「需要相机权限」页与「没有可用的相机」提示 | 一般 | 未修复：属行为变更，见 `0009` 报告 D2 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. 本 change 在模拟器上只证明了「打开扫描页 → 无相机 → 可退出」，T03/T04/T05 的真实拍摄与相册导入链路仍无证据。
2. 待决策项：接受当前证据并保留验证债（选项 A）／补真机测试后再归档（选项 B）。
