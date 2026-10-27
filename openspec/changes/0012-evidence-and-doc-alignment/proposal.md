# Proposal

## Why

0001–0008 八个 change 的 `tasks.md` 已全部勾选，但 `docs/verify/` 下只存在 `0009` 与 `0010` 两份报告。缺口带来两个实际问题：

1. **证据链断开**：`docs/traceability.md` 里的 Txx 无法回指到任何一份报告，README 阶段看板的「已验收」缺乏可点击证据。
2. **口径分叉**：`openspec/AGENTS.md` 第 7 节、`docs/verification-debt.md` 第 3 行仍写「Windows 端（本机）」，而 README 与本次 0011 的实际执行都在 macOS + Xcode 26.1.1 上，三处互相矛盾。

同时 0011 已补齐 T11/T12/T18/T19 的 L2 证据，`docs/traceability.md` 中这四项的状态需要同步更新，否则文档仍停留在「未实现」。

本 change **不写代码、不改测试、不改规范**，只动 `docs/` 与 `openspec/AGENTS.md`。

## What Changes

- 新增 `docs/verify/0001-app-skeleton.md` … `docs/verify/0008-export.md` 共 8 份报告，严格按 `docs/verify/TEMPLATE.md` 五节结构。
- 批次声明：8 份报告与 `docs/verify/0011-l2-test-coverage.md` 共用同一批证据（`artifacts/verify-0011-l2-test-coverage-<timestamp>.log` + 同名 `.xcresult`），在每份报告基本信息表与本 change 的 design.md 中写明 log 文件名。
- 未覆盖项一律 `NOT RUN` + 原因 + 是否阻断归档，不得用「通过」概括。
- 更新 `openspec/AGENTS.md` 第 7 节：把「Windows 端（本机）」改为「编辑机（Windows 或 macOS）」，并补「测试暴露缺陷须修复后重跑，禁止放宽断言」。
- 更新 `docs/verification-debt.md`：背景段改为 macOS + Xcode 26.1.1 的实际情况；2.2 表新增 ViewModel 行，`VCardExporterTests` 与 `RepositoryTests` 备注按 0011 结果更新。
- 更新 `docs/traceability.md`：T11/T12/T18 → `部分通过（L2，0011）`，T19 → `部分通过（L1+L2，0011）`。
- 更新 `README.md` 阶段看板与「参考环境」注记，使进度口径与证据一致。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

无。本 change 只改文档与协作规范，不影响任何运行时行为合同。

## Impact

- 文档：`docs/verify/*.md`（新增 8 份）、`docs/verification-debt.md`、`docs/traceability.md`、`README.md`、`openspec/AGENTS.md`
- 代码与测试：**无改动**
- 证据：只引用 0011 已产出的日志与 `.xcresult`，不新起执行批次
