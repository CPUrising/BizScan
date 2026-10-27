# Tasks

## 1. 基础规则

- [x] 1.1 实现 `ContactNormalizer`：全角半角、号码、邮箱、网址
- [x] 1.2 实现 `FieldLabels`：中英标签、标签行拆分、关键词表
- [x] 1.3 实现 `PhoneClassifier`：标签优先 + 号码格式规则

## 2. 解析

- [x] 2.1 实现 `ParsedCard` 与八字段映射
- [x] 2.2 实现多值去重、顺序保持、地址多行拼接
- [x] 2.3 实现待定区与 `ParsingDiagnostic` 归因
- [x] 2.4 实现不虚构约束：`website` 只能来自显式域名或标签
- [x] 2.5 实现中英混排单行 token 拆分

## 3. 测试与验证

- [x] 3.1 `FieldParserTests`：T08 标准名片、中英混排、人名/公司混淆
- [x] 3.2 `NoFabricationTests`：T09 缺失字段、歧义保留、无占位符
- [x] 3.3 `PhoneClassifierTests` / `ContactNormalizerTests`
- [ ] 3.4 对 `fixtures/` 全量生成字段级准确率（`docs/eval/field-report.md`）
- [ ] 3.5 `swift test --package-path Packages/BizScanCore` 在 macOS/CI 通过
- [ ] 3.6 回填 `docs/verify/0005-field-parser.md`，逐条标注 T08–T10
