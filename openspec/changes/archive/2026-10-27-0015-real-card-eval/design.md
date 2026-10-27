# Design

## 1. 数据放哪里

`fixtures/` 的语义是「教师下发的固定测试集」，且 `fixtures/manifest.json` 的 `source` 只有 `teacher | synthetic`。真实名片含个人信息，不能进 `fixtures/cards/`，也不能进 Git。

决定：

| 内容 | 位置 | 是否入库 |
|---|---|---|
| 15 张原图中的 14 张 | `card_test/{english,zh_sp,zh_tw}/` | 否（`.gitignore` 已忽略 `card_test/`） |
| Ground Truth | `card_test/ground_truth/c001–c015.json`（`c009` 已删除） | 否 |
| 逐例原始输出 | 模拟器临时目录 + `.xcresult` 附件 | 否 |
| 索引（id → 相对路径 + 语言/方向/标签） | `docs/eval/real-cards/index.json` | 是（不含联系方式） |
| 标注规则与人工确认清单 | `docs/eval/real-cards/README.md` | 是 |
| 聚合指标与误差分类 | `docs/eval/real-card-baseline.md` | 是（不含个人信息） |

模拟器沙盒读不到仓库绝对路径，因此 `project.yml` 把 `card_test/` 与 `docs/eval/real-cards/` 作为**可选资源**打进 `BizScanTests` bundle：本机构建时存在，CI 上缺失时自动跳过。构建产物在 `build/`，已被忽略，不会把个人信息带进 Git。

## 2. case id 与数据来源

- id 固定 `c001`–`c015`，符合 `fixtures/ground_truth.schema.json` 的 `^c[0-9]{3}$`；`c009` 已由项目所有者删除，id 不复用。
- 语言分布：`en` 6、`zh-Hans` 4、`zh-Hant` 4，共 14 例。
- `index.json` 的 `tags` 标出 `photo / design-mockup / template / placeholder / low-res / rotated / blurry / two-sided / multi-phone`，供报告分组说明。
- 14 张全部计入总数（项目所有者决定「都可以使用」）；设计稿与占位模板不排除，但在报告中单列其占比与影响。

## 3. GT 起草与人工确认

1. 读图 AI 只依据图片可见文字起草，禁止补域名、补区号、编造字段；歧义写入 `notes`。
2. 项目所有者已逐条核对 `card_test/ground_truth/`（2026-10-27），并删除 `c009`；后续如再改动 GT，需重新核对。
3. 报告显著标注「GT = AI 起草 + 人工确认」。
4. **禁止**用 App 自身 OCR 输出反填 GT（自证循环，评估作废）。

## 4. 评估口径

与 `0014` 完全一致，复用 `EvalNormalizer`：

| 字段类型 | 归一化 |
|---|---|
| 文本（name/company/jobTitle/department/address/postalCode） | 全角转半角、trim、折叠空白、小写 |
| 电话（mobiles/officePhones/faxes） | 只保留数字 |
| 邮箱 | trim + 小写 |
| 网址 | 小写、去 `http(s)://`、去尾部 `/`、去前缀 `www.` |

计数按集合：`correct` = 输出 ∩ GT；`wrong` = 输出中不在 GT；`missing` = GT 未被输出；`fabricated` = GT 为空但输出非空。

## 5. 与 synthetic-001 的关系

并列，不替换：

- `synthetic-001` 保留，用于回归与「理想图上限」对照。
- `real-001` 新增，用于真实拍摄条件下的现状。
- 报告同时给出两份，README §11 之后并列登记；`real-001` 只有 14 例（< 30），只报绝对值，不宣称正式准确率。

## 6. 跳过策略

`card_test/` 只存在于本机。数据集根目录按以下顺序解析：

1. 测试 bundle 内的 `card_test/`（`project.yml` 的可选资源）。
2. 仓库根 `card_test/`（本机直接运行时的回退）。

两者都不存在 → `XCTSkip`，原因写明「card_test/ 仅本机存在（已 .gitignore），CI 跳过」。资源存在但 GT 或图片缺失 → 失败，不跳过（说明数据集不完整）。

该跳过只针对本机资产缺失，不掩盖任何实现失败；报告第 4 节登记为偏差。

## 7. 硬门槛

1. `fabricated == 0`（README §11：虚构字段是阻断缺陷）。
2. 14 例全部能加载并跑完链路（`processed == 14`）。
3. OCR 原始文本非空至少 1 例（否则链路或数据不可用）。

不设「准确率 ≥ N%」。概率性指标设阈值会诱导调参或放宽断言（AGENTS.md §7）。

## 8. 本轮不做

- 不做与 CamCard 的结果比较（项目所有者决定：只看与 GT 的差异；CamCard 版本也未锁定）。
- 不改 `FieldParser`、OCR 参数、检测阈值来凑分。
- 不入库图片，不做图片脱敏重绘（改图后不再是原名片）。
- 不修改 `openspec/specs/`、`fixtures/`、产品代码。

## 9. 风险

| 风险 | 处理 |
|---|---|
| 真实照片分辨率偏低（最短边 236–695） | 报告按 `low-res` 标签分组，检测失败单列 |
| EXIF 方向：`UIImage.cgImage` 不含方向信息，`VisionOCRService` 固定 `.up` | 若出现整张旋转误识别，记为产品偏差，另开 change 修导入链路 |
| 设计稿/占位模板含假信息 | tags 标注，报告给出设计稿子集的指标，结论以实拍子集为主 |
| GT 含真实个人信息 | 只存本机；报告只写聚合值与 case id，不写联系方式 |
| 资源被打进测试 bundle | `card_test/` 只作为本机构建的可选资源；`build/` 已忽略；CI 上不存在则跳过，不产生含个人信息的产物 |
