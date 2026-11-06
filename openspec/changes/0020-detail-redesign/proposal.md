# Proposal

## Why

详情页当前是系统 `List(.insetGrouped)`：系统导航栏、顶部大图、左标签右值的字段行、无分组快捷操作。Figma 新稿是完全自定义的深色详情：蓝色 `#176FD1` 顶栏（含收藏星标）、姓氏头像核心卡、查看原图入口、4 个彩色快捷操作、分段卡片（分组 / 备注 / 联系方式）、固定底部「存入通讯录」。

## What Changes

- 隐藏系统导航栏，自绘 92pt 蓝色顶栏：返回、标题 18/600、收藏星标、更多菜单
- 新增 `isFavorite: Bool` 字段并持久化；顶栏星标切换
- 核心资料卡：66pt 姓氏头像（姓名首字 → 公司首字 → 「名」）、姓名 28/600、职务、公司、「查看原图」入口
- 原图全屏查看器（双指缩放、下滑/点击关闭）；无原图时隐藏入口
- 4 个快捷操作：电话（`tel:`）、地址（`maps://`）、备注（滚动定位）、编辑（弹层）
- 分组行、备注卡、联系方式行（图标 + 字段名 + 类型胶囊 + 值 + 行内编辑铅笔）
- 固定底部「存入通讯录」按钮（本次仅视觉与禁用态，`0022` 接线）
- 联系方式值按类型展示胶囊：Mobile / 办公 / 传真

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `card-detail`：详情页结构与外部动作重写；新增收藏、查看原图、快捷操作需求
- `card-model`：新增 `isFavorite` 字段

## Impact

- 代码：`Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift`、`BizScan/Models/BusinessCardEntity.swift`、`BizScan/ViewModels/DetailViewModel.swift`、`BizScan/Views/DetailView.swift`、新增 `BizScan/Views/Components/CardImageViewer.swift`、`BizScan/App/AppCopy.swift`
- 测试：`BizScanTests/DetailViewModelTests.swift`、`BizScanUITests/DetailUITests.swift`
- 文档：`docs/traceability.md`（T13/T26/T27/T28）、`docs/verify/0020-detail-redesign.md`、`README.md`
- 不在范围：待核对标签（0021）、系统通讯录写入（0022）、浅色主题
