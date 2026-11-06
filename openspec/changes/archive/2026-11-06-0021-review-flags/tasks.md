# Tasks

## 1. Core

- [x] 1.1 `BusinessCard` 新增 `unverifiedValues: [String] = []`
- [x] 1.2 新增 `UnverifiedValueDetector`（阈值 0.7，只标记 phone/email/address 的既有值）
- [x] 1.3 `UnverifiedValueDetectorTests`：低置信度、歧义、高置信度不标记、去重、阈值边界

## 2. 持久化

- [x] 2.1 `BusinessCardEntity` 新增 `unverifiedValues: [String] = []`，三个方向同步
- [x] 2.2 `PersistenceTests` 断言该字段重启后保持

## 3. 保存链路

- [x] 3.1 `ReviewViewModel` 初始化时计算待核对值，`save` 时与当前字段值取交集后写入
- [x] 3.2 `ReviewViewModelTests`：低置信度被写入、修改后剔除

## 4. 详情展示

- [x] 4.1 `ContactEntry` 增加 `needsReview`
- [x] 4.2 详情行展示橙色「待核对」胶囊与提示文案
- [x] 4.3 `DetailViewModelTests`：命中值与未命中值

## 5. 测试与文档

- [x] 5.1 `DetailUITests.testT29ReviewBadge`、`testT30ReviewClearedAfterEdit`（种子数据带待核对值）
- [x] 5.2 `docs/traceability.md` 新增 T29/T30
- [x] 5.3 `docs/verify/0021-review-flags.md` + README P8
- [x] 5.4 `openspec validate 0021-review-flags --strict`
- [x] 5.5 `bash scripts/verify.sh --change 0021-review-flags`
