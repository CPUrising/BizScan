# Design

## Context

见 `proposal.md`。导出涉及格式正确性与系统交互两部分；格式部分可在 `BizScanCore` 完整单测，系统交互部分留给 UI 测试与人工验证。

## Goals / Non-Goals

**Goals:**

- vCard 通过第三方通讯录导入（iOS/Android）时字段不丢失。
- 不输出空的 `URL`、`ADR`、`EMAIL`，也不推断网址。
- 导出失败有可见反馈，且不破坏名片数据。

**Non-Goals:**

- 不支持 vCard 4.0 的扩展属性。
- 不做二维码名片、Email Signature。
- 不直接写系统通讯录（当前以文件分享替代）。

## Decisions

1. **选择 vCard 3.0**
   - 理由：兼容性最好，`TEL;TYPE=CELL/WORK/FAX` 语义清晰；系统通讯录可直接导入。
   - 备选：vCard 4.0（被否：部分旧客户端解析不一致）。

2. **按 UTF-8 字节做 75 字节折行**
   - 理由：RFC 6350 以八位字节计数，中文名片不折行会被部分客户端截断。
   - 备选：按字符数折行（被否：中文会超字节限制）。

3. **先落临时文件再分享，而不是直接传字符串**
   - 理由：`ShareSheet` 对 URL 的支持最稳定，且可直接存到「文件」App。
   - 备选：`UIActivityItemSource` 提供字符串（被否：接收方扩展识别不稳定）。

4. **通讯录写入延后**
   - 理由：需要 `NSContactsUsageDescription` 与权限分支，自动化测试成本高；vCard 已满足"至少一种导出方式"。
   - 备选：同时实现 Contacts（被否：当前阶段收益低，增加失败面）。

## Risks / Trade-offs

- [vCard 字段映射细节（`N` 的姓/名拆分）对中文姓名不适用] → 中文无空格时整体作为 family，导入后仍可显示；记录为已知限制。
- [临时文件累积] → 使用系统临时目录，系统会回收；未主动清理，记录为一般风险。
- [分享面板无法在 UI 测试中完全自动化] → T19 以"生成文件且内容正确"的单测为主，面板行为人工验证。

## Migration Plan

无数据迁移，纯新增导出路径。

## Open Questions

- 是否需要批量导出入口？`VCardBuilder.vCards(for:)` 已支持多张，UI 暂只提供单张导出。
