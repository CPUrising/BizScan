# Tasks

## 1. 证据基座

- [x] 1.1 确认 `artifacts/verify-0011-l2-test-coverage-<timestamp>.log` 与同名 `.xcresult` 存在且为 `--scope all` 批次
- [x] 1.2 回填 `docs/verify/0011-l2-test-coverage.md`（T11/T12/T18/T19 逐条 + UI 行 NOT RUN）

## 2. 回填 8 份报告

- [x] 2.1 `docs/verify/0001-app-skeleton.md`、`0002-capture-import.md`、`0003-boundary-perspective.md`、`0004-ocr-pipeline.md`
- [x] 2.2 `docs/verify/0005-field-parser.md`、`0006-verification-save.md`、`0007-manage-search-tags.md`、`0008-export.md`
- [x] 2.3 8 份报告均含：批次来源声明、逐条 PASS/NOT RUN、「需人类决策」结论

## 3. 文档口径统一

- [x] 3.1 `openspec/AGENTS.md` 第 7 节：编辑机/验证机表述与「禁止放宽断言」
- [x] 3.2 `docs/verification-debt.md`：背景段与 2.2 表
- [x] 3.3 `docs/traceability.md`：T11/T12/T18/T19 状态
- [x] 3.4 `README.md`：阶段看板与参考环境注记

## 4. 终检

- [x] 4.1 `openspec validate --all --strict`
- [x] 4.2 确认 `docs/verify/` 下 0001–0008 均存在，且没有任何文件把 T11/T12/T18/T19 标成「通过（UI）」

> 不改代码、不改测试、不改 `openspec/specs/`、不归档任何 change。
