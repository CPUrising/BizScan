# 验证报告：0013-service-layer-coverage

## 1. 基本信息

| 项 | 值 |
|---|---|
| change id | `0013-service-layer-coverage` |
| 执行人 | 项目所有者（本地终端手动执行） |
| 执行时间 | 2026-10-27 20:03:00 – 20:03:20（Asia/Shanghai） |
| 机器 | macOS 26.3.1 |
| Xcode | `Xcode 26.1.1 / Build version 17B100` |
| 模拟器 | iPhone 16 / iOS 18.0（UDID `BFD06162-AD09-4026-B885-89DFA3AA67F0`） |
| 真机（如有） | 无；真机项见 `docs/verify/manual-device-checklist.md` |
| 命令 | `bash scripts/verify.sh --scope unit --change 0013-service-layer-coverage` |
| 日志 | `artifacts/verify-0013-service-layer-coverage-20261027-200300.log` |
| 结果包 | `artifacts/verify-0013-service-layer-coverage-20261027-200300.xcresult` |

本次为该 change 的第二次本地执行。首轮 `20261027-195644` 编译通过但 10 个断言失败，全部集中在 `ImageCorrectorTests` 的尺寸断言（实际值恒为期望值的 3 倍）；根因是测试造图未固定渲染 scale，修复后本轮全绿。首轮日志保留在 `artifacts/` 作对照。

## 2. 需求覆盖

本 change 在 `.openspec.yaml` 中声明 `skip_specs: true`：不新增、不修改任何 `ADDED / MODIFIED` Scenario，只为既有 Txx 补 L2 服务层证据。以下按 `docs/traceability.md` 逐条登记。

| Requirement | Scenario | 测试方法（类/方法） | 结果 | 备注 |
|---|---|---|---|---|
| `card-detection` | T06 倾斜名片自动识别 | `CardDetectorTests.testT06DetectsClearCardOnContrastBackground`、`testT06DetectsTiltedCard` | PASS（L2） | 清晰卡片包围盒误差 ≤ 12% 画布；倾斜卡片置信度 > 0.4；断言使用包围盒容差而非逐点相等 |
| `card-detection` | T06 检测不到边界 → 回退手动四点 | `CardDetectorTests.testT06BlankImageReturnsNil`、`CropViewModelTests.testT06KeepsDefaultPointsWhenDetectionReturnsNil` | PASS（L2） | 纯色图返回 `nil`，校正页保留默认四点且不写错误 |
| `ocr` | T07 标准名片产生原始文本 | `OCRServiceTests.testT07RecognizesSyntheticCardText` | PASS（L2） | 合成名片经真实 Vision 识别出姓名与公司；坐标归一化见下一条 |
| `ocr` | T07 观察框坐标归一化 | `OCRServiceTests.testObservationsUseNormalizedBoundingBox`、`testEmptyImageReturnsEmptyObservations` | PASS（L2） | 全部 `boundingBox` ∈ [0,1]；空白图返回空数组不抛错 |
| `verification` | T20 校正页 90° 旋转 | `ImageCorrectorTests.testRotationQuarterTurnsSwapDimensions`、`CropViewModelTests.testRotateCyclesQuarterTurns` | PASS（L2） | 1/3 档互换宽高、2 档保持不变；ViewModel 旋转循环 1→2→3→0 |
| `verification` | T20 手动四点校正产出结果 | `CropViewModelTests.testT20ProcessProducesResultFromManualPoints` | PASS（L2） | 结果含解析字段，`isProcessing` 复位 |
| `verification` | 校正失败提示 | `CropViewModelTests.testProcessFailureSetsErrorMessage` | PASS（L2） | 校正器抛错时 `result == nil` 且写入 `errorMessage` |
| —（接线） | 检测失败仍可用手动四点继续 | `ScanPipelineTests.testRunUsesManualQuadWhenDetectorFails` | PASS（L2） | 流水线回退到 `manualQuad`，不中断 |
| —（接线） | OCR 结果进入字段解析 | `ScanPipelineTests.testRunParsesFieldsFromOCRObservations` | PASS（L2） | `observations` 2 条 → 姓名/公司命中 |
| —（接线） | OCR 抛错不丢原图 | `ScanPipelineTests.testRunKeepsOriginalImageWhenOCRThrows` | PASS（L2） | `observations` 为空、`originalImage` 保持同一对象 |
| —（接线） | 无 `cgImage` 的图像直接拒绝 | `ScanPipelineTests.testInvalidImageThrowsInvalidImage` | PASS（L2） | 抛 `ScanPipelineError.invalidImage` |
| `capture` | T03 相机权限允许 / 拒绝 | — | NOT RUN | 模拟器无相机；已写入 `docs/verify/manual-device-checklist.md` 第 1–2 节，待真机执行；不阻断归档 |
| `capture` | T04 拍摄 → 进入识别 | — | NOT RUN | 同上，人工清单第 3 节 |
| `capture` | T05 相册导入 → 进入识别 | — | NOT RUN | 同上，人工清单第 4 节 |
| `persistence` | T18 Kill App → 重启数据保持（真机） | — | NOT RUN | L2 已由 `0011` 的 `PersistenceTests` 覆盖容器重建；真机杀进程见人工清单第 7 节 |
| `export` | T19 系统分享面板 | — | NOT RUN | ShareSheet 为系统 UI；见人工清单第 8 节 |

执行到的测试套件明细：

| 层 | 测试套件 | 用例数 | 结果 |
|---|---|---|---|
| BizScanCore（L1） | 全部 8 个套件 | 62 | PASS，0 失败 |
| BizScanTests（L2） | `CardDetectorTests` / `ImageCorrectorTests` / `OCRServiceTests` | 4 / 3 / 3 | PASS |
| BizScanTests（L2） | `ScanPipelineTests` / `CropViewModelTests` | 4 / 5 | PASS |
| BizScanTests（L2） | 既有 29 项（`Repository`/`Smoke`/`VCardExporter`/`Review`/`Detail`/`Home`/`Persistence`） | 29 | PASS |
| BizScanTests（L2） | `OCREvaluationTests`（属 `0014`，本轮已随工程编译并执行） | 2 | PASS |
| BizScanTests（L2） | **小计** | **50**（本 change 新增 19） | **PASS，0 失败** |
| BizScanUITests（UI） | 本轮未执行（`--scope unit`） | — | NOT RUN |

## 3. 回归

| 范围 | 命令 | 结果 |
|---|---|---|
| 全量单元测试（L1 core） | `bash scripts/verify.sh --scope unit`（内含 `swift test --package-path Packages/BizScanCore`） | PASS：62 个用例，0 失败 |
| iOS 单元测试（L2） | 同上（`-only-testing:BizScanTests`） | PASS：50 个用例，0 失败（13.330 秒） |
| 既有通过项是否回退 | `docs/regression-log.md` 对照 | 无回退：既有的 29 项 L2 与 62 项 L1 全部保持通过 |
| UI 回归 | — | 本轮不涉及 UI 变更；`0014` 的 `--scope all` 已产出 11 项 UI 全绿证据 |

## 4. 偏差与风险

| 编号 | 偏差 | 等级（阻断/严重/一般） | 处理 |
|---|---|---|---|
| D1 | 首轮 `20261027-195644`：`ImageCorrectorTests` 10 个断言失败，实际尺寸恒为期望值 3 倍（640→1920、480→1440、400→1200、200→600） | 一般 | **已关闭**：`TestSupport.makeImage` 使用默认渲染 scale（模拟器 3x），`UIImage.size` 为点而 `CGImage` 为像素。测试改用 `UIGraphicsImageRendererFormat.scale = 1` 造图后全绿；校正实现未改动 |
| D2 | `CropViewModelTests` 首次编译报 `Cannot find 'OCRObservation' in scope` | 一般 | **已关闭**：测试文件补 `import BizScanCore` |
| D3 | 智能体终端执行时持续报 `DTServiceHubClient failed to bless service hub`、测试运行器无法连接 | 一般 | **已规避**：按 `AGENTS.md` 第 7 节改由本地终端执行；属执行会话差异，非测试或实现缺陷 |
| D4 | T03–T05、T18 真机、T19 分享面板全部 NOT RUN | 一般 | 已接受：模拟器无相机、系统分享面板不可稳定自动化。步骤已固化为 `docs/verify/manual-device-checklist.md`，执行前不宣称通过 |
| D5 | 日志中出现 `CoreData: fault: Could not materialize Objective-C class named "Array"` 与 `libsqlite3.dylib: vnode unlinked while in use` | 一般 | 已确认非本 change 引入：来自 `PersistenceTests` 反复创建/删除临时库，对应用例均 `passed`；记录备查，不修 |

风险：`CardDetectorTests` 使用合成图，Vision 在真实照片上的鲁棒性仍需真机样本评估；`docs/verification-debt.md` 2.3 节已登记。

## 5. 结论

- [ ] Ready for archive：所有本 change 声明的 Scenario 均 PASS（L1/L2），NOT RUN 项均为已知不可自动化且不阻断
- [ ] 需修复后复验
- [x] 需人类决策：可归档，但 T03–T05、T18 真机、T19 分享面板须由真机人工清单补齐后才可宣称 G7 通过

补充说明：

1. 本 change 只新增测试与文档，未改动 `BizScan/`、`Packages/BizScanCore/`、`project.yml` 任何内容；新增文件为 `BizScanTests/` 下 5 个测试文件与 `docs/verify/manual-device-checklist.md`。
2. 本报告依据 `artifacts/verify-0013-service-layer-coverage-20261027-200300.log` 与同名 `.xcresult` 的实际输出填写，未预填任何结论。
3. 首轮失败日志 `20261027-195644` 与更早的环境失败日志 `20261027-195012` 一并保留在 `artifacts/`，用于说明「环境失败 / 测试错误 / 实现错误」的区分。
