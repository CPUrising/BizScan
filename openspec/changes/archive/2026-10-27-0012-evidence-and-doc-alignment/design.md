# Design

## Context

`docs/verify/TEMPLATE.md` 明确要求报告「必须由执行验证的机器产出」，因此不能为 0001–0008 编造独立批次。现实约束是：

- 0009 之前的八个 change 已按 macOS 执行过一次 `verify.sh`，但当时没有留下报告。
- 0011 刚产出唯一一批完整证据（core 62 + iOS 单测 29 + UI 11），代码基线覆盖了 0001–0008 的全部实现。
- 模板禁止编辑机预填结论，所以 8 份报告必须**逐行标注证据来源**，而不是伪装成各自独立执行。

## Goals / Non-Goals

**Goals:**

- `docs/verify/` 下 0001–0008 各有一份可在五节结构内追溯的报告。
- 每份报告的每个 PASS 都能指到具体测试名（L1 / L2 / UI）。
- 三份文档（AGENTS.md、verification-debt.md、traceability.md）与 README 的环境口径一致。

**Non-Goals:**

- 不重跑 8 个 change 的独立验证批次。
- 不补写任何测试；T03–T07、T20 等仍无自动化证据的项如实记 NOT RUN。
- 不改 `openspec/specs/`、不改 Gate 定义。

## Decisions

1. **8 份报告共用 0011 的同一批证据**
   - 每份报告第 2 节首行声明：「本 change 未单独执行独立批次，结果取自 `<0011 log>`，代码基线相同」。
   - 理由：避免伪造独立执行（AGENTS.md 第 5 节），同时让 Txx 有可点击证据。

2. **PASS 只按测试实际覆盖的层级标注**
   - L1（`BizScanCore` SwiftPM）→ 标 `PASS（L1）`；L2（`BizScanTests`）→ `PASS（L2）`；UI → `PASS（UI）`。
   - 某 Txx 只有 L1/L2 时，UI 行单独记 `NOT RUN`，不得合并写成「通过」。

3. **8 份报告一律不勾 Ready for archive**
   - 第 5 节勾「需人类决策」，并在补充说明里写「证据来自 0011 同批次，非本 change 独立执行」。
   - 理由：报告是补证据，不等于重新验收。

4. **T11/T12/T18/T19 状态文案固定为「部分通过」**
   - `docs/traceability.md` 只允许出现 `部分通过（L2，0011）` / `部分通过（L1+L2，0011）`，禁止写 `通过`。

5. **环境口径以实际执行机为准**
   - 统一写「macOS 26.3.1 + Xcode 26.1.1 + iPhone 16 (iOS 18.0)」，并把历史「Windows 本机」表述改为「编辑机（Windows 或 macOS）」。

## Risks / Trade-offs

- [8 份报告被误读为「各自重新验收」] → 每份首行 + 第 5 节双重声明批次来源；README 同步注明。
- [共用批次导致某 change 的证据粒度变粗] → 每份报告列出该 change 相关测试类与用例数，粒度为测试名而非仅「全绿」。
- [文档改动与测试改动混在同一提交] → 按 AGENTS.md 第 6 节拆为独立 change（0011 管测试，0012 管文档）。

## Migration Plan

纯文档变更，无迁移。执行顺序：先回填 `docs/verify/0011-l2-test-coverage.md`（依赖 0011 的日志），再写 0001–0008，最后改三份文档与 README，避免引用不存在的文件名。

## Open Questions

无。
