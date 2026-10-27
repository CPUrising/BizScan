# 验证报告：0010-toolchain-compile-fixes

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0010-toolchain-compile-fixes` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 15:39:46 – 15:40:16（Asia/Shanghai） |
| 机器 | macOS 26.3.1（25D2128） |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope unit --change 0010-toolchain-compile-fixes` |
| 日志 | `artifacts/verify-0010-toolchain-compile-fixes-20261027-153946.log` |
| 结果包 | `artifacts/verify-0010-toolchain-compile-fixes-20261027-153946.xcresult` |

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 中声明 `skip_specs: true`：不新增、不修改任何 `ADDED / MODIFIED` 的 Scenario，仅修复既有规范的实现代码与验证工具链。因此本节按「编译修复项」逐条登记实际执行结果。

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| 0010 / T-1.1 `FieldParser` 中文关键词判定 | 编译通过且行为不变 | `BizScanCore.FieldParserTests`（13 项） | PASS | 由 `containsCJK(keyword)` 修复；13 项全绿 |
| 0010 / T-1.2 `FieldParser` 中文关键词判定 | 不虚构、歧义保留 | `BizScanCore.NoFabricationTests`（7 项） | PASS | 阻断级要求，7 项全绿 |
| 0010 / T-2.1 `PhotoLibraryService` 可编译 | App target 构建 | `xcodebuild test -only-testing:BizScanTests` | PASS | 编译 0 error |
| 0010 / T-2.2 `ScannerViewModel` 可编译 | App target 构建 | 同上 | PASS | 编译 0 error |
| 0010 / T-2.3 `BizScanApp` 演示数据可编译 | App target 构建 | 同上 | PASS | 参数顺序修正后通过 |
| 0010 / T-2.4–2.5 `DetailViewModel` 可编译 | App target 构建 | 同上 | PASS | 两处闭包 `$0` 修正后通过 |
| 0010 / T-3.1–3.3 `xcodegen generate` 单层工程 | 生成 `BizScan.xcodeproj` | `xcodegen generate` | PASS | 日志：`Created project at /Users/admin/Desktop/BizScan/BizScan.xcodeproj`，无嵌套目录 |
| 0010 / T-3.4 默认 destination | 解析到 iPhone 16 / iOS 18.0 | `xcodebuild` destination 解析 | PASS | 日志：`id:BFD06162-..., OS:18.0, name:iPhone 16` |

执行到的测试套件明细：

| 层 | 测试套件 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore | `BusinessCardTests` | 5 | PASS |
| BizScanCore | `ContactNormalizerTests` | 7 | PASS |
| BizScanCore | `FieldParserTests` | 13 | PASS |
| BizScanCore | `NoFabricationTests` | 7 | PASS |
| BizScanCore | `PhoneClassifierTests` | 8 | PASS |
| BizScanCore | `SearchQueryTests` | 8 | PASS |
| BizScanCore | `TagStoreTests` | 7 | PASS |
| BizScanCore | `VCardBuilderTests` | 7 | PASS |
| BizScanCore | **小计** | **62** | **PASS，0 失败** |
| iOS 单元 | `RepositoryTests` | 6 | PASS |
| iOS 单元 | `SmokeTests` | 1 | PASS |
| iOS 单元 | **小计** | **7** | **PASS，0 失败** |

未执行项：

| 项 | 原因 | 是否阻断归档 |
|---|---|---|
| `BizScanUITests`（UI 测试） | 本 change 未改动任何 View / 交互逻辑，`--scope unit` 即本 change 的验证范围；UI 测试归属后续 change | 否 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 + L2 单元） | `bash scripts/verify.sh --scope unit --change 0010-toolchain-compile-fixes` | PASS：core 62 + iOS 7，共 69 个用例，0 失败，`** TEST SUCCEEDED **` |
| 全量 UI 测试 | `make ui` | NOT RUN（见第 2 节未执行项） |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退基线（本 change 是项目首次真实编译与首次真实测试，此前无已通过的运行记录） |

编译侧：`xcodebuild test` 全流程 0 error；仅 `appintentsmetadataprocessor` 的 `Metadata extraction skipped. No AppIntents.framework dependency found.` 提示（无 AppIntents 依赖，属正常）。

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 提案阶段 `openspec validate 0010-toolchain-compile-fixes --strict` 未执行 | 一般 | **已关闭**：补装 OpenSpec CLI 1.14.3 后补跑，输出 `Change '0010-toolchain-compile-fixes' is valid`（含 `skip_specs` INFO 提示） |
| D2 | `xcodebuild` 提示 `Using the first of multiple matching destinations`（同一 UDID 同时存在 arm64 与 x86_64 两条记录） | 一般 | 实际选中 `arch:arm64, OS:18.0`，与本机架构一致，测试结果有效；后续可在 `verify.sh` 中用 `id=` 精确指定消除告警 |
| D3 | `--scope core` 未单独执行 | 一般 | core 的 62 个用例已作为 `--scope unit` 的前置阶段在同一次运行中执行并通过（日志第 8–159 行），证据等价，不再重复跑 |

风险：本 change 只证明「代码可编译、既有单元测试可运行且全绿」，不证明 UI 交互与真机相机链路可用；后者仍留在 `docs/verification-debt.md`。

## 5. 结论

- [x] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [ ] 需人类决策（列出选项）

补充说明：

1. 这是本项目**首次真实编译 + 首次真实测试**，此前 `docs/verify/` 只有模板、`openspec/changes/archive/` 为空，`docs/verification-debt.md` 全表「未执行」。本次运行关闭了台账 2.1 全部行与 2.2 中 `RepositoryTests` / `project.yml` 两行。
2. `openspec archive` 属 Merge 阶段，按 `openspec/AGENTS.md` §2 需人类批准。`openspec validate --strict` 已通过（OpenSpec CLI 1.14.3），归档前置条件已满足。
3. 本报告依据 `artifacts/verify-0010-toolchain-compile-fixes-20261027-153946.log` 与同名 `.xcresult` 的实际输出填写，未预填任何结论。
