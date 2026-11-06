# Tasks

## 1. 服务

- [x] 1.1 新增 `ContactsMapper`：名片 → `CNMutableContact` 字段映射（不写 note）
- [x] 1.2 新增 `ContactsSaving` 协议、`ContactsServiceError`、`ContactsSaveResult`
- [x] 1.3 新增 `SystemContactsService`：权限申请、`predicateForContacts(matchingName:)` 去重、`CNSaveRequest` 写入
- [x] 1.4 `AppEnvironment` 注入 `contactsService`
- [x] 1.5 `project.yml` 更新 `NSContactsUsageDescription` 文案

## 2. ViewModel

- [x] 2.1 `DetailViewModel` 增加 `saveToContacts()` 与 `isSavingToContacts` / `didSaveToContacts` / `contactsMessage` / `contactsNeedsSettings`
- [x] 2.2 失败/已存在/未授权分别映射为可展示状态

## 3. View

- [x] 3.1 底部按钮启用，三态文案与不透明度
- [x] 3.2 已存在/失败 alert；未授权 alert 带「前往设置」
- [x] 3.3 「前往设置」打开 `UIApplication.openSettingsURLString`

## 4. 测试

- [x] 4.1 `ContactsMapperTests`：姓名/公司/职位/部门/电话分类/邮箱/网址/地址
- [x] 4.2 `DetailViewModelTests`：成功、已存在、未授权三条路径（假服务）
- [x] 4.3 `DetailUITests`：按钮可用且非禁用态

## 5. 文档与校验

- [x] 5.1 `manual-device-checklist.md` 增加真机通讯录写入检查项
- [x] 5.2 `docs/traceability.md` 新增 T31–T33
- [x] 5.3 `docs/verify/0022-save-to-contacts.md` + README P8
- [x] 5.4 `openspec validate 0022-save-to-contacts --strict`
- [x] 5.5 `bash scripts/verify.sh --change 0022-save-to-contacts`
