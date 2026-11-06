# 验证报告：0022-save-to-contacts

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0022-save-to-contacts` |
| 执行人 | TRAE（macOS 本机） |
| 执行时间 | 2026-11-06 15:20–15:25 |
| 机器 | macOS 本机 |
| Xcode | Xcode 26.1.1 (17B100) |
| 模拟器 | iPhone 16 / iOS 18.0（`BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 未执行 |
| 命令 | `bash scripts/verify.sh --change 0022-save-to-contacts` |
| 日志 | `artifacts/verify-0022-save-to-contacts-20261106-152035.log` |
| 结果包 | `artifacts/verify-0022-save-to-contacts-20261106-152035.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 存入系统通讯录 | T31 存入通讯录成功 | `BizScanTests/DetailViewModelTests.testSaveToContactsSuccessDisablesButton`、`ContactsMapperTests`（5 项）、`DetailUITests.testT26ProfileAndQuickActions` | 部分通过 | 字段映射与状态流转为 L2；真实写入需真机（模拟器无通讯录） |
| 存入系统通讯录 | T32 权限拒绝时引导设置 | `DetailViewModelTests.testSaveToContactsDeniedNeedsSettings` | 部分通过 | 状态与弹窗逻辑为 L2；权限弹窗交互需真机 |
| 存入系统通讯录 | T33 重复联系人提示已存在 | `DetailViewModelTests.testSaveToContactsAlreadyExistsShowsMessage`、`ContactsMapperTests.testComparableValuesNormalizePhonesAndEmails` | 部分通过 | 去重判定为 L2；真实通讯录比对需真机 |

> 这三个场景在模拟器上无法完成真实通讯录读写与权限弹窗，按 AGENTS.md 要求由真机人工清单
> [`docs/verify/manual-device-checklist.md`](manual-device-checklist.md) 第 8b 节承接，未执行前记为「部分通过」。

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | PASS，BizScanCore 69 + BizScanTests 89 |
| 全量 UI 测试 | `make ui` | PASS，26 项 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T13/T14/T23/T26–T29/T34/T35 全绿 |

构建修正：`AppEnvironment` 的默认参数里直接构造 `@MainActor` 的 `SystemContactsService()` 会被判定为「在非隔离同步上下文调用主 actor 初始化器」，改为 `ContactsSaving? = nil` 后在 init 体内构造。

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | T31–T33 无端到端自动化，仅 L2 + 真机清单 | 一般 | 模拟器通讯录与权限弹窗不可稳定驱动；清单第 8b 节已补齐 |
| D2 | 不写入 `note`（备注） | 一般 | iOS 写入备注需额外 entitlement，超出本 change 范围 |
| D3 | 姓名整串写入 `givenName`，不拆分姓/名 | 一般 | 与现有数据形态一致；如需拆分另开 change |
| D4 | 「已存入」状态不持久化，重进详情会复位 | 一般 | 设计未定义；如需保留需新增字段 |
| D5 | 未写 `CNGroup`（通讯录分组） | 一般 | 计划中已列为不在范围 |

## 5. 结论

- [x] Ready for archive：L2 覆盖全部判定分支，端到端部分由真机清单承接且无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：底部按钮已从 0020 的禁用占位改为实心绿可点击；截图确认「待核对」胶囊与按钮同屏展示。
