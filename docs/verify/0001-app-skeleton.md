# 验证报告：0001-app-skeleton

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0001-app-skeleton` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告。下列结论取自 `0011` 的同一批 `--scope all` 执行；该基线包含 `0009` 的 UI 修复，因此证明的是**当前基线上的骨架行为**，不是本 change 归档瞬间的快照。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `card-list` | T01 首次启动 → 空名片夹 | `BizScanUITests/LaunchUITests.testAppLaunchesToEmptyCardHolder` | PASS（UI） | `-ui-testing` 使用内存容器，空态可见 |
| `card-model` / `persistence` | 名片与标签可保存、按 `updatedAt` 倒序取回、删除即消失 | `BizScanTests/RepositoryTests`（6 项） | PASS（L2） | 含标签大小写去重与空标签拒绝 |
| `card-list` | 首页列表排序 / 删除 / 标签筛选 | `BizScanTests/HomeViewModelTests`（3 项） | PASS（L2） |  |
| `card-detail` | 详情页字段渲染 | `BizScanTests/DetailViewModelTests.testLoadPopulatesDisplayRows` | PASS（L2） |  |
| `persistence` | 图像落盘与删除清理 | `BizScanTests/PersistenceTests.testFileImageStoreRoundTrip`、`testDeleteCardRemovesImageFiles` | PASS（L2） | 真实 `FileImageStore` 写入 Application Support |
| `card-model` | 旧 schema 迁移 | — | NOT RUN | 首版 schema，无迁移路径；不阻断归档 |
| `persistence` | 真机冷启动 | — | NOT RUN | 由 `0011` 的「容器重建」等价覆盖，真机未执行；不阻断归档 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退，与 `0009` / `0010` 基线一致 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次，结论引用 `0011` 同批次证据 | 一般 | 已接受：见 `0012/design.md` 决策 1；如需独立批次可重跑 `bash scripts/verify.sh --change 0001-app-skeleton` |
| D2 | schema 迁移路径无测试 | 一般 | 已登记 `docs/verification-debt.md`；首版无迁移需求，不阻断 |
| D3 | 证据基线已含 `0009` 的 UI 修复 | 一般 | 报告中已声明，结论只对当前基线成立 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. 本 change 交付物（工程骨架、数据模型、仓库、首页/详情/搜索）在当前基线上均有自动化证据，`skip_specs` 场景外的 NOT RUN 项均不阻断。
2. 证据来自 `0011` 同批次，非本 change 独立执行；是否接受「以同批次回填」作为归档依据，需人类确认（选项：接受 / 要求独立重跑）。
