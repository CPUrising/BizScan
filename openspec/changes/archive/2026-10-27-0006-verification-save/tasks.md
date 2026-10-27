# Tasks

## 1. 校正页

- [x] 1.1 实现 `ReviewViewModel`：字段预填、可编辑、待定区、标签
- [x] 1.2 实现 `ReviewView`：原图预览、表单、标签编辑、保存/取消
- [x] 1.3 空名片保存前二次确认
- [x] 1.4 连点保存幂等保护

## 2. 保存与持久化

- [x] 2.1 原图/校正图写入 `ImageStore`，记录保存相对路径
- [x] 2.2 组装 `BusinessCard`，调用仓库保存
- [x] 2.3 保存后刷新名片夹；取消不产生记录
- [x] 2.4 详情页支持标签编辑并更新 `updatedAt`

## 3. 测试与验证

- [ ] 3.1 `VerificationUITests`：T11 人工修改后保存
- [ ] 3.2 `PersistenceUITests`：T18 Kill App 后图像、字段、标签、备注仍在
- [ ] 3.3 UI 测试：T12 保存后列表出现新名片
- [ ] 3.4 macOS/CI 执行 `bash scripts/verify.sh --change 0006-verification-save`
- [ ] 3.5 回填 `docs/verify/0006-verification-save.md`
