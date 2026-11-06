# Design

## Context

`AppEnvironment` 目前只注入 `repository`、`imageStore`、`vcardExporter`。详情页底部按钮在 0020 中做成禁用占位。`Info.plist` 已有 `NSContactsUsageDescription`。

## Decisions

### 1. 服务抽象

```swift
enum ContactsSaveResult: Equatable {
    case saved
    case alreadyExists
}

enum ContactsServiceError: LocalizedError {
    case denied
    case failed(String)
}

@MainActor
protocol ContactsSaving {
    func save(_ card: BusinessCard) async throws -> ContactsSaveResult
}
```

`AppEnvironment` 增加 `contactsService: ContactsSaving`，默认 `SystemContactsService()`；测试注入 `FakeContactsService`。

### 2. 字段映射

`ContactsMapper.makeContact(from:) -> CNMutableContact`（纯函数）：

| 名片字段 | 通讯录字段 |
|---|---|
| `name` | `givenName`（整串，不拆分） |
| `company` | `organizationName` |
| `jobTitle` | `jobTitle` |
| `department` | `departmentName` |
| `mobiles` | `phoneNumbers`（`.mobile`） |
| `officePhones` | `phoneNumbers`（`.work`） |
| `faxes` | `phoneNumbers`（`.workFax`） |
| `emails` | `emailAddresses`（`.work`） |
| `website` | `urlAddresses`（`.work`） |
| `address` / `postalCode` | `postalAddresses`（`street` / `postalCode`） |

不写 `note`：iOS 需要额外 entitlement，超出本次范围。

### 3. 重复检测

同姓名 + 任一号码/邮箱相同视为已存在：

1. `CNContactStore.unifiedContacts(matching: predicate, keysToFetch: [identifier, phoneNumbers, emailAddresses])`，谓词用 `CNContact.predicateForContacts(matchingName:)`
2. 比较归一化（去掉空白与 `-`）后的号码，或小写邮箱
3. 命中返回 `.alreadyExists`，不写入

### 4. 权限

`requestAccess(for: .contacts)`（iOS 18 使用 `requestAccess` 的 async 版本）。拒绝时抛 `.denied`，UI 提示并跳系统设置。

### 5. UI 状态

`DetailViewModel` 增加：

```swift
var isSavingToContacts = false
var contactsMessage: String?       // 「该联系人已在通讯录中」等
var didSaveToContacts = false      // 按钮变「已存入」
var contactsNeedsSettings = false  // 弹窗提供「前往设置」
```

按钮三态：

| 状态 | 文案 | 颜色 | 可点 |
|---|---|---|---|
| 初始 | 存入通讯录 | `#42AD73` | 是 |
| 保存中 | 存入中… | `#42AD73` 60% | 否 |
| 成功 | 已存入 | `#42AD73` 60% | 否 |

失败/已存在 → alert；未授权 → alert 带「前往设置」。

### 6. 并发

`SystemContactsService` 标 `@MainActor`，内部把 `store.execute` 放入 `Task.detached` 以避免阻塞主线程；`MainActor` 上只做状态编排。

## Risks / Trade-offs

- **模拟器权限弹窗**：UI 测试无法稳定同意系统权限，故 T31–T33 以 L2（假服务）+ 真机人工清单覆盖；UI 用例只断言按钮可用。
- **同名不同人**：以「姓名 + 任一号码」判重，宁可提示已存在也不写重复。
- **`givenName` 整串**：英文姓名不拆姓/名，与设计稿数据一致；如需拆分另开 change。
- **已存入状态不持久化**：仅本次会话有效，重新进入详情会回到「存入通讯录」。

## Migration Plan

无数据迁移；权限文案变更需重新生成工程。

## Open Questions

无。
