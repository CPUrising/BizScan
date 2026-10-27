# 验证报告：0006-verification-save

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0006-verification-save` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告；其 L2 证据由 `0011` 专门补齐（`ReviewViewModelTests`、`PersistenceTests`），结论取自同一批 `--scope all` 执行。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `verification` | T11 人工修改 → 保存修改结果 | `BizScanTests/ReviewViewModelTests.testT11ManualCorrectionPersistsEditedFields`、`testInitPrefillsParsedFieldsFromScanResult` | PASS（L2） | 11 字段预填与逐字段校正后落库 |
| `verification` | T11 校正页 UI 交互 | — | NOT RUN | Review 入口依赖相机/相册，UI 自动化不可达；不阻断归档 |
| `card-list` | T12 保存 → 名片夹出现新名片 | `ReviewViewModelTests.testT12FirstSavePersistsImagePathsAndRecord`、`HomeViewModelTests.testReloadSortsByUpdatedAtDescending` | PASS（L2） | 首次保存写入原图/处理图相对路径，列表可倒序取回 |
| `card-list` | T12 保存后返回列表的 UI 跳转 | — | NOT RUN | 同上；`CardListUITests.testNewCardAppears` 未写 |
| `verification` | 连点保存只产生一条记录 | `ReviewViewModelTests.testSavingExistingCardKeepsIDAndDoesNotDuplicate` | PASS（L2） | 既有名片 id 不变、计数不增 |
| `verification` | T20 空名片保存 → 二次确认 | `ReviewViewModelTests.testEmptyCardRequiresConfirmation` | PASS（L2） | `save()` 只置警告，`save(force:)` 才落库 |
| `persistence` | T18 Kill App → 重启数据保持 | `PersistenceTests.testT18DataSurvivesContainerReopen`、`testT18TagsSurviveReopen` | PASS（L2） | 同 sqlite URL 释放并重建容器后字段/标签/备注/图像路径全保留 |
| `persistence` | T18 真机杀进程后重启 | — | NOT RUN | 需真机 `terminate()`；容器重建为等价替代，不阻断归档 |
| `persistence` | 删除名片同步清理图像文件 | `PersistenceTests.testDeleteCardRemovesImageFiles` | PASS（L2） |  |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次，L2 证据由 `0011` 补齐 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | `ReviewViewModel.isEmptyCard` 未统计 `faxes`，仅含传真号的名片会被判为空卡 | 一般 | 未修复：属产品行为，超出「只补测试」范围；已登记 `docs/verification-debt.md` |
| D3 | T18 以容器重建模拟重启，未覆盖「进程被系统杀死时 sqlite 未正常关闭」 | 一般 | 已声明风险；真机验证列入验证债 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. T11/T12/T18/T20（空名片）首次获得自动化证据，但均为 L2（ViewModel + 容器层），校正页与详情页的 UI 链路未执行。
2. 待决策项：接受 L2 作为 T11/T12/T18 的归档依据（选项 A）／补 UI 测试或真机测试（选项 B）／先修 D2 的空卡判定（选项 C）。
