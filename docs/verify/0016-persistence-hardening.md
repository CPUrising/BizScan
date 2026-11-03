# 验证报告：0016-persistence-hardening

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0016-persistence-hardening` |
| 执行人 | GitHub Actions |
| 执行时间 | 2026-11-03 07:53–07:56 UTC |
| 机器 | GitHub Actions / `macos-15`（arm64） |
| Xcode | Xcode 26.3（`/Applications/Xcode_26.3.app`） |
| 模拟器 | iPhone 16 / iOS 26.2 |
| 真机（如有） | 未执行 |
| 命令 | `xcodebuild test -project BizScan.xcodeproj -scheme BizScan -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -derivedDataPath build/DerivedData -resultBundlePath artifacts/verify-ci.xcresult CODE_SIGNING_ALLOWED=NO` |
| 日志 | `artifacts/verify-ci.log`（CI artifact `verify-9b9165b...`） |
| 结果包 | `artifacts/verify-ci.xcresult` |
| CI run | https://github.com/CPUrising/BizScan/actions/runs/41598668323 |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 重启后数据完整 | T18 Kill App 后重启 | `BizScanTests.PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen` | PASS | 同 URL 重建容器；数据/标签保持 |
| 重启后数据完整 | T18 Kill App 后重启 | `BizScanUITests.PersistenceUITests.testT18DataSurvivesRelaunch` | PASS | 真实 on-disk store，`terminate → relaunch`；16.841s |
| 重启后数据完整 | 存储初始化失败 | 代码审查：`BizScanApp.makeContainer()` 的 `fatalError` 路径 | NOT RUN | 未做故障注入；不阻断归档。代码已确认不再静默回退内存 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| BizScanCore 单元测试 | `swift test --package-path Packages/BizScanCore` | 62/62 PASS |
| iOS 单元测试 | `xcodebuild test` | 52 passed，2 skipped，0 failed |
| UI 测试 | `xcodebuild test` | 12 passed，0 failed |
| 既有通过项是否回退 | 对照 `docs/regression-log.md` | 无回退；T02/T13/T14/T15/T16/T17/T20 仍通过 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | “存储初始化失败”场景未做自动化故障注入 | 一般 | 代码审查确认 `fatalError` 路径；后续可引入可注入的容器工厂做单测 |
| D2 | CI 使用 Xcode 26.3 / iOS 26.2，本地基线为 Xcode 26.1.1 / iOS 18.0 | 一般 | 记录环境差异；CI 结论仅覆盖模拟器 |
| D3 | T18 真机 Kill App 仍未执行 | 严重（不阻断本 change） | 保留在 `manual-device-checklist.md` 第 7 节，G7 前完成 |

## 5. 结论

- [x] Ready for archive：所有自动化 Scenario PASS；D1/D2 为一般偏差，D3 为真机待执行但不阻断本次持久化加固归档
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：本 change 只加固持久化与补 T18 自动化；T03–T05、T18 真机、T19 与正式数据集仍属 P7 待办。
