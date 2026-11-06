# Tasks

## 1. 模型可空

- [x] 1.1 `BusinessCard.originalImagePath` 改为 `String?`
- [x] 1.2 `BusinessCardEntity.originalImagePath` 改为 `String?`，三个方向同步
- [x] 1.3 `ReviewViewModel` 初始化改用 `originalImagePath: nil`；`ReviewViewModelTests` 断言改为非 `nil`
- [x] 1.4 `PersistenceTests` 适配可选类型并补「旧记录仍有路径」

## 2. 无图分支

- [x] 2.1 `SwiftDataBusinessCardRepository.delete` 仅在路径非空时清理文件
- [x] 2.2 `HomeViewModel` / `SearchViewModel` / `DetailViewModel` 的取图方法对 `nil` 返回 `nil`

## 3. 新建名片

- [x] 3.1 新增 `BizScan/ViewModels/NewCardViewModel.swift`（字段、标签、分组、空卡确认、保存）
- [x] 3.2 新增 `BizScan/Views/NewCardView.swift`（表单、保存/取消、分组选择）
- [x] 3.3 `BizScanTests/NewCardViewModelTests.swift`：保存无图记录、空卡确认、取消不落库、分组写入

## 4. 入口

- [x] 4.1 `HomeView` 标题栏新增 `+`，打开 `NewCardView`，保存后刷新列表
- [x] 4.2 `AppCopy` 补「新建名片」「手动新建」等文案

## 5. 测试

- [x] 5.1 `BizScanUITests/CardListUITests.testT34CreateCardManually`
- [x] 5.2 `BizScanUITests/CardListUITests.testT35EmptyManualCardRequiresConfirmation`

## 6. 文档与校验

- [x] 6.1 `docs/traceability.md` 新增 T34–T35
- [x] 6.2 `docs/verify/0018-manual-card-create.md`
- [x] 6.3 `README.md` P8 状态更新
- [x] 6.4 `openspec validate 0018-manual-card-create --strict`
- [x] 6.5 `bash scripts/verify.sh --change 0018-manual-card-create`
