# Tasks

## 1. 持久化加固

- [ ] 1.1 修改 `BizScan/App/BizScanApp.swift`：创建 `Application Support` 目录后再建生产容器
- [ ] 1.2 移除生产环境静默内存回退，失败时 `fatalError` 并输出明确错误
- [ ] 1.3 保留 `-ui-testing` 内存容器；新增 `-ui-testing-persistent` / `-ui-testing-reset`

## 2. T18 自动化

- [ ] 2.1 新增 `BizScanUITests/PersistenceUITests.swift`
- [ ] 2.2 覆盖 seed → terminate → relaunch → 数据仍在

## 3. 文档与验证

- [ ] 3.1 新增 `docs/verify/0016-persistence-hardening.md`
- [ ] 3.2 更新 `docs/traceability.md` T18 行
- [ ] 3.3 更新 `docs/verification-debt.md`
- [ ] 3.4 更新 README P7 状态
- [ ] 3.5 `openspec validate 0016-persistence-hardening --strict`
- [ ] 3.6 CI 验证通过
