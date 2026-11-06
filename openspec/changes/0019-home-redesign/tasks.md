# Tasks

## 1. 主题与文案

- [x] 1.1 新增 `BizScan/Views/DesignSystem/Theme.swift`（颜色、间距、圆角、字体辅助）
- [x] 1.2 `AppCopy.cardHolder` 改为「名片」，新增搜索占位与空状态文案
- [x] 1.3 `RootView` 施加 `.preferredColorScheme(.dark)`

## 2. 主页头部

- [x] 2.1 `HomeView` 隐藏系统导航栏，自绘标题栏（「名片」26/700 + 40×40「+」）
- [x] 2.2 常驻搜索框（350×46、`#252525`、r12、占位「请输入姓名/公司/职位搜索」），点击进入搜索页
- [x] 2.3 分组行重绘：当前分组 + 数量 + 「分组管理」，颜色/字号按稿

## 3. 列表

- [x] 3.1 `HomeViewModel` 增加 `sections`：按 `createdAt` 倒序 + `startOfDay` 分组，标题 `yyyy-MM-dd`
- [x] 3.2 新增 `Components/CardListRow.swift`：98×64 缩略图、姓名 19/500、职位/公司两行、`…` 菜单
- [x] 3.3 `HomeView` 改为 `ScrollView + LazyVStack`，日期头 46、行高 108、分隔线 1px
- [x] 3.4 行菜单：移动到分组 / 删除（替换左滑删除）
- [x] 3.5 空状态重绘 + 底部居中 68pt FAB；移除右下 FAB

## 4. 兼容

- [x] 4.1 `DetailView` 过渡期显式显示系统导航栏，避免首页隐藏后详情无返回
- [x] 4.2 搜索页保持可 push/sheet 进入，不改内部实现

## 5. 测试

- [x] 5.1 `HomeViewModelTests`：按 `createdAt` 分组、组内顺序、编辑不换组
- [x] 5.2 UI 测试更新：所有 `launchSeeded` 等待条件改为新标题/`+`；T17 改为行菜单删除
- [x] 5.3 新增 `testT24HomeGroupsByCreatedDate`、`testT25HomeUsesDarkAppearance`（外观用截图/颜色断言不现实，改为断言常驻控件）

## 6. 校验与文档

- [x] 6.1 `docs/traceability.md` 更新 T01/T17，新增 T24–T25
- [x] 6.2 `docs/verify/0019-home-redesign.md` + README P8
- [x] 6.3 `openspec validate 0019-home-redesign --strict`
- [x] 6.4 `bash scripts/verify.sh --change 0019-home-redesign`
