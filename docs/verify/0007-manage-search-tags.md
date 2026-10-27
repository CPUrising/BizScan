# 验证报告：0007-manage-search-tags

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0007-manage-search-tags` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 19:02:23 – 19:04:02（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无 |
| 命令 | `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage`（本 change 未单独起批次） |
| 日志 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.log` |
| 结果包 | `artifacts/verify-0011-l2-test-coverage-20261027-190223.xcresult` |

本 change 完成时未留存报告。下列结论取自 `0011` 的同一批 `--scope all` 执行。

## 2. 需求覆盖

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `card-detail` | T13 打开名片 → 全部字段 | `BizScanUITests/DetailUITests.testT13EmptyFieldsAreNotShown`、`CardListUITests.testT13OpenDetailShowsSavedFields`、`DetailViewModelTests.testLoadPopulatesDisplayRows` | PASS（UI + L2） | UI 验证有值渲染与空字段隐藏，L2 验证展示行组装 |
| `card-detail` | T14 编辑姓名/公司 → 保存 → 更新 | `DetailUITests.testT14EditNamePersistsInDetail`、`DetailViewModelTests.testSaveWritesEditedNameAndTouchesUpdatedAt`、`testCancelEditingRestoresOriginalValues` | PASS（UI + L2） | `updatedAt` 刷新且取消可回滚 |
| `search-tags` | T15 按姓名搜索 | `SearchTagsUITests.testT15SearchByName` | PASS（UI + L1） | 另有 `SearchQueryTests`（8 项）覆盖多字段包含匹配 |
| `search-tags` | T15 按公司与号码搜索 | `SearchTagsUITests.testT15SearchByCompany`、`BizScanCoreTests/SearchQueryTests` | PASS（UI + L1） | 号码格式无关匹配 |
| `search-tags` | T16 加标签 → 按标签筛选 | `SearchTagsUITests.testT16TagFilterShowsOnlyTaggedCards`、`HomeViewModelTests.testToggleTagFilterShowsOnlyTaggedCards`、`TagStoreTests`（7 项） | PASS（UI + L2 + L1） | 「全部」可还原 |
| `search-tags` | 详情页新增标签并保存 | `DetailViewModelTests.testAddTagThenSavePersistsToRepository` | PASS（L2） | 大小写去重由 `RepositoryTests.testTagCreationIsCaseInsensitive` 覆盖 |
| `card-list` | T17 删除名片 → 从列表消失 | `CardListUITests.testT17DeleteCardRemovesItFromList`、`HomeViewModelTests.testDeleteRemovesCardFromList`、`DetailViewModelTests.testDeleteRemovesCardAndSetsDidDelete` | PASS（UI + L2） |  |
| `card-list` | 删除同步清理图像文件 | `BizScanTests/PersistenceTests.testDeleteCardRemovesImageFiles` | PASS（L2） |  |
| `card-detail` | 备注新增/编辑/清空 | — | NOT RUN | 无测试；`DetailViewModel` 备注路径仅被 T18 的持久化断言间接触及 |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope all` | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上 | PASS：29 个用例，0 失败 |
| 全量 UI 测试 | 同上 | PASS：11 个用例，0 失败 |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退，与 `0009` 基线一致 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 本 change 无独立验证批次 | 一般 | 已接受：见 `0012/design.md` 决策 1 |
| D2 | 备注功能无自动化证据 | 一般 | 未关闭：已登记 `docs/verification-debt.md`，不阻断归档 |
| D3 | 搜索未覆盖拼音与模糊纠错 | 一般 | 属 proposal 明确排除项，不计偏差 |

## 5. 结论

- [ ] Ready for archive：所有 Scenario PASS，无阻断偏差
- [ ] 需修复后复验（列出待修项）
- [x] 需人类决策（列出选项）

补充说明：

1. T13–T17 均有 UI 级证据，是本项目当前验收强度最高的一组。
2. 待决策项：接受现状归档（备注留债，选项 A）／补备注用例后再归档（选项 B）。
