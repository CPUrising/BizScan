# Tasks

## 1. 格式

- [x] 1.1 实现 `VCardBuilder`：`FN/N/ORG/TITLE/TEL/EMAIL/URL/ADR/NOTE`
- [x] 1.2 实现特殊字符转义（反斜杠、分号、逗号、换行）
- [x] 1.3 实现 UTF-8 75 字节折行
- [x] 1.4 空字段省略，不推断网址

## 2. 导出与分享

- [x] 2.1 实现 `VCardFileExporter`：写临时 `.vcf`
- [x] 2.2 实现 `ShareSheet` 包装
- [x] 2.3 详情页菜单接入导出，失败时提示

## 3. 测试与验证

- [x] 3.1 `VCardBuilderTests`：T19 映射、多值、转义、折行、空字段
- [ ] 3.2 `VCardExporterTests`：文件写入与内容一致性
- [ ] 3.3 `ExportUITests`：T19 从详情页触发导出
- [ ] 3.4 macOS/CI 执行 `bash scripts/verify.sh --change 0008-export`
- [ ] 3.5 回填 `docs/verify/0008-export.md`
