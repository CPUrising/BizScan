# 验证报告：0019-home-redesign

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0019-home-redesign` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 14:33–14:37 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0（`BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0019-home-redesign` |
| 日志 | `artifacts/verify-0019-home-redesign-20261106-143320.log` |
| 结果包 | `artifacts/verify-0019-home-redesign-20261106-143320.xcresult` |

> 说明：截图与测试统一在 iOS 18.0 的 iPhone 16 上执行。此前一次手动截图误用了同名的 iOS 18.1 设备（`2C7C21FD`），已复核两版本渲染一致，并改用 UDID 指定设备。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 首次启动进入空名片夹（MODIFIED） | T01 First Launch | `BizScanUITests/LaunchUITests.testAppLaunchesToEmptyCardHolder` | PASS | 断言 `BizScan.Home.EmptyState`，空状态不再有按钮 |
| 名片列表展示（MODIFIED） | 列表缩略信息可读 | `BizScanUITests/CardListUITests.testSeededCardsAppearInList` | PASS | 98×64 缩略图 + 姓名 + 职位/公司 |
| 名片列表展示（MODIFIED） | 点击进入详情 | `BizScanUITests/CardListUITests.testT13OpenDetailShowsSavedFields`、`DetailUITests.testT14EditNamePersistsInDetail` | PASS | 详情页显式恢复系统导航栏 |
| 按创建日期分组展示 | T24 主页按日期分组展示 | `BizScanUITests/CardListUITests.testT24HomeGroupsByCreatedDate`、`HomeViewModelTests.testSectionsGroupByCreatedDay`、`testEditingDoesNotMoveCardToAnotherDay` | PASS | 断言 `2026-10-27` 分组在 `2026-10-26` 上方 |
| 主页深色外观 | T25 主页深色外观与常驻入口 | `BizScanUITests/CardListUITests.testT25HomeKeepsPersistentEntries` | PASS | 标题、搜索、分组管理、相机、`+` 均常驻；深色由 `RootView` 强制，未做像素级颜色断言 |
| 更新时间与展示排序（ADDED） | 编辑后更新时间变化但排序不变 | `HomeViewModelTests.testEditingDoesNotMoveCardToAnotherDay` | PASS | `updatedAt` 更新但分组不变 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | PASS，BizScanCore 62 项 + BizScanTests 73 项 |
| 全量 UI 测试 | `make ui` | PASS，21 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T02/T06/T13/T14/T15/T16/T17/T18/T21/T22/T23/T34/T35 全部通过 |

受影响的测试改动（均为选择器/入口变化，非放宽断言）：

- 7 个 UI 测试文件的启动等待由 `navigationBars["名片夹"]` 改为 `buttons["BizScan.Home.Add"]`（标题改为「名片」且自绘头部）
- T17 由左滑删除改为行 `…` 菜单删除（列表由 `List` 改为 `ScrollView`，无系统左滑）
- T21 由左滑「分组」改为行菜单「移动到分组」
- `HomeViewModelTests` 排序断言由 `updatedAt` 改为 `createdAt` 并新增分组断言

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 深色外观只做了功能性验证，未做像素级颜色断言 | 一般 | XCUITest 无法取色；以真机截图为证据，颜色值集中在 `Theme` |
| D2 | 种子数据无真实名片图，缩略图展示占位图 | 一般 | 本地素材被 `.gitignore` 排除；真机/本地导入后可看到实际缩略图 |
| D3 | 编辑后不再前移（`createdAt` 排序） | 一般 | 属设计变更，已写入 `card-model` 的 MODIFIED 需求 |
| D4 | 分组行为下拉菜单，稿子未标注交互 | 一般 | 保留当前交互；若需要设计稿的静态文本需再确认 |

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：与 Figma「名片主页」的对照见 `docs/verify/0019-home-redesign.md` 第 6 节截图说明；详情页视觉由 `0020-detail-redesign` 承接。

## 6. 视觉对照（iOS 18.0 实拍）

| 设计要素 | 稿子 | 实现 | 结论 |
|---|---|---|---|
| 页面背景 | `#191919` | `Theme.page` | 一致 |
| 标题 | 26/700 左对齐 | `.system(size: 26, weight: .bold)` | 一致 |
| 「+」按钮 | 40×40、r13、`#2B2B2B` | 同 | 一致 |
| 搜索框 | 350×46、`#252525`、r12、占位 14 `#A0A0A0` | 同（左右 20 内边距） | 一致 |
| 分组行 | 高 62、14/500 + 数量 13 `#777777` + 「分组管理」13 | 同 | 一致 |
| 列表分隔 | 1px `#2B2B2B`，左右 20 | 同，仅行间绘制 | 一致 |
| 日期标题 | 12/500 `#777777`，高 46 | 同 | 一致 |
| 行 | 高 108、缩略图 98×64 r7、姓名 19/500、副标题 14 `#A0A0A0`、`…` | 同 | 一致 |
| 空状态 | 线稿 64×48 `#626262` + 14 `#A0A0A0` | SF Symbol `person.text.rectangle` | 近似（图标细节不同，尺寸与颜色一致） |
| 相机按钮 | 68×68 圆 `#3478F6`、底部居中、距手势条 22 | 同 | 一致 |

已知偏差：空状态为系统线稿图标而非设计稿的定制图标，如需 1:1 需从 Figma 导出矢量图 `7:348` 的 `空名片图示` 节点。
