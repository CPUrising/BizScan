# 验证报告：0017-card-grouping

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0017-card-grouping` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 13:42–13:46 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0 |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0017-card-grouping` |
| 日志 | `artifacts/verify-0017-card-grouping-20261106-134241.log` |
| 结果包 | `artifacts/verify-0017-card-grouping-20261106-134241.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 按分组筛选名片 | T21 创建分组并按分组筛选 | `BizScanUITests.CardListUITests.testT21CreateGroupAndFilter`；`BizScanTests.HomeViewModelTests.testGroupFilterShowsOnlyGroupCards`；`testMoveCardToGroup` | PASS | UI 覆盖新建分组、切换分组、左滑移入分组 |
| 按分组筛选名片 | T22 删除分组后名片回到未分组 | `BizScanUITests.CardListUITests.testT22DeleteGroupMovesCardToUngrouped`；`BizScanTests.RepositoryTests.testDeleteGroupClearsCardGroup` | PASS | 名片与图像均未删除 |
| 按分组筛选名片 | 分组名去重 | `BizScanTests.RepositoryTests.testCreateGroupIsCaseInsensitive`；`BizScanTests.GroupViewModelTests.testCreateGroupReusesExistingName` | PASS | 大小写/首尾空格归一 |
| 详情展示分组 | T23 详情展示分组 | `BizScanUITests.DetailUITests.testT23DetailShowsGroup`；`BizScanTests.RepositoryTests.testSaveCardKeepsGroup` | PASS | 未分组回退由 T22 UI 用例覆盖 |
| 标签编辑与保留 | T16 添加标签并保留在编辑页 | `BizScanUITests.SearchTagsUITests.testT16TagIsEditableAndHiddenOnHome` | PASS | 主页/详情均不展示标签 |
| 标签编辑与保留 | 删除标签 | `BizScanTests.RepositoryTests.testDeleteTagRemovesItFromCards` | PASS | 仅 L2，编辑页删除按钮无 UI 用例 |
| 标签编辑与保留 | 重复标签 | `BizScanTests.RepositoryTests.testTagCreationIsCaseInsensitive` | PASS | — |
| 标签管理（REMOVED） | — | `BizScanUITests.SearchTagsUITests.testT16TagIsEditableAndHiddenOnHome`（断言主页无标签） | PASS | 原「按标签筛选」场景已移除 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit`（`scripts/verify.sh --scope unit`） | PASS，BizScanCore + BizScanTests 共 67 项 |
| 全量 UI 测试 | `make ui`（`scripts/verify.sh --scope ui`） | PASS，17 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T13/T14/T15/T17/T18 等既有用例全部通过 |

补充：首次 UI 全量运行有 2 项失败（T16 表单标签未滚动到可视区、T21 系统 Alert 未用 `app.alerts` 查询），修正的是**测试选择器**，不是实现断言；修正后全量通过。

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 主页/详情视觉仍为旧样式，分组行只是功能性中间态 | 一般 | 由 `0019-home-redesign`、`0020-detail-redesign` 完成 1:1 |
| D2 | 分组管理页无设计稿，当前使用系统 `List` 自绘 | 一般 | 待 0019 主题令牌落地后统一样式 |
| D3 | 标签删除只有仓储层测试，编辑页删除按钮无 UI 用例 | 一般 | 已登记 `docs/verification-debt.md` 待补 |
| D4 | 老数据不会把 `tags` 自动映射为 `group` | 一般 | 升级后统一为「未分组」，已在 design.md 记录 |

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：本 change 只交付分组数据与筛选行为，视觉还原属于后续 change；真机未执行，不影响本 change 的确定性场景判定。
