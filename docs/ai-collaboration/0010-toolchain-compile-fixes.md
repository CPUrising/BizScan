# 0010-toolchain-compile-fixes · AI 协作记录

## 1. prompt 范围

出处：`chat_history/Chat01.md`（"根据 readme 进度"→"安装 Xcode / 跑 verify"系列）与 `openspec/changes/archive/2026-10-27-0010-toolchain-compile-fixes/proposal.md`。

授权范围：修复首次真实编译暴露的 5 处编译错误与 3 处验证工具链缺陷，不改行为合同。

明确不做：不新增功能、不改 UI 行为、不调整测试断言。

## 2. AI 产出

- App target 4 处编译错误、`BizScanCore` 1 处（`String.containsCJK` 不存在）。
- `project.yml` 的 XcodeGen 调用方式修正；`scripts/verify.sh` 默认 destination 从 `iPhone 15` 改为本机存在的 `iPhone 16 / iOS 18.0`。
- `docs/verify/0010-toolchain-compile-fixes.md`。

## 3. 人工修正点

| 事项 | 人类动作 |
|---|---|
| 环境准备 | 人类在本机安装 Xcode 26.1.1、XcodeGen，启动模拟器；AI 无法代做 |
| 依赖下载缓慢 | 人类决定改用本地安装，拒绝镜像方案 |
| 归档 | 人类确认后 AI 才执行 `openspec archive` |

## 4. 回归结果

`swift test --package-path Packages/BizScanCore`：62 项通过；`xcodebuild test` 冒烟通过。
证据：[docs/verify/0010-toolchain-compile-fixes.md](../verify/0010-toolchain-compile-fixes.md)。
