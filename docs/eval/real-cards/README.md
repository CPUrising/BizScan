# 真实名片评估数据集（real-001）

> 用途：用本机 `card_test/` 的 14 张真实名片补 OCR/字段准确率证据。
> 图片**不入库**（`card_test/` 已在 `.gitignore`）。本目录只保存索引与标注规则。
> 基线关系：与 `synthetic-001` **并列**，不替换。

## 1. 目录与文件

```text
docs/eval/real-cards/
├─ README.md              # 本文件：标注规则与交接说明（入库）
└─ index.json             # case id → 本机图片相对路径 + 语言/方向/标签（入库，不含个人信息）

card_test/                 # 本机独有，.gitignore
├─ english|zh_sp|zh_tw/   # 14 张原图（c009 已由所有者删除）
└─ ground_truth/          # c001.json … c015.json（c009 除外），含真实个人信息，禁止入库
```

构建时 `project.yml` 把 `card_test/` 与本目录作为**可选资源**打进测试 bundle（仅本机构建产物，`build/` 已忽略）；逐例原始输出写到模拟器临时目录并作为附件留在 `.xcresult`。

## 2. case id 映射

| id | 本机路径（相对仓库根） | 语言 | 备注 |
|---|---|---|---|
| c001 | `card_test/english/images (4).jpg` | en | |
| c002 | `card_test/english/images (5).jpg` | en | |
| c003 | `card_test/english/images.jpg` | en | |
| c004 | `card_test/english/images.png` | en | |
| c005 | `card_test/english/emily-thompson-business-card-designed-by-zoviz-business-card-maker.jpg` | en | 设计稿 |
| c006 | `card_test/english/v2-794c286327e512b81ce509900c115863_720w.jpg` | en | |
| c007 | `card_test/zh_sp/1453727871316.jpg` | zh-Hans | |
| c008 | `card_test/zh_sp/7515_list.jpg` | zh-Hans | |
| c010 | `card_test/zh_sp/images (2).jpg` | zh-Hans | |
| c011 | `card_test/zh_sp/images——zh.png` | zh-Hans | |
| c012 | `card_test/zh_tw/8e04a800adc6fdee7ebb90bdc070a0e2.jpg` | zh-Hant | |
| c013 | `card_test/zh_tw/BUA1LS0009-letterpress名片正面模擬-20231019.jpg` | zh-Hant | 设计稿/模擬图 |
| c014 | `card_test/zh_tw/images (1).jpg` | zh-Hant | |
| c015 | `card_test/zh_tw/images (3).jpg` | zh-Hant | |

> `c009` 已由项目所有者删除（GT 与对应图片均已移除），id 不复用；当前数据集为 14 例：`en` 6、`zh-Hans` 4、`zh-Hant` 4。

## 3. Ground Truth 标注规则

1. **只写图上可见的文字**。看不清就不写该字段，在 `notes` 说明「字迹模糊/不可辨」。
2. **禁止推断**：图上没有 website 就不写 `website`；不要根据公司名补域名，不要补国家码，不要补区号。
3. **保留原始写法**：电话保留空格/连字符/括号，邮箱保留大小写，地址按图上顺序。
4. 字段归属按语义：人名 → `name`；公司/机构 → `company`；职称/职务 → `jobTitle`；部门 → `department`；手机 → `mobiles`；座机/总机 → `officePhones`；传真 → `faxes`；邮箱 → `emails`；网址 → `website`；地址 → `address`；邮编 → `postalCode`。
5. 多值字段用数组；缺失字段**省略**（不要写空字符串）。
6. 歧义必须留痕：例如「Jordan Lee / Lee Consulting」式人名公司混淆、多号码无标签、中英混排、竖版阅读顺序，写进 `notes`，不要静默猜测。
7. `notes` 里同时写：样本来源（实拍/设计稿）、图片质量问题、无法判定的字段。

## 4. 交接给读图 AI 的任务

1. 读 `docs/eval/real-cards/README.md`（本文件）与 `index.json`。
2. 按 §2 的顺序逐张打开图片（绝对路径：仓库根 + §2 相对路径）。
3. 为每张生成 `card_test/ground_truth/<id>.json`，结构遵循 `fixtures/ground_truth.schema.json`：
   - `id` 必填，格式 `^c[0-9]{3}$`；
   - 只允许 schema 里的字段，不得新增自定义键；
   - 缺失字段省略或 `null`。
4. 回填 `index.json` 中每例的 `language`、`orientation`（landscape/portrait/square）、`tags`、`notes`。
5. 不修改其他文件，不复制、不移动、不改名图片，不把图片内容写入 Git。

## 5. 人工确认清单（已完成）

- [x] 逐条核对 `card_test/ground_truth/` 与图片是否一致（项目所有者确认，2026-10-27）
- [x] 确认歧义字段的最终归属（人名/公司、号码类型、地址换行）
- [x] 确认设计稿计入最终结论，并按 `tags` 分组对照
- [x] 删除样本 `c009` 及其图片
- [x] 报告注明「AI 起草 + 人工确认」

## 6. 评估口径

与 `docs/eval/ocr-field-baseline.md` 完全一致：

| 字段类型 | 归一化 |
|---|---|
| 文本（name/company/jobTitle/department/address/postalCode） | 全角转半角、trim、折叠空白、小写 |
| 电话 | 只保留数字 |
| 邮箱 | trim + 小写 |
| 网址 | 小写、去 `http(s)://`、去尾部 `/`、去前缀 `www.` |

计数：`correct` = 输出 ∩ GT；`wrong` = 输出不在 GT；`missing` = GT 未输出；`fabricated` = GT 为空但输出非空。

硬门槛只有两条：`fabricated == 0`；数据集可读（14 例均能加载并跑完链路）。**不设准确率阈值**。
