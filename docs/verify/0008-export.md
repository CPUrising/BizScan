# 验证报告：0008-export

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0008-export` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无（ShareSheet 为系统 UI，未自动化） |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告；`VCardExporterTests`（L2）由 `0011` 补齐，结论取自同一批 `--scope all` 执行。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `export` | T19 导出单张名片 → 字段映射正确 | `BizScanCoreTests/VCardBuilderTests.testT19FieldMapping`（7 项，L1）+ `BizScanTests/VCardExporterTests.testExportSingleCardWritesReadableVCard`（L2） | PASS（L1+L2） | 文件以 `BEGIN:VCARD\r\n` 开头，`FN`/`ORG`/`TITLE`/`TEL;TYPE=CELL`/`EMAIL`/`ADR;TYPE=WORK`/`NOTE` 行齐备 |
| `export` | 多值电话按 CELL/WORK/FAX 输出 | `VCardExporterTests.testExportMultipleCardsEmitsTwoVCards`、`VCardBuilderTests` | PASS（L1+L2） |  |
| `export` | 空字段省略（不虚构） | `VCardExporterTests.testExportOmitsMissingWebsite`、`VCardBuilderTests.testT19FieldMapping` | PASS（L1+L2） | 缺 Website 时不出现 `URL:` 行 |
| `export` | 无名片时导出 → 明确错误 | `VCardExporterTests.testExportEmptyArrayThrowsNoCards` | PASS（L2） | 抛 `ExportError.noCards`，不生成空文件 |
| `export` | 导出文件为 `.vcf` 且写入临时目录 | `VCardExporterTests.testExportedFileIsInTemporaryDirectory` | PASS（L2） | `pathExtension == "vcf"`，路径解析后与 `temporaryDirectory` 一致 |
| `export` | 详情页「导出联系人」→ 系统分享面板 | — | NOT RUN | ShareSheet 为系统 UI，无法稳定自动化；不阻断归档 |
| `export` | 75 字节折行与转义 | `VCardBuilderTests`（7 项内） | PASS（L1） |  |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退；T19 由「仅 L1」升级为「L1+L2」 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | 分享面板与「导出后由第三方应用打开」未验证 | 一般 | 已声明：属系统 UI 边界，需真机人工验收，已登记 `docs/verification-debt.md` |
| D3 | 未实现直接写入系统通讯录 | 一般 | 属 proposal 明确排除项，不计偏差 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. T19 的字段映射与文件写出均有自动化证据（L1+L2），仅系统分享面板未自动化。
2. 待决策项：接受现状归档（分享面板列入人工验收清单，选项 A）／补真机分享验收后再归档（选项 B）。
