# Design

## Context

见 `proposal.md`。当前最大风险是"从未编译/运行过"，且没有 macOS 设备。验收必须依赖 GitHub Actions 或外部 macOS 机器，并按 L1 → L2 顺序结算，减少往返次数。

## Goals / Non-Goals

**Goals:**

- 确定性场景 T01–T20 全部有自动化实现与 PASS 证据。
- 概率性功能有可重复的量化报告，而不是主观描述。
- 所有 change 归档后，`openspec/specs/` 与实现一致。

**Non-Goals:**

- 不追求 OCR 与 CamCard 逐字符一致。
- 不在本 change 内实现通讯录直写、批量导出 UI 等增强。
- 不引入 UI 快照框架之外的第三方测试库。

## Decisions

1. **测试分层：L1 逻辑 → L2 集成 → L3 UI**
   - L1（`swift test`）覆盖解析、vCard、搜索、标签、仓库内实现；最快，先跑。
   - L2 覆盖 Vision/AVFoundation 编译与管线注入测试。
   - L3 覆盖 T01–T20 的可点击路径。
   - 备选：全部依赖 UI 测试（被否：反馈慢、定位差）。

2. **每个 Txx 绑定一个测试方法，映射写回 `docs/traceability.md`**
   - 理由：验收报告可逐条核对；避免"跑了测试但不知道覆盖了哪条要求"。
   - 备选：按测试文件汇总（被否：无法证明 20/20）。

3. **评估报告由脚本生成，人工只写结论**
   - 输入：`fixtures/` + `ground_truth/` + 管线输出 JSON。
   - 输出：字段级精确率/召回率、虚构字段计数、错误分类。
   - 备选：人工统计（被否：不可重复、易错）。

4. **失败处理：先判断是测试错误还是实现错误**
   - 测试错误：修正断言并说明依据。
   - 实现错误：最小修复，重跑该 change 与全量回归。
   - 禁止：删除测试、放宽断言、跳过场景。

5. **归档前置条件**
   - `openspec validate --all --strict` 通过。
   - 对应 `docs/verify/<change>.md` 结论为 Ready for archive。
   - 全量回归不低于 `docs/regression-log.md` 最近基线。

## Risks / Trade-offs

- [CI 分钟数限制（private 仓库）] → 仅在 Gate 点手动触发；公开仓库不受限。
- [模拟器无法覆盖相机与权限弹窗] → 以图片注入路径覆盖主流程，真机项明确标注为人工验证。
- [首次 CI 可能需要多轮修复] → 按 L1 → L2 → L3 顺序，先解决编译与逻辑层。
- [Ground Truth 未下发] → 先用自建合成集跑通流程，报告中标注 `source=synthetic`，不宣称达标。

## Migration Plan

本 change 不改变数据 schema。归档 0001–0008 后，主规范保持既有内容（各 change 均为 `skip_specs: true`，无增量需要合并）。

## Open Questions

- 教师测试集与 Reference Test Suite 的下发时间；未下发前只能完成自建集的闭环。
