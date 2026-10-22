# Proposal

## Why

主规范已冻结，但工程尚无任何可运行骨架：没有工程文件、数据模型与仓库抽象，后续的采集、识别与校正无处挂载。先建立稳定的软件骨架，再接入相机与 OCR，符合 `openspec/project.md` 的依赖顺序，也避免 AI 从 UI 反向臆造数据层。

## What Changes

- 建立 XcodeGen 工程定义（`project.yml`）与 SwiftPM 逻辑包依赖。
- 新增 SwiftData 实体 `BusinessCardEntity`、`TagEntity`，图像以相对路径存储。
- 新增 `BusinessCardRepository` 协议与 SwiftData / 内存两套实现；新增 `ImageStoring` 与文件实现。
- 新增依赖容器 `AppEnvironment`，统一注入仓库、检测、校正、OCR 与导出服务。
- 新增名片夹首页（列表 / 空态 / 标签筛选 / 删除）、详情页（查看 / 删除 / 导出入口）、搜索页与导航。
- 建立"启动即空名片夹"的可测试路径：`-ui-testing` 使用内存容器。

不包含：相机、边界检测、OCR、字段解析（由后续 change 交付）。

## Capabilities

### New Capabilities

无。本 change 实现 `openspec/specs/` 中既有 `card-model`、`card-list`、`card-detail`、`persistence` 的行为合同，不新增或修改需求。

### Modified Capabilities

无。若实现过程中发现行为需要调整，必须改为提交带 `## MODIFIED Requirements` 的增量规范，而不是直接编辑主规范。

## Impact

- 代码：`BizScan/App`、`BizScan/Models`、`BizScan/Repositories`、`BizScan/ViewModels/HomeViewModel.swift`、`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/ViewModels/SearchViewModel.swift`、`BizScan/Views/HomeView.swift`、`BizScan/Views/DetailView.swift`、`BizScan/Views/SearchView.swift`
- 工程：`project.yml`、`.github/workflows/ios.yml`、`scripts/verify.sh`
- 测试：`BizScanTests/RepositoryTests.swift`、`BizScanUITests/LaunchUITests.swift`
- 数据：新增 SwiftData schema（`BusinessCardEntity`、`TagEntity`）
