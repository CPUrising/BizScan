# 验证报告：<change-id>

> 复制本模板为 `docs/verify/<change-id>.md`。规则见 `openspec/AGENTS.md` 第 5 节。
> 本文件必须由**执行验证的机器**产出；Windows 编辑端不得预填结论。

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `<change-id>` |
| 执行人 | |
| 执行时间 | |
| 机器 | macOS / GitHub Actions（runner 名称） |
| Xcode | `xcodebuild -version` |
| 模拟器 | 例：iPhone 15 / iOS 17.5 |
| 真机（如有） | 型号 + iOS 版本 |
| 命令 | `scripts/verify.sh --change <change-id>` |
| 日志 | `artifacts/verify-<change-id>-<timestamp>.log` |
| 结果包 | `artifacts/verify-<change-id>-<timestamp>.xcresult` |

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| | Txx | `BizScanTests.XxxTests.testYyy` | PASS / FAIL / NOT RUN | |

规则：

- 每个 `## ADDED / MODIFIED` 的 Scenario 必须出现一行。
- FAIL 必须给出失败断言与日志片段（不超过 20 行）。
- NOT RUN 必须说明原因，并标记是否阻断归档。

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试 | `make unit` | |
| 全量 UI 测试 | `make ui` | |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | | | |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：
