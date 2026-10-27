# Tasks

## 1. 测试脚手架

- [x] 1.1 `BizScanTests/TestSupport.swift`：`makeScanResult(...)`（8×8 纯色图 + 逐字段 `ParsedCard`）
- [x] 1.2 `BizScanTests/TestSupport.swift`：`makeTemporaryContainer()`（临时目录 + `store.sqlite`，返回容器与目录 URL）

## 2. L2 用例

- [x] 2.1 `BizScanTests/VCardExporterTests.swift`：T19 文件写出（单卡字段、空集合、多卡、缺 website、临时目录）
- [x] 2.2 `BizScanTests/ReviewViewModelTests.swift`：预填、T11 人工校正落库、T12 首次保存写图像路径、空卡二次确认、既有名片不重复
- [x] 2.3 `BizScanTests/DetailViewModelTests.swift`：加载展示行、取消编辑回滚、保存改写并刷新时间、删除、加标签
- [x] 2.4 `BizScanTests/HomeViewModelTests.swift`：按 `updatedAt` 倒序、删除后刷新、标签筛选
- [x] 2.5 `BizScanTests/PersistenceTests.swift`：T18 重开容器数据保持、标签持久化、`FileImageStore` 往返、删除清理图像

## 3. 验证与证据

- [x] 3.1 `bash scripts/verify.sh --scope unit --change 0011-l2-test-coverage` 全绿（失败按 AGENTS.md 第 5 节最多 3 轮自愈）
- [x] 3.2 `bash scripts/verify.sh --scope all --change 0011-l2-test-coverage` 产出正式日志与 `.xcresult`
- [x] 3.3 回填 `docs/verify/0011-l2-test-coverage.md`，T11/T12/T18/T19 的 UI 行记 NOT RUN

> 不改 `project.yml`、不改 `BizScan/` 下源码、不写 UI 测试、不新增 fixture。
