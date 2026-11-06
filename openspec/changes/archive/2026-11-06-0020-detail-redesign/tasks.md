# Tasks

## 1. 数据

- [x] 1.1 `BusinessCard` 新增 `isFavorite: Bool`（默认 false）
- [x] 1.2 `BusinessCardEntity` 新增 `isFavorite`，`init` / `domainModel` / `apply` 同步
- [x] 1.3 `PersistenceTests` 断言收藏状态重启保持，旧数据默认 false

## 2. 顶栏与容器

- [x] 2.1 `DetailView` 隐藏系统导航栏，自绘 92pt 顶栏（`#176FD1`）
- [x] 2.2 返回按钮、标题「名片详情」18/600、星标、更多菜单
- [x] 2.3 更多菜单保留导出与删除

## 3. 核心资料卡

- [x] 3.1 姓氏头像（姓名首字 → 公司首字 → 「名」）66pt `#42AD73`
- [x] 3.2 姓名 28/600、职务 14、公司 15
- [x] 3.3 「查看原图」入口，无图隐藏
- [x] 3.4 `CardImageViewer` 全屏查看（缩放 + 下滑/点击关闭）
- [x] 3.5 四个快捷操作按钮与禁用态

## 4. 分段

- [x] 4.1 分组行（`user-round` + 名称 / 「未分组」）
- [x] 4.2 备注卡（标题 12 + 内容 14），无备注隐藏
- [x] 4.3 联系方式行：图标 + 字段名 + 类型胶囊 + 值 + 行内编辑铅笔
- [x] 4.4 `DetailViewModel.contactEntries` 生成条目与 `tel:` / `mailto:` / 网址 / 地图 URL

## 5. 底栏

- [x] 5.1 固定「存入通讯录」按钮（本次禁用），`safeAreaInset`

## 6. 测试

- [x] 6.1 `DetailViewModelTests`：收藏切换与持久化、contactEntries 类型胶囊、快捷操作 URL、头像首字回退
- [x] 6.2 `DetailUITests`：T26、T27、T28，并保证 T13/T14/T23 通过
- [x] 6.3 更新既有 UI 用例的返回/编辑入口

## 7. 文档与校验

- [x] 7.1 `docs/traceability.md` 更新 T13/T14，新增 T26–T28
- [x] 7.2 `docs/verify/0020-detail-redesign.md` + README P8
- [x] 7.3 `openspec validate 0020-detail-redesign --strict`
- [x] 7.4 `bash scripts/verify.sh --change 0020-detail-redesign`
