# Tasks

## 1. 搜索

- [x] 1.1 实现 `SearchQuery`：姓名/公司/职位/电话/邮箱/地址/备注匹配
- [x] 1.2 号码匹配使用数字键，忽略格式差异
- [x] 1.3 实现 `SearchViewModel` / `SearchView`：输入、结果、空态、进入详情

## 2. 标签与备注

- [x] 2.1 名片夹按标签筛选与"全部"切换
- [x] 2.2 校正页与详情页新增/移除标签
- [x] 2.3 删除标签时从所有名片移除，不删除名片
- [x] 2.4 备注新增、编辑、清空

## 3. 删除

- [x] 3.1 列表与详情页删除确认
- [x] 3.2 删除记录时清理原图与校正图

## 4. 测试与验证

- [x] 4.1 `SearchQueryTests`：T15 多字段、大小写、号码格式
- [x] 4.2 `RepositoryTests`：标签创建/去重/删除同步
- [ ] 4.3 `SearchTagsUITests`：T15 搜索、T16 标签筛选、T17 删除
- [ ] 4.4 macOS/CI 执行 `bash scripts/verify.sh --change 0007-manage-search-tags`
- [ ] 4.5 回填 `docs/verify/0007-manage-search-tags.md`
