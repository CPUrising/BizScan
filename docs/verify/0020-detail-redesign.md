# 验证报告：0020-detail-redesign

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0020-detail-redesign` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 14:57–15:01 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0（`BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0020-detail-redesign` |
| 日志 | `artifacts/verify-0020-detail-redesign-20261106-145704.log` |
| 结果包 | `artifacts/verify-0020-detail-redesign-20261106-145704.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 详情页展示（MODIFIED） | T13 Detail | `BizScanTests/DetailViewModelTests.testLoadPopulatesContactEntries`、`BizScanUITests/CardListUITests.testT13OpenDetailShowsSavedFields`、`DetailUITests.testT13EmptyFieldsAreNotShown` | PASS | 姓名/职务/公司 + 联系方式条目；空字段不出现 |
| 详情页展示（MODIFIED） | 长文本与标签展示 | `DetailUITests.testT23DetailShowsGroup`、`Repo` 地址断言（L2） | PASS | 地址换行完整；标签不在详情展示；分组可见 |
| 外部动作（MODIFIED） | 点击电话号码 | `DetailViewModelTests.testQuickActionURLsFollowFieldPresence` | PASS | `tel://+8613800000000`；真机拨号未执行 |
| 外部动作（MODIFIED） | 点击邮箱与网址 | `DetailViewModelTests.testLoadPopulatesContactEntries`、`testQuickActionURLsFollowFieldPresence` | PASS | mailto/https 生成；空值返回 nil |
| 收藏名片 | T27 收藏状态持久化 | `BizScanUITests/DetailUITests.testT27FavoritePersists`、`DetailViewModelTests.testToggleFavoritePersists`、`PersistenceTests.testT27FavoriteSurvivesReopen` | PASS | UI 走「退出详情再进入」；落盘重启由 L2 覆盖 |
| 查看原图 | T28 查看原图 | `BizScanUITests/DetailUITests.testT28ViewOriginalImage`、`testT26AddressActionDisabledWithoutAddress`（无图隐藏） | PASS | 种子数据生成测试名片图 |
| 详情快捷操作 | T26 详情核心资料与快捷操作 | `BizScanUITests/DetailUITests.testT26ProfileAndQuickActions`、`testT26AddressActionDisabledWithoutAddress`、`DetailViewModelTests.testAvatarInitialFallsBackToCompany` | PASS | 缺地址/电话时按钮 Disabled |
| 收藏标记 | 收藏标记持久化 | `PersistenceTests.testT27FavoriteSurvivesReopen` | PASS | 旧记录默认 `false`（字段带默认值，轻量迁移） |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | PASS，BizScanCore 62 + BizScanTests 77 |
| 全量 UI 测试 | `make ui` | PASS，25 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T14/T15/T16/T17/T18/T21–T25/T34/T35 全绿 |

测试选择器调整（非放宽断言）：

- 详情标题断言由 `navigationBars["名片详情"]` 改为 `staticTexts["名片详情"]`（自绘顶栏）
- T14 编辑入口由工具栏「编辑」改为 `BizScan.Detail.Quick.Edit`
- T13 邮箱值断言改用 `BizScan.Detail.Contact.email-0`（值为按钮）

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 「待核对」橙色胶囊与提示未实现 | 一般 | 由 `0021-review-flags` 实现；当前字段行缺这一处设计元素 |
| D2 | 底部「存入通讯录」为禁用态（40% 绿） | 一般 | 稿为实心绿；`0022-save-to-contacts` 接线后启用 |
| D3 | 自绘顶栏后系统右滑返回不可用 | 一般 | 使用自定义返回按钮；已由 T27 用例覆盖返回路径 |
| D4 | 分组行为静态展示，不可点击改分组 | 一般 | 稿未标注交互；分组修改走「分组管理」页 |
| D5 | 真实拨号/邮件/地图跳转未在模拟器验证 | 一般 | 仅验证 URL 生成；已登记到 `docs/verification-debt.md` |

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：迁移期间发现 `isFavorite` 无默认值会导致旧的 `default.store` 轻量迁移失败（启动 `fatalError`），已改为 `var isFavorite: Bool = false` 并在验证中确认可正常启动。

## 6. 视觉对照（iOS 18.0 实拍）

| 设计要素 | 稿子 | 实现 | 结论 |
|---|---|---|---|
| 顶栏 | 92pt，`#176FD1`，返回 26 + 标题 18/600 + 星标/更多 | 同（状态栏区域延伸蓝色） | 一致 |
| 核心卡 | `#202123`，padding 28/24/24/24，gap 19 | 同 | 一致 |
| 头像 | 66 圆 `#42AD73`，32 号首字 | 同 | 一致 |
| 姓名/职务/公司 | 28/600、14 `#B5B8BD`、15 `#B5B8BD` | 同 | 一致 |
| 查看原图 | 42×34 r6 绿描边 + 11 号绿字 | 同 | 一致 |
| 快捷操作 | 48 圆（绿/蓝/琥珀/紫）+ 13 号标签 | 同；缺失数据置灰 | 一致 |
| 分组行 | 高 56，图标 20 `#858A91`，文字 15 | 同（图标为 SF Symbol） | 近似 |
| 备注卡 | padding 18/24/20/24，标题 12 + 内容 14 | 同；无备注时隐藏 | 一致 |
| 联系方式 | 图标 + 12 号字段名 + 胶囊 + 16 号值 + 铅笔 | 同 | 一致（缺「待核对」胶囊，D1） |
| 底部按钮 | 342×47 r12 `#42AD73` | 同尺寸/圆角，禁用态降透明度 | 尺寸一致，颜色为禁用态（D2） |
