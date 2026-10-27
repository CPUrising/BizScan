# Tasks

## 1. BizScanCore 编译修复

- [x] 1.1 `FieldParser.swift` 第 264 行 `keyword.containsCJK` → `containsCJK(keyword)`
- [x] 1.2 `FieldParser.swift` 第 273 行 `keyword.containsCJK` → `containsCJK(keyword)`

## 2. App target 编译修复

- [x] 2.1 `PhotoLibraryService.swift` 补 `import SwiftUI`
- [x] 2.2 `ScannerViewModel.swift` 补 `import SwiftUI`
- [x] 2.3 `BizScanApp.swift` 演示数据参数顺序：`tags` 置于 `notes` 之前
- [x] 2.4 `DetailViewModel.swift` 第 142 行补闭包参数 `$0`
- [x] 2.5 `DetailViewModel.swift` 第 149 行补闭包参数 `$0`

## 3. 验证工具链修复

- [x] 3.1 `scripts/verify.sh` 去掉 `xcodegen generate --project` 参数
- [x] 3.2 `Makefile` 去掉 `xcodegen generate --project` 参数
- [x] 3.3 `.github/workflows/ios.yml` 去掉 `xcodegen generate --project` 参数
- [x] 3.4 默认 destination 改为 `platform=iOS Simulator,name=iPhone 16,OS=18.0`（`scripts/verify.sh` 与 CI）

## 4. 验证

- [x] 4.1 `xcodegen generate` 产出单层 `BizScan.xcodeproj`
- [x] 4.2 `xcodebuild build` 通过（App target + BizScanCore）
- [x] 4.3 执行 `bash scripts/verify.sh --scope core --change 0010-toolchain-compile-fixes`（62 个用例随 `--scope unit` 前置阶段执行通过，见验证报告 D3）
- [x] 4.4 执行 `bash scripts/verify.sh --scope unit --change 0010-toolchain-compile-fixes`
- [x] 4.5 回填 `docs/verify/0010-toolchain-compile-fixes.md`

## 5. 收尾

- [x] 5.1 在 `docs/verification-debt.md` 登记本 change 解锁的验证项
- [x] 5.2 更新 `README.md` 阶段看板（P0 G0 状态）
- [x] 5.3 `openspec validate 0010-toolchain-compile-fixes --strict` 校验通过（OpenSpec CLI 1.14.3）
- [x] 5.4 执行 `openspec archive 0010-toolchain-compile-fixes`（人类已批准；CLI 1.14.3 归档为 `2026-10-27-0010-toolchain-compile-fixes`）

## 未覆盖（明确排除）

- 测试失败修复：不属于本 change，见 `design.md` Non-Goals。
