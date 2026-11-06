# 验证报告：0018-manual-card-create

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0018-manual-card-create` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 14:02–14:06 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0 |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0018-manual-card-create` |
| 日志 | `artifacts/verify-0018-manual-card-create-20261106-140254.log` |
| 结果包 | `artifacts/verify-0018-manual-card-create-20261106-140254.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 名片记录结构（MODIFIED） | T12 保存后字段完整可读 | `BizScanTests/ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord` | PASS | 扫描来源两条图像路径均非空 |
| 名片记录结构（MODIFIED） | 图像以相对路径持久化 | `BizScanTests/PersistenceTests.testT18DataSurvivesContainerReopen` | PASS | 可选类型迁移后旧记录仍有路径 |
| 名片记录结构（MODIFIED） | T34 手动新建允许无原图 | `BizScanTests/NewCardViewModelTests.testSaveCreatesCardWithoutImage` | PASS | `originalImagePath` / `processedImagePath` 均为 nil |
| 手动新建名片 | T34 手动新建并保存 | `BizScanUITests/CardListUITests.testT34CreateCardManually`、`NewCardViewModelTests.testSaveCreatesCardWithoutImage`、`testNoGroupKeepsNilGroup` | PASS | UI 断言列表出现、详情可打开；手机号由 L2 覆盖 |
| 手动新建名片 | T35 手动新建空卡需确认 | `BizScanUITests/CardListUITests.testT35EmptyManualCardRequiresConfirmation`、`NewCardViewModelTests.testEmptyCardRequiresConfirmation` | PASS | 确认后保存为「未命名名片」 |
| 手动新建名片 | 手动新建取消 | `NewCardViewModelTests.testEmptyCardRequiresConfirmation`（未调用 save 不落库） | PASS | 取消仅关闭表单，无隐式保存 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | PASS，BizScanCore 62 项 + BizScanTests 71 项 |
| 全量 UI 测试 | `make ui` | PASS，19 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T13/T14/T15/T16/T17/T21/T22/T23 全部通过 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | UI 用例只录入姓名，未在 UI 层录入手机号 | 一般 | 多行 `TextField` 在 Form 中点击无法稳定获得焦点；手机号保存由 `NewCardViewModelTests` 覆盖 |
| D2 | 主页视觉仍为旧样式，「+」暂为系统导航栏按钮 | 一般 | 由 `0019-home-redesign` 改为 40×40 圆角按钮 |
| D3 | 手动新建不支持补拍原图 | 一般 | 已列入计划「不在本次范围」 |

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：本 change 只解决「无图名片」的模型与录入能力，视觉还原在 0019/0020。
