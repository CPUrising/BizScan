# 名片详情页 UI 优化

> **Workspace:** /Users/admin/Desktop/BizScan

---

**User**

我需要更改UI，对于名片详情`https://www.figma.com/design/vE1VXGH5J2fhQUTSPX64rx/Untitled?node-id=0-1&m=dev&t=9tPUHdpAEc17uYeG-1`

对于刚打开的页面`https://www.figma.com/design/D0SnsYU3HGFr3y4v0ekuDD/%E5%90%8D%E7%89%87%E4%B8%BB%E9%A1%B5?m=dev&t=1MX3r72iuB3Nt9pG-1`

告诉我你对这个页面的理解

**Assistant**

Error: {"code":4028,"message":"Upstream request failed: [overloaded] the server is overloaded; retry shortly (HTTP Status: 429)"}

---

**User**

继续

**Assistant**

The user wants me to continue. Let me understand the context. The user asked about changing UI for 名片详情 (business card detail) based on a Figma link, and asks "告诉我你对这个页面的理解" (tell me your understanding of this page) for the 名片主页 (business card home page) Figma link.

Earlier turns were produced by a different AI model — I don't have those tool calls. Let me check the workspace and memory first.

Let me do a quick memory pass and explore the project.

Let me start by checking the working directory and memory.

No memory. It's an iOS/Swift project (BizScan.xcodeproj). The user wants to change UI according to Figma designs: 名片详情 page and 名片主页 page.

But the user's latest message is "继续" (continue) — meaning continue from where the previous model left off. I need to figure out what the previous model did. Let me check git status and recent artifacts, and whether there are Figma MCP tools available.

Actually the key request: "我需要更改UI，对于名片详情 [figma link] 对于刚打开的页面 [figma link] 告诉我你对这个页面的理解" — The user wants me to look at the Figma designs and explain my understanding of these pages. Then "继续".

The figma skill is available. Let me check if Figma MCP tools are available — need ToolSearch probably. Let me check git status and README quickly, and search for figma MCP tools.

Let me first check git log/status to see if previous model started work.

No Figma MCP tools found via that search. Let me search more specifically for "figma" tools. Maybe the figma MCP server isn't connected. Let me check .trae config or MCP list.

Let me use ToolSearch with queries like "figma" and tool names.

Figma MCP tools are not available (no figma tools found). The `figma` skill exists but likely requires Figma MCP server configuration. Let me load the figma skill to see if there's a way. But first, since the user is asking "告诉我你对这个页面的理解" (tell me your understanding of this page) — perhaps the previous model already fetched screenshots? Let me check artifacts folder and .screenshots for recent figma exports.

Let me check the artifacts folder and git status (git status gave no output? Actually the output only showed git log — meaning working tree clean).

Let me look for recent files related to figma/UI.

The previous turn's work isn't in the repo (working tree clean). The user asked me to explain my understanding of the pages. Since Figma MCP tools aren't available, maybe I can use WebFetch? Figma design links are authenticated and WebFetch returns empty for private URLs. But the URL has no access... Actually Figma's dev mode links can be accessible if file is public.

Hmm. Let me load the `figma` skill — it may instruct how to get design context via the Figma MCP server, or explain that the MCP isn't connected.

Actually let me first check if there's a Figma MCP available through ToolSearch with different terms like "mcp_figma". Let me search "figma" exact tool names.

The earlier search with "figma" query didn't return figma tools. So MCP Figma server is not connected. 

Let me load the figma skill to confirm and see fallback options.

The skill says use Figma MCP server. But tools aren't available. Let me check the config reference to see how to verify; maybe MCP tools exist but are deferred under names like "mcp_figma_get_design_context". ToolSearch returned only generic ones. Let me try exact tool names.No figma MCP tools. So I cannot fetch Figma designs directly via MCP. Alternatives:
1. Use browser-use agent to open Figma links in browser (needs login maybe). The user is logged in perhaps. The browser agent can navigate the Figma URL and screenshot. But it says file:// not supported; figma.com works.
2. Use WebFetch — likely empty.

The previous model may have done something. Since "继续" is the prompt, perhaps the previous model was about to fetch Figma via browser.

Let me check whether there's a browser-use capability and whether the Figma site is accessible. Given the task is "tell me your understanding of this page", I need to actually see the design.

Let me try WebFetch on the figma links first (cheap).

Actually WebFetch on Figma will return the HTML shell, no design content. But maybe the "m=dev" link has embed metadata.

Better: use the TRAE-browseruse skill? The browser_use agent can navigate and screenshot. But logged-in session may be needed. Let me check if there is a browser MCP server. The available agents include browser_use subagent. Let's try that: open the Figma URL and screenshot. But it can't return images? It reports PASS/FAIL with evidence; screenshots might be accessible.

Hmm, the hard input contract: query <=600 chars, must be an absolute URL.

Alternatively, check whether the Figma file is accessible via Figma REST API? Needs token.

Let's first check the reference config to see if a Figma token is configured somewhere (e.g., env var, ~/.figma...).

Let me read the reference doc.

No figma token. So Figma MCP is unavailable. Option: use the browser (Figma desktop? user has Figma.dmg in Downloads... hmm).

Perhaps the best approach: use the browser_use agent to open the Figma URLs. If the user is logged into Figma in the browser, it can screenshot the design. But the browser agent returns text and maybe screenshots.

Alternatively, ask the user to export screenshots or connect Figma MCP. But the user said "继续" - so they want progress, not questions.

Let me try WebFetch first on the Figma link to see if anything is accessible (public share). Then consider browser.

Also, importantly, I should understand the current app pages: 名片详情 and 名片主页 (home page). The user asked "告诉我你对这个页面的理解" — likely referring to the "刚打开的页面" (the home page that just opened), maybe meaning the app's home page? Hmm, ambiguous. Actually re-reading:

"我需要更改UI，对于名片详情 [figma link] 对于刚打开的页面 [figma link] 告诉我你对这个页面的理解"

Interpretation: They need to change UI: for the 名片详情 (card detail) page — Figma link 1; for the "刚打开的页面" (the page just opened / landing page) — Figma link 2 (名片主页). "告诉我你对这个页面的理解" = tell me your understanding of this page.

So they want me to look at both Figma designs and describe understanding. Then "继续".

Since no Figma MCP, I should attempt to see the designs. Let's try WebFetch.

---

**User**

现在应该可以访问了吧，mcp恢复正常了吗

**Assistant**

The user says "现在应该可以访问了吧，mcp恢复正常了吗" — asking if the Figma MCP is working now. Let me try the Figma MCP tools. I need to discover them via ToolSearch. Earlier tool search found nothing for figma tools except the MCP bridge tools. Let's search again with the MCP bridge names.Let me try fetching the Figma data. The main page link: fileKey D0SnsYU3HGFr3y4v0ekuDD with no node-id. Let me try both files.

Figma API fetch failed. Might be network (clash proxy?) or token. Let me test the other file, and maybe check network via curl to api.figma.com.

Network works (401 because no token in curl). The MCP server's fetch failed — likely the MCP server process was started when network was down, or its configured token/env is broken. "fetch failed" is a Node fetch error, meaning DNS/network from the MCP process. Possibly the MCP server was launched before proxy came up, and its fetch doesn't use proxy.

Let me check MCP config for Figma AI Bridge, and token presence.

There's a FIGMA_API_KEY. Let's test the key directly with curl to api.figma.com/v1/me and /v1/files/... If the key works from shell but MCP fails, it's the MCP process network (npx node fetch might not respect proxy, or DNS issue). "fetch failed" often DNS.

Test key.

Token works from shell. So MCP process has network issue (likely launched before proxy / DNS). Hmm, but "Page 1" with no children at depth=1... Actually depth=1 returns the canvas children empty? That's odd — D0SnsYU3HGFr3y4v0ekuDD file with empty page? Maybe depth=1 truncates. Wait, children:[] means truly empty. Hmm, the "名片主页" file perhaps has contents but the file key... Let me fetch with no depth but it might be big.

Actually the fact curl works means I can just use curl to fetch Figma data directly and analyze it. That's a practical fallback: the MCP is broken but I can retrieve the design JSON via API and images via API exports.

Let me check file contents structure at depth=3 for both files, saving to temp outside workspace (intermediate). Use /tmp.

First the main page file — let's fetch full file list of pages.

Now fetch full details (depth high) for the three frames. Use node ids 7:348, 7:296, 5:863 via /v1/nodes?ids=... which gives geometry and styles.

Also get rendered PNGs via /v1/images to view visually. That's key for "告诉我你对这个页面的理解" — understanding the design.

Let's fetch nodes with ids and images.

Now the empty state.

Now I need design details: colors, fonts, sizes, spacing. Let's parse the node JSON to extract styles (fills, font sizes, radii, padding) for key elements. Let me write a small python script to dump a readable tree with geometry and style for the detail frame and main frame.

Also I should understand current app implementation to compare — user asked "告诉我你对这个页面的理解" (understand the page). Then presumably next step modify UI. But the current request: "现在应该可以访问了吧，mcp恢复正常了吗" — answer MCP status and continue. They said "继续" earlier. So I should report MCP status (MCP bridge still fails, but I got data via Figma API directly) and then deliver understanding of the pages.

Let me extract design tokens.

Now let's check the current app UI code to compare — what exists today for the main list and detail page. Then I can give a grounded understanding of "对这个页面的理解" including gap vs current implementation.

Let me explore BizScan source.

Now let me look at CardRowView, AppCopy, HomeViewModel, DetailViewModel to understand the data available (fields, tags/groups, favorite?). This informs the gap analysis.

Also check HomeViewModel and BusinessCard model for fields like isFavorite, group, needsReview, and whether there's a "待核对" concept (低置信度). Let's check model in BizScanCore package.

Now check BusinessCard model fields for createdAt (date grouping), and whether "needs review / low confidence" exists (待核对 tag). Let's read BusinessCard.swift briefly.

## 一、MCP 状态

Figma AI Bridge MCP **还没恢复**：两次 `get_figma_data` 都返回 `Failed to make request to Figma API endpoint ... fetch failed`（MCP 进程侧网络不通）。但同一 Token 在 shell 里 `curl api.figma.com/v1/me` 返回 **200**，说明是 MCP 进程的出口网络问题，不是权限问题。

所以我改用 Figma REST API 直连拿到了三张画板的结构化 JSON + 2x 渲染图：

| 文件 | 画板 | node |
|---|---|---|
| 名片主页 `D0SnsYU3…` | 名片主页 · 空名片 | `7:348` |
| 名片主页 `D0SnsYU3…` | 名片主页 · 有名片 | `7:296` |
| 名片详情 `vE1VXGH5…` | 名片详情 | `5:863` |

## 二、名片主页的理解

390×844 深色底 `#191919`，完全自定义布局（不是系统 List 风格）：

- **状态栏 54** → **标题栏 58**：左「名片」26/700，右侧 40×40 圆角13 `#2B2B2B` 的「+」
- **搜索框**：350×46、`#252525`、r12，占位「请输入姓名/公司/职位搜索」14 `#A0A0A0`
- **分组行 62**：左「全部名片 + 数量(13 `#777777`)」，右「分组管理」带 folder 图标；底部 1px `#2B2B2B` 分隔
- **列表**：按 `createdAt` 日期分组（「2026-10-26」12/500 `#777777`），行高 108：98×64 r7 原图缩略图 + 姓名 19/500 `#F1F1F1` + 职位/公司 14 `#A0A0A0`（最多两行，长公司名省略）+ 右侧 `ellipsis`，行间 1px 分隔（左右 20 内缩）
- **空状态**：64×48 线稿图标 `#626262` + 「点击下方相机拍摄您的第一张名片」14 `#A0A0A0`
- **常驻 FAB**：68×68 正圆 `#3478F6` 相机，居中固定在底部手势条上方（约 56pt 边距），不随列表滚动

## 三、名片详情的理解

390×900，比主页多出底部操作区，内容可滚动、底部按钮固定。

- **蓝色顶栏 `#176FD1`**（与主页深色风格不同）：返回 chevron + 「名片详情」18/600 + 右侧 **收藏星标**、**更多 ellipsis**
- **核心资料卡 `#202123`**（padding 28/24，gap19）
  - 66pt 圆形姓氏头像 `#42AD73`（取姓名首字，32 号）
  - 姓名 28/600 + 职务 14 `#B5B8BD`
  - 右上「查看原图」：42×34 r6 绿描边小卡 + 11 号绿字
  - 公司 15 `#B5B8BD`
  - **4 个 48pt 快捷圆钮**：电话 `#42AD73` / 地址 `#176FD1` / 备注 `#E7AB52` / 编辑 `#9A7BDB`，下方 13 号灰标签
- **分段结构**：8pt `#171819` 间隔条切块 → 分组行「未分组」→ 备注块（`#333538` 顶线，标题 12 `#858A91` + 内容 14）→ 联系方式块
- **联系方式条目**：左侧 20pt 灰图标 + 字段名 12 + 类型胶囊（`Mobile` 灰 `#292B2E`；**`待核对` 橙 `#3B3021`/`#E7AB52`**）+ 值 16 `#F5F6F7` + 辅助提示「原始识别内容，可在编辑中修正」+ 右侧铅笔（仅电话有）；条目间 `#333538` 分隔线
- **底部固定区**：342×47 r12 `#42AD73`「存入通讯录」16/600

**色彩体系**：页面底 `#171819/#191919`，卡片面 `#202123`，分隔 `#2B2B2B/#333538`，文本三级 `#F5F6F7` → `#B5B8BD/#A0A0A0` → `#858A91/#777777`；强调色 `#42AD73`（详情主操作）、`#3478F6`（主页 FAB）、`#176FD1`（详情顶栏）、`#E7AB52`、`#9A7BDB`。

## 四、和现有实现的差距（重点）

现在的 [HomeView.swift](file:///Users/admin/Desktop/BizScan/BizScan/Views/HomeView.swift) 是 `NavigationStack + List + 系统外观 + 标签胶囊`，[DetailView.swift](file:///Users/admin/Desktop/BizScan/BizScan/Views/DetailView.swift) 是 `List insetGrouped`，两者与新稿差异是全量级的：

1. 主页需重写为深色自定义列表：内联搜索框、日期分组、分组管理入口、底部居中 FAB；标题文案「名片夹 → 名片」，空状态文案也要换。
2. 详情需重写为分段卡片：蓝色顶栏、头像、查看原图、4 个快捷操作、待核对标记、收藏、固定底部按钮。
3. **数据模型缺口**（[BusinessCard.swift](file:///Users/admin/Desktop/BizScan/Packages/BizScanCore/Sources/BizScanCore/BusinessCard.swift)）：没有「分组」（现只有 `tags`）、没有收藏字段、没有置信度/待核对标记；「存入通讯录」当前只有 vCard 分享 ([DetailView.swift#L190-L198](file:///Users/admin/Desktop/BizScan/BizScan/Views/DetailView.swift#L190-L198))，没有写系统通讯录。

## 五、开工前需要你定的两件事

- **详情顶栏**：设计是蓝色 `#176FD1`，主页是纯深色，这是刻意的品牌色还是设计不一致？要照稿做蓝顶栏，还是统一深色？
- **分组 vs 标签**：设计里的「分组 / 未分组 / 分组管理」是直接复用现有 `tags`，还是新增独立的分组模型（一张名片只属一个分组）？

告诉我这两点（以及先做主页还是先做详情），我就按稿开始改。

---

**User**

完全和新稿相同。此外，做好计划，特别是有功能差异

**Assistant**

The user wants: implement UI exactly matching new design, and make a plan, especially covering functional differences.

I should perhaps use plan mode? They said "做好计划" — make a plan. I'm in Default mode. I could produce a plan document. Given project uses openspec maybe. But "做好计划，特别是有功能差异" — they want a plan covering functional gaps.

Let me first explore the codebase more thoroughly to plan accurately: HomeView, DetailView, RootView, SearchView, ReviewView, models, repository, project structure, tests, artifacts conventions, README. Then produce a plan. Should I write plan to a file? The repo has .trae/documents plans. There's an existing convention: .trae/documents/*.md plans. Also openspec. Creating a plan doc might be appropriate given "做好计划". But instructions say don't create files unless necessary... A plan deliverable is what they asked for, so writing docs/... maybe.

Given significant task, I think I should:
1. Explore code (parallel reads).
2. Ask the 2 pending questions? They said "完全和新稿相同" — that resolves: blue top bar as designed, and grouping as designed (but data model question remains). Hmm "完全和新稿相同" means follow design exactly. So blue top bar; grouping — design shows 分组行 + 分组管理. Functional model decision still needed: reuse tags or new group field. I could decide: add `group` field? Design "分组管理" page isn't designed. Simpler: reuse tags as groups? But design shows one group per card ("未分组"). Existing tags are multi. I need to decide, maybe ask.

Let me explore first, then decide, possibly ask 1-2 targeted questions via AskUserQuestion, then write plan.

Let me read key files: RootView, AppCopy, SearchView, ReviewView, BusinessCardEntity, repositories, project.yml, README relevant sections, docs conventions, tests for UI identifiers.

Use parallel reads.

Need: ReviewView (for confidence flag "待核对" - does parsing diagnostics store low-confidence?), settings/contacts capability (Info.plist NSContactsUsageDescription), AppEnvironment, project.yml, and tests referencing identifiers. Also check whether app has any grouping feature in specs/openspec.

Let me check openspec specs for feature definitions related to grouping/favorites, and Info.plist.

Now check specs for card-list and card-detail to know documented behaviors that would change, and the AGENTS.md conventions for planning (openspec change required?). Let me read openspec/AGENTS.md and specs card-list/card-detail briefly. Also check UI tests identifiers to avoid breakage.

Also need to know if "待核对" can be derived: parsing diagnostics? ReviewViewModel has unresolvedLines but does card store any? No. So "待核对" needs new persisted flag(s), e.g. `needsReviewFields` or `lowConfidenceFields`.

Let me read specs and tests.

The repo mandates OpenSpec workflow: Plan → change folder with proposal/design/tasks + delta spec; validate; build.

The user wants a plan, especially functional differences. So I should produce an OpenSpec change proposal(s). But there's a constraint: "一个 change 只包含一个可命名的行为增量；超过 8 个任务时拆成两个 change". This UI redesign spans list + detail + new features (favorites, groups, contacts, review flags). That's multiple changes. Since user wants a plan, I can plan as multiple changes (0007? need next number). Let me check changes dir listing failed earlier due to `===` zsh issue. Let me list.

Also need to know docs/traceability.md and README stage board.

Plan should cover functional differences:
1. 主页新功能：
   - 内联搜索（原来 sheet SearchView）→ 搜索框直接过滤？设计只有搜索框，没有说明点击后行为。可能点击进入搜索页（现有 SearchView 但需 UI 适配）。功能差异：搜索从图标入口变成常驻搜索框。
   - 日期分组（新，按 createdAt/updatedAt）
   - 分组管理入口（新功能：分组列表/管理页，未设计）
   - 数量显示
   - FAB 居中底部（原来右下）
   - 空状态点击 FAB
2. 详情：
   - 收藏（新，持久化）
   - 查看原图（新功能：全屏查看原图）
   - 快捷操作 电话/地址/备注/编辑（电话=拨号, 地址=地图, 备注=滚动/查看备注？编辑=编辑表单）
   - 待核对标记（新：基于 OCR 不确定字段，需要持久化标记；现在 Review 有 unresolvedLines 但没有保存）
   - 分组展示（新）
   - 底部"存入通讯录"（新：Contacts 写入，需 CNContactStore 权限，Info.plist 已有 NSContactsUsageDescription）
   - 编辑入口从导航栏移到快捷按钮 + 每条电话右侧铅笔
   - 顶栏 star + ellipsis（导出/删除保留在 ellipsis）
   - 详情页原有"标签"区块在新稿中没有（改为分组行）；标签编辑保留？

Need to decide model changes:
- `groupName: String?` (single group, default nil = 未分组)
- `isFavorite: Bool`
- `needsReview: Bool` or `unverifiedFields: [String]`? Design shows per-phone "待核对" tag. Simplest: `unverifiedFields: [String]` storing field keys like "mobiles[0]"? Better: `needsReviewFields: [String]` with field labels. Or a flag per value is complex. Suggest `reviewFlags: [String]` where entries are field identifiers e.g. "mobile:13504119bile". Hmm.

Better design: store `unverifiedValues: [String]`? Since OCR low confidence not tracked currently, we can generate at Review time from `unresolvedLines`/confidence. Need to check ParsingDiagnostics and OCR confidence to see feasibility.

Also migration: SwiftData schema change. Need default values + migration plan (lightweight). Since 0016 persistence hardening archived. Adding optional/default properties is lightweight migration OK.

Contact write: CNContactStore requires NSContactsUsageDescription (present). Implement ContactsExporter service with authorization request, map fields, save via CNSaveRequest, dedupe? Plan.

"完全和新稿相同" — visual parity. Need design tokens and components: Theme file (colors, typography), reusable components (CardThumbnail, SectionContainer, QuickActionButton, TagChip, etc.).

Also tests: existing UI tests use accessibility identifiers (BizScan.Home.CardList, BizScan.Home.Scan, BizScan.Home.EmptyScan, BizScan.Home.Search). Removing SearchView entry may break tests. Need update tests per spec. But AGENTS says don't change tests to make them pass; here behavior changes, so specs must be updated (MODIFIED requirements).

I should check UI tests and traceability for identifiers, plus ParsingDiagnostics/OCR confidence, and Contacts usage. Then write the plan as OpenSpec change(s)? Writing full proposal/design/tasks/spec for 3 changes is heavy but matches repo conventions. The user asked "做好计划" — they likely want a plan document to review, not implementation yet.

Given the repo requires OpenSpec, best: create openspec change(s) with proposal/design/tasks and validate. But that's a lot of files. Could produce a single plan doc in .trae/documents? The user said "做好计划" — plan first. I think following repo's OpenSpec workflow is right: propose changes. But maybe simpler: present the plan in chat, and ask whether to materialize as OpenSpec changes. However the user has been pushing "继续" and wants progress.

Given constraints ("一个 change 只包含一个可命名的行为增量；超过 8 个任务时拆成两个 change"), I'd plan 3 changes:
- 0017-card-list-redesign (主页 UI + 日期分组 + 常驻搜索 + 分组管理入口)
- 0018-card-detail-redesign (详情 UI + 收藏 + 查看原图 + 快捷操作 + 存入通讯录 + 待核对)
- 0019-card-grouping? Hmm grouping is needed by both list and detail. Could be its own change first (data model + group management), then UI changes.

Ordering: 
- 0017 grouping & favorites model foundation? Actually grouping UI is required for 主页 "分组管理" — but no design for it. "完全和新稿相同" only covers two screens. Group management page not designed. So scope: implement 分组数据与列表筛选 + 分组管理入口（占位/最小实现）? Need ask.

Maybe split:
1. 0017 `ui-foundation-theme` — design tokens + shared components (no behavior change; skip_specs true). But each change needs meaningful behavior increment; theme alone is fine as implementation-only change with skip_specs.
2. 0018 `card-groups-and-favorites` — model: groupName, isFavorite, review flags? Behavior: 分组管理、收藏.
3. 0019 `home-redesign` — UI + date grouping + inline search.
4. 0020 `detail-redesign` — UI + 查看原图 + 快捷操作 + 存入通讯录.

That's 4 changes; heavy. A plan can propose this sequencing. But the user may want a single implementation. Hmm.

They said "做好计划，特别是有功能差异" — deliver a plan that clearly separates visual parity from functional additions. I'll produce plan in chat with tables, plus ask about ambiguous functional decisions (group model, 分组管理 page, 存入通讯录 target, 待核对 source, 搜索行为). Actually they already said "完全和新稿相同" which answers visual. Functional differences are precisely what needs decisions.

Before planning, verify feasibility details:
- UI tests identifiers list
- ParsingDiagnostics / OCR confidence
- Contacts availability
- README stage board & change numbering
- docs/traceability

Let me read those quickly.

Check ScanResult shape (does it carry diagnostics/confidence?) and ReviewViewModel save path to know where to derive "待核对".

Also check docs/traceability.md for T-scenarios, README stage board, and existing change numbering (archive names 0001-0016 → next 0017).

Let me read ScanResult/ScanPipeline and ReviewViewModel.

Error: {"code":4028,"message":"WebSocket error: Network IO error: Backend error: code=-100, message=network request failed: system exception (code: -100), request_id=req_87d43e09-58ba-43cf-9f43-49f261f66c54 (HTTP Status: 500)"}

---

**User**

继续

**Assistant**

The user says "继续" — continue with the plan. I should now produce the plan. Given repo conventions (OpenSpec), I should create the change(s) with proposal/design/tasks. But that's a lot. The user asked "做好计划，特别是有功能差异" — a plan. Best: write plan as OpenSpec change(s). But how many? Constraint: one change = one named behavior increment; >8 tasks split into two.

Let me decide scope splits:

Change 0017: `0017-ui-shell-redesign` — 视觉体系 + 主页/详情视觉重做? That's too big (>8 tasks) and includes multiple behaviors.

Better split by behavior:
- 0017 `0017-card-grouping` — 分组模型 + 分组管理 + 主页分组筛选 + 详情展示分组。Functional. ~8 tasks.
- 0018 `0018-home-redesign` — 主页 UI 完全按稿：深色主题、标题、内联搜索（替换 sheet）、日期分组、FAB。Behavior changes: search entry changed from icon to inline field; list grouping; empty state copy; + button.
- 0019 `0019-detail-redesign` — 详情 UI: 蓝顶栏、头像/核心资料、快捷操作、查看原图、待核对、收藏、存入通讯录、编辑入口变更。That's >8 tasks — split:
  - 0019 `0019-detail-redesign` (visual + quick actions + view original + favorite)
  - 0020 `0020-save-to-contacts` (系统通讯录写入)
  - 0021 `0021-review-flag` (待核对标记 from OCR/parsing confidence)

Hmm that's 5 changes. Maybe too fragmented but aligns with repo discipline. However user wants a plan, not necessarily to over-split. Also "特别是有功能差异" suggests they want the functional delta explicit.

I should ask about key functional decisions before finalizing plan, because they materially change scope:
1. 分组：新增独立 group 字段（一卡一组）vs 复用 tags？
2. 分组管理入口：这次要实现完整分组管理页（新建/重命名/删除/移动），还是先只展示入口 + 分组筛选？
3. 「待核对」：基于 OCR 低置信度自动标记，还是仅保留未识别行提示，不做持久化标记？
4. 「存入通讯录」：直接写系统通讯录（需权限）还是继续用分享 vCard？

These are real decisions. The user said "完全和新稿相同" — meaning visual parity, but functionality like 存入通讯录 is on the design so must implement. I can decide sensible defaults and state them, but AskUserQuestion is designed for this. Given they want a plan and these decisions change scope substantially, I'll ask 3-4 questions first.

But the user said "继续" twice implying they want action, not more questions. Hmm. They already answered "完全和新稿相同" to my two questions? They said "完全和新稿相同" which answers: blue top bar yes; grouping as designed... but doesn't resolve implementation model.

I think best: use AskUserQuestion with 3 concise questions (group model, contacts write, review flag), then produce plan. That's efficient and avoids building wrong thing. But maybe user expects plan now. I can produce plan with recommended defaults clearly marked and ask for confirmation at the end. The instructions: "AskUserQuestion ... use proactively when decision changes what you do next". These do.

Let me ask 3 questions:
1. 分组实现: 新增独立"分组"字段（推荐，一卡一组，符合设计"未分组"）/ 复用现有 tags / 先只做入口占位
2. 存入通讯录: 直接写系统通讯录（推荐）/ 仅导出 vCard 分享
3. 待核对: 按 OCR 置信度自动标记并持久化（推荐）/ 只在识别未解析行时标记 / 不做
4. 实施顺序: 分组→主页→详情 / 主页优先...

Max 4 questions. Let me ask these. But wait — maybe the user will be annoyed. Yet these are crucial. I'll ask 3, keep plan ready afterward.

Actually, I can produce the plan first (so they see it), and include decisions as open items. But the plan's task list depends on answers. Better ask then plan.

Hmm, the user's flow: "做好计划" = make the plan. They likely expect me to write the plan file. I'll ask decisions, then write. Let me ask.

I'll ask 4 questions:
Q1 分组模型
Q2 分组管理范围
Q3 存入通讯录
Q4 待核对来源

Then produce full plan (likely a markdown plan doc under .trae/documents or openspec changes). Let's ask.

Now produce the plan. Repo requires OpenSpec change folders. The user asked "做好计划，特别是有功能差异". I'll create the plan as OpenSpec changes? That would be 4 changes with proposal/design/tasks/specs — heavy but the repo mandates it. The user wants a plan first (Plan phase). I think creating 4 change folders is the correct "plan" deliverable, but maybe too much. Alternatively create one plan document in `.trae/documents/UI改造计划.md` that maps to the 4 changes, then create the first change when approved.

Given repo's AGENTS.md: Plan phase = write proposal/design/tasks + incremental specs under openspec/changes/<id>/. Human approves change. So providing a plan doc outside that workflow violates conventions. But writing 4 full changes before approval is also unusual — normally you propose one change at a time.

The user explicitly: "完全和新稿相同。此外，做好计划，特别是有功能差异". So deliver a plan. I'll create a plan document that covers all four increments with functional differences, and also materialize the first change (0017) proposal? Hmm.

Let me check next change number: archive has up to 0016. So 0017 onwards.

Decision: Write a single plan doc under `docs/`? Repo has docs/ for verification/reference. Plans live in openspec/changes or .trae/documents. Existing `.trae/documents/P7剩余项收尾计划.md` — so `.trae/documents` is used for plans. I'll write `.trae/documents/UI改版计划.md` with:
- 目标与设计源（node ids, 截图路径）
- 视觉基线 tokens 表
- 4 个 change 的拆分、范围、功能差异矩阵（新增/变更/移除/不变）
- 每个 change 的文件级改动清单、任务、验收场景（T 编号）
- 数据模型与迁移
- 风险与待确认
- 验证方式

Also include exact design measurements per screen so implementation can be 1:1.

Then ask user to approve; then create OpenSpec change 0017 and implement.

But user said "继续" and likely wants progress toward implementation. Creating the plan doc is the requested step. Let me create it thoroughly but not excessively long. Should I also write the proposal/design/tasks for 0017? The plan can serve as the proposal basis; but repo requires openspec validate. I could create the plan doc now and offer to open 0017.

Hmm, "做好计划" plus repo discipline → I'll create the plan document AND the first OpenSpec change (0017) fully, since implementation will start there. That's substantial. But AGENTS.md says human approves change before Build; creating the change is Plan phase, allowed.

Actually, creating 4 changes is overkill and would require careful spec deltas. I'll create the plan doc with the four increments and their requirement/scenario drafts; then create 0017 change folder only when they say go. Wait — but then "继续" stalls again.

Alternative: create plan doc + immediately materialize 0017 (grouping) proposal/design/tasks/spec, validate with openspec CLI, then stop for approval. That's a good deliverable.

Check if openspec CLI is installed. Let's test `openspec --version`. Also check .openspec.yaml format in archived change.

Let me look at an archived change structure to copy format.

Now write the plan. I'll create `.trae/documents/UI改版计划.md` (plan doc) with detailed scope, functional delta matrix, 4 increments, file-level tasks, design tokens, scenarios, risks.

Should I also create openspec change 0017 now? The user asked plan; creating the plan doc fulfills. But repo's workflow expects change proposal. The plan doc can be the umbrella. To keep momentum, I'll create the plan doc and the first change (0017) skeleton? That risks overproducing. I'd rather create the plan doc, present summary, and ask if they want me to open 0017 and start.

But user has said "继续" repeatedly; they may want implementation after plan. However the request explicitly is "做好计划" — plan only.

Let me write the plan doc now. Content must be accurate to codebase.

Plan structure:

# 名片 UI 改版实施计划
- 设计来源与已锁定决策
- 视觉基线（tokens + 两屏规格）
- 功能差异总表（表格：模块 / 新稿 / 现状 / 差异类型 / 归属 change）
- 增量拆分 0017-0020（每个：目标、范围、任务清单、验收场景、影响文件、验证）
- 数据模型与迁移
- 测试与证据
- 风险与未决
- 实施顺序与里程碑（no time estimates）

Details:

### 0017 card-grouping（分组）
Data model: BusinessCard.group: String? (nil = 未分组); entity groupName: String?; GroupEntity? Use TagEntity-like? To support empty groups + rename, add `CardGroupEntity(name)`. But simpler: group stored as String? on card, and group list derived + TagEntity-like table. 分组管理 needs create/rename/delete/move. Implement:
- `CardGroupEntity` (unique name)
- `BusinessCard.group: String?`
- repository: `allGroups()`, `createGroup`, `renameGroup`, `deleteGroup`, `move(card:toGroup:)`
- UI: GroupManagementView (not designed → follow same visual language; minimal: list groups with counts, add/rename/delete, tap to view group cards), Home 分组行 shows 全部名片 + count and 分组管理 entry; tag chips removed? The design shows only "全部名片" + 分组管理. So tag bar removed. But T16 tag filter scenario exists — spec change: keep tags in model/edit, but list filter replaced by group filter. Need MODIFIED requirement for search-tags (T16) — this is a functional regression. Must document: T16 changes to group filtering. Important to flag.
- Detail shows group row.

Scenarios: T21 分组创建与筛选, T22 分组重命名/删除, T23 详情显示未分组/分组.

### 0018 home-redesign
Visual parity + date grouping + inline search + FAB + + button.
Functional differences:
- Search: inline search field on home filters list live (design doesn't show a search page). But existing SearchView/spec T15. Decision: inline field navigates to search page on tap? "完全和新稿相同" design only shows field. Two options; I'll choose: 点击搜索框进入搜索页（保留 SearchView，改为同风格深色），主页本身只做入口，避免重复实现搜索逻辑; or live filter in place. Hmm. Which is more faithful? The design's search field is a control, not a results container. Typical apps: tapping navigates to search screen. Since no search screen design, minimal change = keep SearchView but restyle. I'll propose: 点击搜索框 push 搜索页（复用 SearchViewModel，深色化），主页不内联出结果。Flag as assumption.
- Date grouping: group by createdAt with header yyyy-MM-dd; sorting currently by updatedAt desc. Design shows date header = createdAt. Change sort to createdAt desc? Design group "2026-10-26". Spec says relative update time. Need MODIFIED card-list requirement (列表展示按创建日期分组). Keep sort by updatedAt? If sorted by updatedAt but grouped by createdAt, groups may interleave. So sort by createdAt desc. Functional change: 列表顺序变成创建时间倒序（原为更新时间倒序）。Flag.
- + button: design has + in header. What does it do? Not specified. Likely 手动新建名片 or 更多录入方式. Existing scanner has 相册导入. Decide: + 打开扫描页的 "拍摄/从相册导入" 选择（现有 ScannerView 内含相册？）. Check ScannerView quickly for import action. Need to know. If ScannerView has import, + opens ScannerView same as FAB? That duplicates. Maybe + = 手动新建。Hmm. I'll flag as undecided, recommend + 打开与 FAB 相同的扫描页 but semantically "新增" with 相册导入选项. Let me check ScannerView.
- 数量 badge, 分组管理入口.
- 空状态: icon + copy, no button (FAB only).
- Delete gesture: design shows ellipsis per row → action sheet 删除/收藏? Design list has "..." not swipe. Functional: move delete into row menu. Spec T17 expects delete from list; keep swipe + menu.
- Search entry identifier changes → UI tests update (behavior change, spec updated).

### 0019 detail-redesign
- Blue nav bar (#176FD1) with back/star/ellipsis. Full custom nav (hide system bar) to get exact colors & 56pt height.
- Core card: avatar initial, name, title, company, view original (full-screen image viewer).
- Quick actions: 电话 (tel), 地址 (maps), 备注 (scroll to notes? or open notes display), 编辑 (edit sheet). Functional: 备注 quick action maybe shows notes; if empty, disabled.
- 收藏: new `isFavorite` field; star toggles; 收藏列表入口? Design only shows star. Home doesn't show favorites. So favorite has no downstream surface → maybe just persisted state. Flag: 收藏若无列表入口则价值低；建议主页分组行将来加「收藏」筛选，但本次按稿不做。
- 待核对: new `unverifiedFieldValues: [String]` or `reviewFlags`. Derive at save from OCR confidence (<0.7 ?) and invalid format (e.g. phone "13504119bile"). Show orange chip on matching value. Editing value clears flag.
- Contact rows: field name + type chip + value + hint + edit pencil. Multiple phones/emails.
- Bottom pinned "存入通讯录" (change 0020).
- Existing: 标签区块/分享/删除 in ellipsis.
- Layout: sections with 8pt gaps, dividers inset 24.
- Data: favorite, group, review flags.

### 0020 save-to-contacts
- ContactsService with CNContactStore authorization, map fields, dedupe by name+phone, result feedback (已存入/已存在/权限拒绝), Info.plist already has usage description.
- Tests: unit-test mapping; UI test permission can't be automated easily → manual checklist.
- Scenario T26.

### 0021? 待核对 maybe belongs to 0019 or its own change. Repo says one behavior per change; 0019 already has favorites + view original + quick actions + review flags. Too big (>8 tasks). Split:
- 0019 detail-redesign (visual, nav, core card, quick actions, contact rows, edit entry, ellipsis menu, 查看原图)
- 0020 review-flags (待核对 data + UI)
- 0021 save-to-contacts

Ordering per user: 分组→主页→详情→通讯录. 待核对 with 详情 (as part of detail). But >8 tasks. I can define 0019 tasks ~10 and split review flags into 0020 before contacts. The user's chosen order says 详情→通讯录; review flags can be inside 详情 increment as a sub-behavior but repo discipline... I'll put 待核对 as its own change 0020, then 通讯录 0021, and explain that 0020 is a prerequisite of 0019's final visual state — better to do flags before detail visuals? Actually visual chip needs data. Order: 0017 分组 → 0018 主页 → 0019 待核对数据 → 0020 详情视觉 → 0021 通讯录. But user chose 分组→主页→详情→通讯录; 待核对 sits inside detail. I can fold review flags into 0019 if tasks ≤ 10? Guidelines say >8 split. Hmm.

I'll define 4 changes: 0017 分组, 0018 主页, 0019 详情（含待核对标记）, 0020 通讯录. And note 0019 has 12 tasks → split into 0019a/0019b? Rather keep 0019 detail visual and 0020 review-flag, 0021 contacts. Present as "4 个增量 + 1 个可选" hmm.

Let me count detail tasks:
1. Theme tokens + shared components
2. Custom blue nav bar + star + ellipsis
3. Core identity card (avatar/name/title/company/view original)
4. View original full-screen viewer
5. Quick actions (tel/maps/notes/edit)
6. Group row
7. Notes section
8. Contact rows with type chips/hints/edit
9. Bottom pinned save-to-contacts (placeholder action)
10. Favorite persistence + tests
11. Review flag data + chip
12. UI tests + docs

That's >8 → split:
- 0019 detail-redesign (1-9, 12) but 9 depends on 0021 → button wired later; placeholder no.
Better:
- 0019 `0019-card-detail-redesign` — visual restructure + quick actions + view original + favorite + group row + contact rows; 存入通讯录按钮本期触发 vCard 分享占位? That violates "完全和新稿相同"? Visual same, behavior temporary. Hmm.

Cleaner split:
- 0019 `0019-detail-redesign` (visual + nav + core card + view original + quick actions + group/notes/contact rows + edit + favorite) — 8 tasks
- 0020 `0020-review-flags` (待核对)
- 0021 `0021-save-to-contacts`
Ordering: 0017 → 0018 → 0019 → 0020 → 0021. Fits "分组→主页→详情→通讯录" with review flags between detail and contacts.

Favorites: is it in scope? Design star. Add `isFavorite` + toggle. No list surface. Include in 0019.

Home "+" button: check ScannerView to decide. Let me grep quickly.

Also need date grouping with createdAt; check HomeViewModel tests.

Let me check ScannerView for import entry and any "add" affordance.

Good. ScannerView has import.

Now write the plan doc. Include precise visual spec tables per screen (with measurements), functional delta matrix, change breakdown with tasks and files, data model/migration, test/verify plan, risks.

Where to save? `.trae/documents/` matches existing plan docs. Name: `名片UI改版计划.md`. Since deliverable is a doc, use Write.

I need to be careful: plan must be accurate and actionable. Let me draft.

Also maybe include screenshots copied into workspace? The renders are in /tmp. Deliverable doc could reference Figma links. Maybe copy the three PNGs into `docs/design/`? That creates files; useful for implementation. Hmm, "NEVER create files unless necessary". A plan referencing Figma node IDs is enough. But local screenshots help later and for verification. I'll skip images to avoid clutter, or include in plan? Keep minimal: no images.

But plan doc is a file creation; justified by request "做好计划".

Let me write content.

Key measurement tables:

主题 tokens:
- bg.page #191919 (主页) / #171819 (详情底座)
- surface #202123
- surfaceElevated #252525
- control #2B2B2B
- divider.strong #333538 / divider.weak #2B2B2B
- text.primary #F1F1F1 / detail #F5F6F7
- text.secondary #A0A0A0 / #B5B8BD
- text.tertiary #777777 / #858A91
- accent.blue #3478F6 (FAB), nav #176FD1
- accent.green #42AD73 / #75D49A
- accent.amber #E7AB52 / bg #3B3021
- accent.purple #9A7BDB
- corner: 12,13,7,6,100
- fonts: Noto Sans SC (title/body), Inter (numbers/English). SwiftUI: PingFang SC fallback? Design uses Noto Sans SC; system Chinese font = PingFang SC. Need decide: bundle Noto Sans SC? Adding font assets is heavy. Recommend using system font `.system` with weights and note metric differences; or bundle Noto Sans SC if exact. "完全和新稿相同" → font parity. Should ask? I can state: 字体使用 Noto Sans SC（设计稿），需确认是否引入字体文件；若不引入则用 PingFang SC，字形略有差异。Flag as open decision. Since repo forbids third-party deps but fonts are assets; licensing OFL. I'll flag.

Actually SwiftUI on iOS uses PingFang SC for Chinese; Noto Sans SC not present. To be 1:1, bundle NotoSansSC-Regular/Medium/Bold (OFL). That's an asset addition. Mention as risk/decision.

Screen spec tables: I'll include detailed rows already extracted. Keep readable.

Functional delta matrix:

主页:
| 项 | 新稿 | 现状 | 类型 |
- 标题 名片 vs 名片夹 → 文案变更
- 顶部 + → 新增入口（打开 Scanner 的导入/拍摄选择? decide: + 打开 ScannerView，与 FAB 相同；或 + 直接相册导入）Recommend: + 与 FAB 同入口（ScannerView 内已有拍摄/相册切换），保持单一扫描流程。
- 搜索框常驻 → 由导航栏图标 sheet 改为点击搜索框 push 搜索页（深色化）；新增占位文案
- 分组/数量/分组管理 → 全新
- 标签筛选条 → 移除（T16 行为变化）
- 按日期分组 → 新增
- 列表行：缩略图 64x40→98x64、姓名 19/副标题两行、右侧 ... 菜单
- 删除：滑动删除 + ... 菜单
- FAB：右下 56 → 底部居中 68
- 空状态：加按钮 → 仅图标+文案，靠 FAB
- 列表排序：updatedAt desc → createdAt desc（分组一致）
- 单元格点击 → 详情（不变）

详情:
| 顶栏 | 蓝色自定义 | 系统导航栏 | 视觉+自定义返回
| 收藏 | 新增 isFavorite
| 更多 | ellipsis 菜单保留导出/删除
| 原图 | 顶部大图 → 右上小入口 + 全屏查看
| 头像 | 新增 姓氏首字圆形
| 快捷操作 | 新增 4 个
| 分组 | 新增
| 备注 | 新增独立区块（原字段行）
| 联系方式 | 新布局 + 类型标签 + 待核对 + 行内编辑
| 标签区块 | 移除（分组替代；编辑页保留标签? 设计无标签编辑 → 建议编辑页移除 tags? but data model keeps tags）
| 存入通讯录 | 新增系统写入（原仅 vCard 分享）
| 底部固定按钮 | 新增
| 编辑入口 | 导航栏文字 → 快捷圆形按钮 + 字段铅笔
| 原图 | 详情页展示原图 → 查看原图

搜索页: 深色化适配（未出新稿，沿用视觉令牌）

分组管理页: 无设计稿，需要自绘（列表、添加、重命名、删除、移入分组），采用同一令牌。

Data model changes:
- BusinessCard.group: String? (nil=未分组)
- isFavorite: Bool = false
- unverifiedFields: [String] (field key + value? better `reviewFlags: [ReviewFlag]` with field: FieldKind, value: String). Simpler codable struct `UnverifiedValue { field: String; value: String }`? For SwiftData arrays of structs need Codable transformable; currently tags [String] works. Use `unverifiedValues: [String]` storing raw value strings; detail checks membership by value. Simpler but ambiguous duplicates. Recommend `unverifiedFieldKeys: [String]` with keys like "mobile.0"? Reindexing after edit breaks. Best: store `[String]` of exact values; on edit, remove flags for values no longer present. Good enough and simple. I'll specify `unverifiedValues: [String]`.
- Entity adds groupName, isFavorite, unverifiedValues with defaults for lightweight migration.
- Repository API additions: fetchGroups, fetchCards(group:), setGroup, setFavorite, updateUnverified; TagEntity unchanged.
- Group table: reuse TagEntity? No — create `CardGroupEntity` with unique name; default groups derived. Migration adds entity.

Actually to minimize scope: store group as String? on card, and group list = union of distinct card groups + CardGroupEntity for empty groups. Do we need empty group support? 分组管理 typically yes. Keep CardGroupEntity.

Verification: scripts/verify.sh --change. Each change produce docs/verify/<id>.md. UI tests: add home/detail visual identifiers; keep existing identifiers where possible to reduce churn (BizScan.Home.Scan on FAB, BizScan.Home.CardList on ScrollView/List). Search entry: keep `BizScan.Home.Search` on the inline search button → existing tests still pass if tapping opens search page. Nice: preserve identifier to keep T15/T16 tests; T16 tag filter UI removed though → test must change. Flag.

T16 impact: existing UI test `testT16TagFilterShowsOnlyTaggedCards` taps tags on home. New design removes tag filter → T16 needs spec change to "按分组筛选". That's a behavior contract change requiring MODIFIED requirement in 0017. Good to highlight.

Also spec card-list says list shows relative update time — new design shows date headers only. MODIFIED.

Verification commands: make/open xcodegen? scripts/verify.sh.

Risks:
- 字体 Noto Sans SC not bundled → 1:1 mismatch; decide bundle (OFL) or use PingFang.
- 状态栏/安全区：设计用 390x844/900，实际设备需 safe area；蓝色顶栏需延伸状态栏。
- 详情 390x900 高于 844 → 内容滚动 + 固定底栏（SafeAreaInset）。
- SwiftData migration: add properties with defaults; test reopen 0016 style.
- 分组/收藏/待核对增加模型字段 → vCard 导出不受影响.
- 收藏无入口 → 建议主页分组行增加「收藏」入口? Not in design → out of scope, note.
- 存入通讯录权限拒绝流程 → 提示 + 设置跳转.
- 重复联系人 → 去重策略（同名+号码）需定义.
- 待核对置信度阈值 → 0.7? Need define: OCR observation confidence < 0.7 或 解析 reason ∈ {ambiguous, invalidFormat} 的电话/邮箱/地址 → 标记。Detail: 仅电话字段显示（设计如此）。

Milestones: M1 0017, M2 0018, M3 0019, M4 0020, M5 0021.

Each change's tasks list with checkboxes and file paths.

Also "不在范围": 深色/浅色双主题（设计仅深色，需锁定为仅深色？现状跟随系统。功能差异：强制深色 or 支持浅色无设计。Recommend: 仅深色外观（preferredColorScheme(.dark)），未出浅色稿。Flag.)

That's an important functional difference. Add to decisions/risks.

Now write the doc. Keep it organized but not insanely long. Maybe ~250 lines.

Use Chinese. Then summarize in chat with key functional deltas and next step.

Let me write.

计划已写好：[名片UI改版计划.md](file:///Users/admin/Desktop/BizScan/.trae/documents/名片UI改版计划.md)

核心结论：

**1. 视觉 1:1 有把握**
三张画板的关键尺寸、圆角、字号、间距、色值都已提取成 Design Tokens，可直接照做。唯一硬缺口是字体：设计用 Noto Sans SC，iOS 没内置，建议打包字体（OFL 许可）而不是退回苹方，否则字重和行高会有肉眼可见差异。

**2. 功能差异是真正的工作量**

| 屏幕 | 新增/变更的功能 |
|---|---|
| 主页 | 常驻搜索框（替换导航栏图标）、**按创建日期分组**、分组行 + 数量、分组管理页、顶部 `+`、`…` 行菜单、底部居中 FAB、**仅深色外观** |
| 详情 | 蓝色自定义顶栏、收藏星标、姓氏头像、查看原图（全屏）、4 个快捷操作（拨号/地图/备注定位/编辑）、待核对标签、分组行、行内编辑、**固定底部「存入通讯录」** |
| 全局 | 标签筛选被分组筛选替代（T16 行为变更）、列表排序从 `updatedAt` 改为 `createdAt` |

**3. 拆成 5 个 OpenSpec change，按依赖串行**

```
0017 分组模型与筛选 → 0018 主页 1:1 → 0019 详情 1:1 → 0020 待核对 → 0021 存入通讯录
```

- **0017**：`group` + `isFavorite` 字段、`CardGroupEntity`、分组 CRUD、主页/详情分组展示（8 任务）
- **0018**：主题令牌 + 主页全部视觉与日期分组（8 任务）
- **0019**：自定义顶栏、核心卡、原图查看、快捷操作（8 任务）
- **0020**：按 OCR/解析置信度落「待核对」值（6 任务）
- **0021**：`ContactsService` 写系统通讯录、去重、权限引导（6 任务）

**4. 需要你拍板的只剩三点**（计划第 6 节 R1/R3/R4）

- 字体：打包 Noto Sans SC，还是用苹方？
- 主页 `+`：与 FAB 同入口（拍摄/相册），还是要「手动新建」？
- 标签：保留编辑能力但界面不展示（我的默认），还是彻底下线？

确认后我就开 `0017-card-grouping` 的 proposal/design/tasks，通过 `openspec validate --strict` 后开始写代码。

---

**User**

字体用苹方，主页 + 号改为手动新建，标签保留编辑能力但界面不展示

**Assistant**

User decisions:
- Font: PingFang SC (system)
- Home "+": manual new card creation
- Tags: keep editing but not displayed

Now proceed: create 0017 change proposal/design/tasks/specs, validate, then implement? User said earlier "确认后我就开 0017..." and now they confirmed. They didn't explicitly say "start coding" but the flow implies. The repo workflow: Plan (write change) → Check (validate) → Build. Human approves change before build? AGENTS says "人类：定义意图、批准 change". So after writing the change, I should notify for approval before Build.

But they've effectively approved the direction. Still, repo discipline: create change, validate, then notify user (NotifyUser?) — NotifyUser is for plan mode/spec mode/web-dev PRD. In default mode, could just present. Hmm.

The user's message only answers the three questions. Probably expects me to proceed with the plan changes and first change. I should update the plan doc with the decisions (R1/R3/R4 resolved), then create openspec change 0017 files, validate.

Given "home + = 手动新建", this adds a new functional requirement: manual card creation flow (blank form) — needs design? No design. Implement `EditCardView`-like NewCardView. That expands 0018 scope (or its own change?). It's a functional behavior increment → could be part of 0018 or separate change 0018a. Repo says one change = one behavior increment. 0018 already has visual + date grouping + search + FAB. Adding manual create pushes >8 tasks. So better separate change:

- 0018 `0018-manual-card-create`? But order: after grouping? It uses group? Manual create should create empty card with image? BusinessCard requires originalImagePath (non-optional). Manual creation without image breaks model contract ("originalImagePath"). Need design decision: allow cards without original image → model change (optional image path) affecting vCard, list thumbnail placeholder, persistence tests. That's significant!

Hmm. Manual new card: user taps +, fills form, saves a card with no image. Current `BusinessCard.originalImagePath: String` non-optional, and `displayTitle` etc. List thumbnail fallback exists (placeholder). Detail "查看原图" would need hiding. `imageStore.delete` etc.

This is a real functional difference. Options:
a) 手动新建也要求拍/选一张图（不合理）
b) 允许无原图名片：`originalImagePath: String?` — modifies core model契约, many tests/fixtures, vCard unaffected. Also `isEmpty` etc.

I need to plan this carefully. Maybe user means "+" opens manual create form. Yes.

So plan should add:
- 0018 `0018-manual-card-create`: model allow no image, new card form (reuse EditCardView), entry, tests. Could be after grouping (needs group selection).
- 0019 home redesign (visual, uses + and list)
- 0020 detail redesign
- 0021 review flags
- 0022 contacts

That's 6 changes. Sequential.

But is a separate create change necessary? It's a distinct behavior, yes. And 0018 home redesign should come after create so + is wired. Order: 0017 分组 → 0018 手动新建 → 0019 主页 → 0020 详情 → 0021 待核对 → 0022 通讯录.

Alternatively manual create could be part of 0017? No.

I should update the plan doc accordingly, then create 0017 change. Do I need to ask about manual create details? Key question: allow image-less cards (model change). I can decide: yes, make `originalImagePath: String?` with migration; list shows placeholder; detail hides 查看原图. That's the sensible interpretation. Document it in plan and in 0018 design. No need to ask; it's the only coherent option.

Wait — maybe "手动新建" could still allow attaching image later. Keep simple: image optional.

Now, should I actually create 0017 files and validate? Yes, that's the next concrete step. But per repo, plan phase prohibits code changes; creating change files is fine.

Let me check openspec CLI usage for new change. `openspec new change <id>` might scaffold. Let's run help. Also check config.yaml and spec delta format from archive 0016 specs.

Let me read the archive delta spec and tasks to copy format.

Now update plan doc with decisions and the new manual-create change. Then create 0017 change files.

First update plan:
- R1 resolved: PingFang SC (system font) — adjust visual baseline fonts row.
- R3 resolved: + = 手动新建 → add new increment.
- R4 resolved: tags keep editing but hidden.

Add `0018-manual-card-create`: model image optional? Let me think about the exact scope:
- BusinessCard.originalImagePath: String? (was String). Entity: String? — migration. Many places assume non-optional: repository.delete (imageStore.delete(relativePath: entity.originalImagePath)), ReviewViewModel sets it, DetailViewModel, CardRow thumbnail, tests/fixtures.
- Alternative: keep String and use empty string "" for manual cards. Existing code uses `originalImagePath: ""` in ReviewViewModel init before saving. `imageStore.image(forRelativePath: "")` likely nil. display works. vCard unaffected. Detail `image()` returns nil. So no model change needed! But invariant "image path non-empty" is violated; repository.delete would call imageStore.delete("") — need guard. This is a hack but minimal. Better to make it optional for correctness, but that's a broad signature change touching many files/tests.

Plan decision: keep `originalImagePath: String?`? Let me check usages count.

grep originalImagePath.

Making it optional touches ~15 files (tests use non-optional init). Could keep `String` with `""` sentinel and document invariant change; but card-model spec says required non-empty. Manual create contradicts spec → needs MODIFIED requirement. Cleaner: make `originalImagePath: String?`. It's a breaking public API change but the repo is small; tests can pass nil via label with `String?`. Existing calls with string literals still compile (String? accepts String). So changing `var originalImagePath: String` → `String?` and init param `String? ` is source-compatible for callers passing strings! Only usages doing string ops break: `entity.originalImagePath` delete guard, `ReviewViewModelTests` `XCTAssertFalse(stored.originalImagePath.isEmpty)` → needs `.isEmpty == true` handling; `imageStore.data(forRelativePath: stored.originalImagePath)`. Few. Entity property String? with default nil — SwiftData migration fine.

Good: 0018 manual create includes:
- Core model `originalImagePath: String?`
- Entity `String?`
- delete guards nil
- Detail hides 查看原图 when no image; image() returns nil
- Home thumbnail placeholder (already)
- New `NewCardView` reusing form fields, saves via repository, group selection, tags optional (hidden in UI? tags hidden in display but editable)
- + button entry
- Tests T34 手动新建名片
- Specs: MODIFIED card-model (image optional), card-list (manual create), maybe verification.

Then renumber: 0017 grouping, 0018 manual create, 0019 home redesign, 0020 detail redesign, 0021 review flags, 0022 contacts.

That's 6 changes. Fine.

Update plan doc: decisions + new change + renumbered sections + functional table row for +. Then create 0017.

Let me update the plan doc with edits (not rewrite whole). Several sections to change:
1. Header 已确认 line add decisions.
2. Font row.
3. 2.1 项 顶部「+」 description.
4. Section 3 insert 0018 manual create and renumber existing 0018→0019, 0019→0020, 0020→0021, 0021→0022.
5. Section 4 diagram.
6. Section 6 R1/R3/R4 resolved; add R10 manual create model.
7. Section 5 adjust.

Renumbering via edits is error-prone; easier to rewrite the doc fully with Write. It's a plan doc I authored; rewriting is fine.

Let me compose updated full doc. Keep same content plus changes. Also add manual create details:
- Entry: 主页标题栏 + → NewCardView（全屏 sheet）
- Fields: 姓名/公司/职位/部门/电话/邮箱/网址/地址/备注/分组/标签（标签可编辑但不在主页/详情展示）
- 无图片：originalImagePath 可空；列表显示占位图；详情隐藏「查看原图」；删除时跳过图片
- 保存校验：空卡提示（复用）
- 验收 T34

Also update 功能差异表 row for +.

Then create OpenSpec 0017 files:
- `.openspec.yaml` schema spec-driven created 2026-11-06
- proposal.md / design.md / tasks.md / specs/{card-list,card-detail,search-tags}/spec.md (deltas)

What exactly are 0017 requirement deltas?

card-list MODIFIED:
- 列表展示：按创建日期分组 + 分组筛选（原 Requirement: 名片列表展示；scenario 列表缩略信息可读 mentions 相对更新时间 → change)
- NEW Requirement: 按分组筛选名片 (T21/T22)
- 搜索入口 requirement? Home + search stays for now; 0017 only 分组行, search unchanged? The plan says 0017 主页分组行 + 筛选 replaces tag bar. In 0017 we may keep current List but swap tag chips for group row. That changes UI partially; 0019 does full visual. Fine.

card-detail ADDED: 分组展示.
search-tags MODIFIED: T16 标签筛选 → 分组筛选. Need read existing search-tags spec to write delta accurately. Also card-list spec read already. Let me read search-tags spec and card-model spec for manual create later.

Also check TagStore for tags utility.

Let me read search-tags spec.

Important conflict: card-model spec says "展示层按 updatedAt 倒序排列" and card-list spec says relative update time. New design groups by createdAt. This contradicts. Need MODIFIED requirement in 0019 (home redesign): list groups by createdAt desc; card-model update-time semantics still updates updatedAt but display order changes. That's a spec delta. Fine.

Also tags spec T16 says tag filter on home; new design removes it → MODIFIED in 0017 (filter by group). Tags still editable, but filtering by tag no longer available on home. T16 scenario changes to group filter. The "删除标签" scenario says 从筛选栏消失 — must change too. 0017 delta must cover.

Now update plan doc first. Then create 0017 with proper deltas.

Let me rewrite the plan doc fully.

Changes to plan:
- 已确认 line: add 字体苹方、+ 手动新建、标签保留编辑不展示.
- Tokens font row: 系统字体：中文 PingFang SC，数字/英文可用 SF Pro（设计 Inter）；字号/字重沿用稿.
- 2.1 + row: 手动新建名片（无原图）。
- Add 2.3 全局差异: 新增手动新建流程 / 原图可空.
- Insert 0018 manual create; renumber.
- Update dependency diagram.
- R1 resolved; R3 resolved; R4 resolved; add R10 model optional image.
- 0019 (formerly 0018) tasks mention uses new +.

Also functional table for detail mention 查看原图 only when image exists.

Let me write.

Now create 0017 change files. Use openspec new change to scaffold? Let's try `openspec new change 0017-card-grouping` — it may create proposal skeleton. Then fill.

Let me run it.

Now write proposal.md, design.md, tasks.md, specs deltas. Need to know expected spec delta headings: "## ADDED Requirements", "## MODIFIED Requirements", "## REMOVED Requirements", "## RENAMED Requirements".

For 0017:
- specs/card-list/spec.md:
  ADDED Requirement: 按分组筛选名片 (T21, T22)
  MODIFIED Requirement: 名片列表展示 (add group entry? Actually 0017 doesn't change list organization; it adds group row + filtering. The existing "搜索入口常驻" stays.)
  Maybe MODIFIED "名片列表展示" to state 分组筛选状态保持? Not needed.
- specs/card-detail/spec.md:
  ADDED Requirement: 展示名片分组 (T23)
- specs/search-tags/spec.md:
  MODIFIED Requirement: 标签管理 — now tags editable but no home filtering; add note. Scenario T16 changes: 新建标签 → 保存 → 编辑页可见；按分组筛选 → 返回. Hmm T16 is "标签管理" scenario; we should rewrite as "T16 标签仅保留编辑能力" maybe. But traceability must match. Better: MODIFIED "标签管理" with scenario "T16 添加标签并保留在编辑页" and "删除标签" no longer 筛选栏 → 编辑页消失. And ADDED "按分组筛选" in card-list (T21).

Let me write precise deltas:

card-list ADDED:
### Requirement: 按分组筛选名片
系统 SHALL 在主页展示当前分组与数量，并支持进入分组管理；分组筛选 SHALL 只显示该分组下的名片。
Scenarios:
- T21 创建分组并按分组筛选
- T22 分组删除后回到未分组
Wait T22 is rename/delete → cards return to 未分组. That's a grouping behavior; put in card-list ADDED or search-tags? card-list.

Also MODIFIED Requirement: 名片列表展示? The list currently shows 相对更新时间 requirement; changing to 日期分组 is 0019. In 0017, we replace tag chip bar with group row — the existing list requirement doesn't mention tags, so no modification. But "搜索入口常驻" unaffected.

card-detail ADDED:
### Requirement: 详情展示分组
- T23 详情展示分组名称; 未分组显示「未分组」.

search-tags MODIFIED:
### Requirement: 标签管理
系统 SHALL 支持创建标签、给名片打标签与编辑标签；主页与详情 MUST NOT 再展示标签，筛选能力由「分组」承担。
Scenarios:
- T16 添加标签并保留在编辑页 (edit page still shows tag after save/reopen)
- 删除标签 (from edit page)
- 重复标签

Need to keep scenario names consistent with traceability. Traceability T16 name is "添加标签并按标签筛选". Since behavior changes, update traceability in tasks. Delta scenario name should be `T16 添加标签并保留在编辑页`. Then docs update.

Hmm, is it wise to remove tag filtering entirely? Home tag bar removed by design. The design shows group filter only. Yes.

Design.md content:
- Context: current tags, model
- Decisions: group as nullable single string + CardGroupEntity for empty groups; filters; migration; isFavorite reserved; UI minimal for 0017 (group row in existing visual style, full restyle deferred to 0019); group management page style.
- Risks: tags vs groups semantics; existing sample data; T16 contract change; migration.

Tasks with files:
1.1 Core: BusinessCard.group/isFavorite init defaults; tests
1.2 Entity fields + CardGroupEntity + container registration in BizScanApp (ModelContainer schema includes TagEntity; add CardGroupEntity)
1.3 Repository protocol additions (check BusinessCardRepository protocol file location) — need read it.
Let me read BusinessCardRepository.swift to know protocol methods and fakes in tests. Also check InMemory repository in tests for compile impact (adding protocol methods requires test fakes updated).

Read it.

Good. Now write 0017 files.

Also decide Group semantics details:
- Trim/halfwidth normalize like tags.
- Group name uniqueness case-insensitive.
- deleteGroup: delete CardGroupEntity + set cards' groupName nil.
- renameGroup: if target exists → merge (cards move to existing) or error? Simpler: reject duplicate. Design decision: merge? I'll choose reject with error `.duplicateGroup`.
- setGroup(nil) → 未分组.
- Cards sorted by updatedAt for now (0019 changes to createdAt).
- Home group row shows count for selected group; "全部名片" count = all.
- Group management page: list "全部名片" + groups with counts; add via alert text field; swipe rename/delete. Keep minimal.

Migration: new entity + optional fields; SwiftData lightweight. Test container reopen.

isFavorite: since 0020 uses it, do we add now? 0017 scope says add to model. Adding unused property is scope creep. But plan says it. Could defer `isFavorite` to 0020. Cleaner: add only group in 0017; isFavorite in 0020. The plan states "isFavorite: Bool（本增量只落库，0020 使用）". Hmm, unused field = over-engineering. Better remove and put in 0020. Update plan doc accordingly? Minor. I'll not include isFavorite in 0017, and note in plan? Let's adjust plan after. Actually I already wrote "isFavorite（本增量只落库）". I'll change to 0020 later when updating doc — simpler: keep 0017 free of favorite; update the plan line now via edit after writing changes.

Let me now write 0017 proposal.md, design.md, tasks.md, and three spec deltas.

Proposal:
Why: 新稿主页以「分组」组织名片，详情展示所属分组；现有只有多标签，主页标签胶囊条与新稿不符；需要单一分组 + 分组管理。
What changes: model, entity, repo, home group row/filter, group management page, detail group row, spec deltas.
Capabilities: Modified card-list, card-detail, search-tags.
Impact: files list. Out of scope: home visual redesign (0019), manual create (0018), favorites.

Design decisions, migration, risks.

Tasks: 8 tasks, each with exact files.

Let me write.

Now tasks.md and specs.

Tasks (≤8, per repo rule ≤8 tasks). 8 sections.

1. 模型与迁移
   1.1 BusinessCard group + tests
   1.2 Entity + CardGroupEntity + container schema
   1.3 Repository protocol + SwiftData impl
   1.4 InMemory impl
   1.5 migration test
2. 单测
3. 分组管理 VM/View
4. 主页分组行/筛选
5. 详情分组行
6. UI tests
7. docs
8. validate/verify

Keep 8 top-level tasks with sub-items.

Spec deltas: card-list, card-detail, search-tags.

card-list delta:

## ADDED Requirements

### Requirement: 按分组筛选名片

系统 SHALL 在名片夹首页展示当前分组与名片数量，并提供分组管理入口；用户可以按单一分组筛选名片，每张名片 MUST 最多属于一个分组。

#### Scenario: T21 创建分组并按分组筛选
- GIVEN 本地已有至少一张未分组名片
- WHEN 用户在分组管理中新建「客户」，并把一张名片移入该分组
- THEN 主页分组行 MUST 显示「客户」与该组名片数
- AND 选择「客户」后 MUST 只显示该组名片
- AND 选择「全部名片」后 MUST 显示全部名片

#### Scenario: T22 删除分组后名片回到未分组
- GIVEN 分组「客户」下有一张名片
- WHEN 用户删除该分组并确认
- THEN 该分组 MUST 从分组清单消失
- AND 该名片 MUST 仍然存在
- AND 打开详情 MUST 显示「未分组」
- AND 删除分组后 MUST NOT 删除名片或图像文件

#### Scenario: 分组名去重
- GIVEN 已存在分组「客户」
- WHEN 用户再次创建「客户」
- THEN 系统 MUST 复用已有分组或提示重名
- AND MUST NOT 产生重复分组

card-detail delta:

## ADDED Requirements

### Requirement: 详情展示分组

系统 SHALL 在名片详情展示该名片所属分组；未设置分组时 MUST 显示「未分组」。

#### Scenario: T23 详情展示分组
- GIVEN 名片属于分组「客户」
- WHEN 用户打开该名片详情
- THEN MUST 展示分组名称「客户」
- AND 分组为空时 MUST 显示「未分组」
- AND 分组信息 MUST 在重启应用后保持

search-tags delta:

## MODIFIED Requirements

### Requirement: 标签管理
系统 SHALL 支持创建标签、给名片打标签与删除标签；标签 MUST 仅用于编辑与数据保留，主页与详情 MUST NOT 展示标签或提供标签筛选入口。

#### Scenario: T16 添加标签并保留在编辑页
- GIVEN 用户打开某张名片的编辑页
- WHEN 用户新建标签 `Conference` 并保存
- THEN 重新打开编辑页 MUST 仍能看到该标签
- AND 重启应用后标签 MUST 仍存在

#### Scenario: 删除标签
- GIVEN 标签 `Conference` 已被两张名片使用
- WHEN 用户在编辑页删除该标签
- THEN 两张名片的该标签 MUST 被移除
- AND 其余字段 MUST 不受影响
- AND MUST NOT 删除名片记录

#### Scenario: 重复标签 (unchanged)

Note: openspec delta validation may require full requirement text. Good.

Also card-list's existing "搜索入口常驻" not affected.

Write tasks + specs.

Validation complains: MODIFIED requirement omits scenario "T16 添加标签并按标签筛选". Since we're replacing whole block, it requires keeping it or explicit removal? It says copy omitted scenarios into MODIFIED block. But we intentionally remove that scenario. Perhaps use RENAMED Requirements to rename scenario? OpenSpec supports RENAMED at requirement level, not scenario. Hmm.

Options: keep the old scenario name but change content? The scenario name "T16 添加标签并按标签筛选" must remain; we can keep the name and adjust its content to "按分组筛选"? That'd be misleading. Alternatively add `## REMOVED Requirements` for 标签管理 and `## ADDED Requirements` for new 标签管理. But removing a whole requirement then adding a new one with same name? Probably conflict.

Better: keep scenario name T16 but make it about tags preserved in edit page + filtering by group? Hmm traceability T16 currently maps to tag filtering. New behavior: tags are still managed in edit; group filtering replaces tag filtering. Keep scenario id T16 for "添加标签并保留在编辑页" — but validation requires the old scenario name retained.

Maybe rename requirement scenario using `## RENAMED Requirements`? Let me check openspec docs or `openspec show`. Renamed syntax:

## RENAMED Requirements
- FROM: `### Requirement: Old`
- TO: `### Requirement: New`

Only requirement-level.

Simplest fix: keep the old scenario title "T16 添加标签并按标签筛选" but change its body to the new expectation? That contradicts the title. Alternatively keep old scenario as-is (tag filter still works somewhere?) — but home no longer has tag filter.

Wait: does 0017 need to remove tag filtering? The design doesn't show tags. We could keep tag filtering functionality accessible only in Search page? Not designed. No.

Another approach: make the MODIFIED block include the old scenario but mark it as replaced? Validation only checks names. We could include:

#### Scenario: T16 添加标签并按标签筛选
- **GIVEN** 用户打开某张名片的编辑页
- **WHEN** 用户新建标签 `Conference` 并保存
- **THEN** 标签 MUST 保存在名片数据中
- **AND** 主页 MUST 使用「分组」而非标签进行筛选
- **AND** 详情 MUST NOT 展示标签

That keeps the name but semantics shift. It's awkward but traceability stays T16. Then no extra scenario. Traceability T16 row can be updated to "T16 添加标签（保留数据）".

Actually cleaner: keep the scenario name exactly and rewrite content to new behavior, and don't add a new scenario. Then the delta has 3 scenarios same names:
1. T16 添加标签并按标签筛选 → rewrite to "标签仅保留不筛选"? Name says 筛选 though.

Hmm. Maybe better to introduce a new requirement "标签保留" and REMOVE the old "标签管理"? But data/tags still managed, just not filtered. Removing and adding same-named requirement likely invalid.

Let me check OpenSpec delta semantics for modified requirement scenario renaming. Maybe there's `## RENAMED Requirements` supporting scenarios? Let's inspect openspec docs quickly via CLI `openspec show 0017-card-grouping --json --deltas-only` or look for docs in node_modules. Search for "omits scenario(s)" in openspec installation.

Validation rule: MODIFIED must not drop existing scenarios. So I must keep the scenario name "T16 添加标签并按标签筛选". Options:
- Keep name, rewrite content. The name becomes inaccurate; but we could interpret "按标签筛选" as still existing somewhere? If we remove home tag filter, it's wrong.
- Do not MODIFY 标签管理 at all in 0017; instead keep tag filter functionality? But home UI will remove tag bar in 0019, and behavior "按标签筛选" would be gone then. Could keep as a spec requirement not fully surfaced? Specs describe behavior; if no UI, it's unimplementable.
- Remove the requirement entirely: `## REMOVED Requirements` for 标签管理, and add a new requirement "标签保留" with scenarios T16a etc. But T16 traceability changes. OpenSpec supports REMOVED Requirements section. Then the old scenario is intentionally removed, allowed.

Better: `## REMOVED Requirements` — `### Requirement: 标签管理` with a Reason. And `## ADDED Requirements` — `### Requirement: 标签数据保留` (T16). But removing tag management would remove editing spec; new requirement covers.

However, is removing tag filtering too aggressive? The new design's group filter replaces it. Tags remain editable — but the tag-management requirement describes creation/deletion, which still exists in edit page. Only the "按标签筛选" part goes. We could instead split: keep "标签管理" but drop only the filter clause. Validation blocks dropping a scenario. So use REMOVED + ADDED.

Let me restructure search-tags delta:

## REMOVED Requirements

### Requirement: 标签管理

**Reason**: 新稿主页与详情不再展示标签，筛选能力由「分组」承担；标签创建/删除仍保留，但合同需重写。

## ADDED Requirements

### Requirement: 标签编辑并存

系统 SHALL 允许在编辑页创建、删除标签并持久化；主页与详情 MUST NOT 展示标签或提供标签筛选入口。

Scenarios:
- T16 添加标签并保留在编辑页
- 删除标签
- 重复标签

Then T16 name changes in traceability to "添加标签并保留在编辑页". Fine.

Will validation accept REMOVED+ADDED with different requirement names? Yes likely.

Let me update search-tags spec.

Also card-detail ADDED is fine; card-list ADDED fine.

Check if REMOVED requires scenarios? Error message says each requirement MUST include at least one scenario. For REMOVED, maybe just reason. Let me look at openspec docs example. Search node_modules for "REMOVED Requirements".

REMOVED needs Reason + Migration. Let me rewrite search-tags delta as REMOVED + ADDED.

Requirement names must differ to avoid collision. Use "标签编辑与保留" for ADDED.

Validated. Now what? Per workflow, human approves change before Build. The user has already approved the plan direction and answered questions. They didn't explicitly say "start building 0017". But earlier I said "确认后我就开 0017 的 proposal/design/tasks，通过 validate 后开始写代码". They confirmed the three questions. So proceeding to implement is expected.

Should I implement 0017 now? That's a decent chunk: model, entity, repo, group management view, home changes, detail row, tests, docs, verify. Given context budget (~?), it's feasible but long. The user said "继续" repeatedly; they want progress. I think implement 0017.

However, repo says Plan phase prohibits code changes; Build phase via /opsx-apply. We can consider plan approved. But safer: report the validated change and ask "开始 Build 0017？" — that's another stall. Hmm.

The user's last message was answering decisions, implicitly authorizing. I'll proceed to implement 0017. Use TodoWrite to track.

Let me plan implementation:

Files:
1. Core BusinessCard: add group: String? param after tags? Add `public var group: String?`, init param `group: String? = nil`, assign. Tests may need no changes (default).
2. Entity: groupName: String?, CardGroupEntity, init/apply/domainModel.
3. BizScanApp container schema: add CardGroupEntity. Let me read BizScanApp.
4. Repository protocol + SwiftData + InMemory.
5. HomeViewModel: selectedGroup, groups, groupCounts, visibleCards filter; remove tags? Keep tags property maybe unused; HomeView uses tagBar. We'll update HomeView minimally: replace tagBar with groupBar; keep List.
6. GroupManagementView + GroupViewModel.
7. DetailView: add group row in List section.
8. DetailViewModel: groupDisplayName.
9. Tests: RepositoryTests additions, HomeViewModelTests update (existing testT16 uses toggleTagFilter → must change), new GroupViewModelTests. UI tests T21/T22/T23 might be heavy; existing UI tests seed data. Let me inspect UITests infrastructure and HomeViewModelTests.

Given the scale, maybe delegate to general-purpose agent? But I need control over design. I can implement directly.

Wait — the user asked for a plan, and I've delivered plan + change proposal. Maybe the right move is to present and let them approve Build. The repo explicitly: "人类：...批准 change". I should not start code without approval. The last message was about three decisions, not "开始实现". But my previous message said "确认后我就开 0017 ... 通过 validate 后开始写代码" — they confirmed. That is approval to start 0017.

I'll proceed to implement 0017, but be careful: this is a large change; ensure build/test. Time budget is fine.

Let me read BizScanApp, HomeViewModelTests, UI test helpers.

Now implement.

Step 1: BusinessCard add group.

Note test `HomeViewModelTests.testToggleTagFilter...` will break if toggleTagFilter removed. We'll replace with group test.

Entity: add groupName + CardGroupEntity. Container schema updates in 3 places + schema in makePersistentTestContainer.

Repository protocol: add group methods. InMemory implement with groups dictionary/list.

Group normalization reuse ContactNormalizer (Core). Error cases: emptyGroup, duplicateGroup.

HomeViewModel:
- properties: cards, groups ([String]), selectedGroup: String?
- visibleCards filters by group
- groupCounts? For header: selectedGroupName + count of visibleCards. Design "全部名片 2" count of current selected list. Provide `currentGroupTitle` and `visibleCards.count`.
- reload: cards = fetchAll; groups = allGroups; if selectedGroup not in groups → nil.
- toggleTagFilter removed; tests updated. Keep tags? remove `tags` property.
- Add `func selectGroup(_ group: String?)`.
- delete unchanged.
- thumbnail unchanged.

HomeView:
- replace tagBar with groupBar: HStack: Button showing "全部名片"/selected group + count; Spacer; Button 分组管理 with folder icon → sheet GroupManagementView.
- tags removed.
- Selection UI: how do you pick a group? Design group row is a label, not a picker. Group Management page allows entering a group; selecting a group from there sets filter. Simplest: group row tap opens group list sheet (picker) too? Design shows "当前分组" left, "分组管理" right. Implement left title as Menu with all groups (dropdown) — functional and close to design. And 分组管理 opens management sheet.
- Let HomeView hold `isGroupManagementPresented`; GroupManagementView gets environment and onSelect closure? It needs to update HomeViewModel selectedGroup. Could pass binding/closures.

Simplest architecture:
- HomeView owns `@State private var isGroupManagementPresented`.
- GroupManagementView(selectedGroup: Binding<String?>, repository:..., imageStore:...) manages its own GroupViewModel, and has onSelect callback to set viewModel.selectedGroup and dismiss.
- Or GroupViewModel created in Home? Better: GroupManagementView takes `onSelect: (String?) -> Void`.

GroupManagementView:
- @Environment(AppEnvironment.self)
- @State viewModel: GroupViewModel?
- .sheet from Home.
- List:
  Section "全部名片" row with count, selected checkmark → onSelect(nil), dismiss.
  Section "分组" ForEach groups with count, tap select; swipe 重命名/删除.
  toolbar + 新建分组 (alert with TextField), 完成 close.
- Rename via alert; delete with confirmationDialog.
- Use accessibility identifiers: BizScan.Groups.Manage, BizScan.Groups.Add, BizScan.Groups.Row.<name>, BizScan.Groups.SelectAll, BizScan.Groups.Done, BizScan.Groups.Delete.

GroupViewModel:
- repository
- groups: [String]
- counts: [String: Int]
- errorMessage
- reload()
- create(name) -> trimmed; duplicate → error
- rename(from,to)
- delete(name) -> caller may reset selection
- moving cards: How does a card get into a group? Design has no UI for moving. Need a way: In group management, selecting a group only filters. To satisfy T21 "把一张名片移入该分组", need a move action. Options:
  - Detail page group row is tappable → picker (not in design but functional). In 0017 detail group row could be a Button opening group picker.
  - Home row menu "移入分组"? Design has "..." menu; adding "移动分组" there is natural and supports T21.
Implement both? Minimal: row menu in Home list (context menu or swipe action) "移动到分组". Also detail group row button? Keep scope: add Home row swipe action "分组" / context menu. Simpler: in Home List row, add `.swipeActions(edge: .leading)` with "分组" opening a sheet/picker. But UI tests can tap.

Better: detail page group row tappable → picker (design shows a row with icon; making it tappable is natural). And Home row context menu "移动到分组". For T21 test, do it from detail: open card → tap group row → choose 客户. That's intuitive. But 0017 detail row currently `List` section; implement Button with sheet.

Hmm, but design's detail group row is non-interactive visually. Tappable is invisible affordance; acceptable.

Simpler to implement and test: Home row swipe → "移入分组" action sheet. Let me do both Home swipe and Detail row tap? More code. Keep one: Detail group row is a Menu (tap → group list) — accessible and discoverable. T21 UI test: seed card → open detail → tap group row → tap 客户 → back → filter 客户. That works.

But 0017 also needs creating a group: from Home 分组管理 → +. Then set group via detail menu. UI test flow long but doable.

Actually for UI tests, long flows are brittle. Could unit-test VM + add UI test only for group management creation & filter. The repo requires UI test per Txx, but we can do it.

Let me implement:
- HomeView group bar: left `Menu` listing 全部名片 + groups (select filter), label current + count; right Button 分组管理.
- Detail group row: `Menu` listing groups to assign? That conflates display and edit. Better a Button that opens `GroupPickerSheet` — a simple sheet listing groups + 未分组. Reuse in Home? Not needed.

To limit code, create `GroupPickerView` component used by detail. Home group bar uses Menu.

Wait, the design shows detail group row with icon + name only; tapping opens picker is fine.

GroupManagementView also needed.

Let me write code now.

BusinessCard.swift edit:
- add `public var group: String?` after tags.
- init param `group: String? = nil` before tags? Adding with default keeps callers compatible as long as parameter order after existing defaults; label-based so fine. Place after tags.
- set self.group.

Entity:
- `var groupName: String?`
- init assign
- domainModel pass `group: groupName`
- apply
- CardGroupEntity.

Repository protocol additions with docs.

SwiftData:
- allGroups fetch CardGroupEntity sorted by name.
- createGroup: trim/halfwidth, empty -> emptyGroup; case-insensitive existing -> return existing (per spec "复用或提示重名"; design decision: createGroup reuses).
- renameGroup(from:to:): validate; existing target -> duplicateGroup; update entity name and cards' groupName.
- deleteGroup: remove entity; set matching cards groupName nil; save.
- setGroup(cardID:to:): guard card exists else cardNotFound; normalize; set.
- fetchCards(group:): fetch all filtered (in-memory filter fine; could predicate).
- Note save(_ card): ensure group exists? If card.group set, create group entity if absent (like tags). Add.

InMemory: mirror.

Errors: add emptyGroup, duplicateGroup.

HomeViewModel changes + tests.

Let me write edits.

BusinessCard is Equatable/Codable synthesized — adding optional property with default won't break decoding of old JSON? Codable synthesized requires key present unless optional (optionals decode as nil if missing). Yes optional decodes fine.

Now entity.

Now update BizScanApp schema in 3 places + seed groups? Seeds should maybe add groups for UI tests? For T21 test, create group via UI. But seeding groups helps T23. Let's seed one group "Customer" → David? Could affect existing tests? They check names/counts. Home group bar shows 全部名片 count 3. Fine. But 0017 UI tests can create.

I'll add CardGroupEntity to schemas, and seed card groups: David -> "客户", 朱 -> "教授"? Not necessary; T23 UI test can use detail group row. But group row should show something. Seed helps. However seed is only for -ui-testing. Let's seed tags as before and also groups matching existing tags? That may mask migration. Keep seed groups: David "客户"; Alice "合作伙伴". I'll add a couple.

Changes:
1. `ModelContainer(for: BusinessCardEntity.self, TagEntity.self)` → include CardGroupEntity.
2. schema in makePersistentTestContainer.
3. makeInMemoryContainer.
4. seed: insert groups.

Let me edit.

Now repository protocol + implementations.

Protocol:
```swift
func allGroups() throws -> [String]
func createGroup(_ name: String) throws -> String
func renameGroup(from: String, to: String) throws
func deleteGroup(_ name: String) throws
func setGroup(cardID: UUID, to group: String?) throws
func fetchCards(group: String?) throws -> [BusinessCard]
```
Errors: add emptyGroup, duplicateGroup. Also cardNotFound exists.

SwiftData impl details:
- normalization helper `normalizedGroupName(_:)` using ContactNormalizer.trimming(halfWidth). Return nil if empty.
- allGroups: fetch CardGroupEntity sorted name; but also groups referenced by cards may not have entity (legacy) — union. Implement union: entity names + card groupName distinct. Sorted with localized compare.
- createGroup: normalize, require non-empty; find existing case-insensitive -> return existing.name; insert; save.
- renameGroup: normalize old (case-insens find), new non-empty; if same -> return; if target exists -> throw duplicateGroup; find entity by old name; rename; update cards whose groupName matches old (case-insensitive) to new; save.
- deleteGroup: find matches; delete; cards with group match -> nil; save.
- setGroup: fetch entity; normalize; set groupName; save; if group non-nil, ensure group entity exists (createGroup).
- fetchCards(group:): if nil all; fetch all and filter case-insensitive.

InMemory similarly with `groups: [String]` and cards dict.

Let me write edits.

Now InMemory implementation. Add `groups: [String]`, init param, methods after tags.

Also save(): ensure group exists? InMemory createGroup on save if card.group non-nil. Let's do.

Write edit adding methods before closing brace.

Potential Swift warning: `for (id, card) in cards where` — `for case`? `for (id, card) in cards where condition` is valid Swift (where clause on for-in). Yes.

`deleteGroup`: `card.group?.lowercased() == key` — key built from halfWidth(name).lowercased(), card.group raw may be full-width; fine for now. Better normalize card group too. Acceptable.

Now SwiftData implementation. Add methods.

Need group normalization helper and union for allGroups.

Implementation:

```swift
func allGroups() throws -> [String] {
    let entities = try context.fetch(FetchDescriptor<CardGroupEntity>(sortBy: [SortDescriptor(\.name)]))
    let cards = try context.fetch(FetchDescriptor<BusinessCardEntity>())
    var names = entities.map(\.name)
    var seen = Set(names.map { $0.lowercased() })
    for card in cards {
        guard let g = card.groupName?.trimmingCharacters(...), !g.isEmpty else { continue }
        if !seen.contains(g.lowercased()) { names.append(g); seen.insert(...) }
    }
    return names.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
}
```

createGroup similar with fetch all CardGroupEntity and case-insensitive.

renameGroup: fetch entities; find; check duplicate; oldName actual; update entity.name; update cards.

deleteGroup: fetch entities matching key; delete; fetch cards matching; set nil; save.

setGroup: fetch card entity; normalize; assign; if group non-nil ensure createGroup; save.

fetchCards(group:): fetch all then filter (reuse fetchAll) — acceptable.

save(_ card): ensure group entity exists. In save, after tags loop:
```swift
if let group = card.group, !group.isEmpty { _ = try createGroup(group) }
```

Write via Edit.

Now HomeViewModel. Replace tags with groups/selectedGroup.

New:
```swift
private(set) var groups: [String] = []
var selectedGroup: String?
var visibleCards: [BusinessCard] {
    guard let selectedGroup else { return cards }
    return cards.filter { $0.group?.caseInsensitiveCompare(selectedGroup) == .orderedSame }
}
var currentGroupTitle: String { selectedGroup ?? AppCopy.allGroups }
func selectGroup(_ group: String?) { selectedGroup = group }
func reload() { cards = try repository.fetchAll(); groups = try repository.allGroups(); if let s = selectedGroup, !groups.contains(where caseInsensitive) { selectedGroup = nil } }
func groupCount(_ group: String?) ...
```
`tagBar` removed. Tests updated.

AppCopy: add allGroups = "全部名片", groupManagement = "分组管理", ungrouped = "未分组", newGroup = "新建分组", moveToGroup = "移动到分组", groupName = "分组", deleteGroup etc. Also AppCopy.cardHolder change to "名片"? That's 0019. Keep.

Let me update HomeViewModel.

Now AppCopy additions.

Add:
- allGroups = "全部名片"
- groupManagement = "分组管理"
- ungrouped = "未分组"
- groupTitle = "分组"
- newGroup = "新建分组"
- renameGroup = "重命名分组"
- deleteGroup = "删除分组"
- moveToGroup = "移动到分组"
- done exists.
- groupDeleteConfirmTitle/Message maybe.

Let me edit.

Now GroupViewModel. Needs repository. Actions:
- groups, counts, selectedGroup binding? It can expose groups/counts/error.
- create(name) -> returns created name? For UI alert.
- rename(from,to)
- delete(name)
- reload.

Also `move(card:to:)` is in HomeViewModel.

Note GroupManagementView needs repository; uses environment.

GroupViewModel:
```swift
@Observable @MainActor final class GroupViewModel {
  private let repository
  private(set) var groups: [String] = []
  private(set) var counts: [String:Int] = [:]
  private(set) var totalCount = 0
  var errorMessage: String?
  var selectedGroup: String?
  init(repository: BusinessCardRepository)
  func reload()
  func create(_ name: String)
  func rename(_ group: String, to newName: String)
  func delete(_ group: String)
}
```
Counts computed by fetching all cards each reload.

Create group then reload. Rename duplicate sets error. Delete resets selectedGroup if equal.

Let me write file.

Project uses XcodeGen (project.yml sources path BizScan), so new files auto-included on xcodegen. But Xcode project currently generated; building without regenerating won't include new files. scripts/verify.sh may run xcodegen. Need check Makefile/scripts.

Let me check scripts/verify.sh quickly later.

Now GroupManagementView. UI with List, toolbar +, complete, rename/delete swipe, tap select. Needs to set Home's selected group: pass @Binding var selectedGroup: String? or callback.

Design:
```swift
struct GroupManagementView: View {
  @Environment(AppEnvironment.self) private var environment
  @Environment(\.dismiss) private var dismiss
  @Binding var selectedGroup: String?
  @State private var viewModel: GroupViewModel?
  @State private var isCreating = false
  @State private var newName = ""
  @State private var renamingGroup: String?
  @State private var renameText = ""
  @State private var pendingDelete: String?
  ...
}
```
List:
Section {
  Button { select(nil) } label: HStack { Text(全部名片); Spacer; Text(count); checkmark if nil }
}
Section("分组") ForEach groups { group in Button { select(group) } label: HStack{ Text(group); Spacer; Text(count) }.swipeActions { delete; rename } }
Empty → text "还没有分组".
toolbar: cancel 完成; primary + (newGroup).
alert for create with TextField; alert for rename; confirmationDialog for delete.
error alert.

NavigationStack(title 分组管理).

Accessibility identifiers:
- BizScan.Groups.Manage (list)
- BizScan.Groups.Add
- BizScan.Groups.Done
- BizScan.Groups.All
- BizScan.Groups.Row.<name>
- BizScan.Groups.NameField
- BizScan.Groups.ConfirmCreate
- BizScan.Groups.Delete

SwiftUI alerts with TextField need iOS 16+, fine.

Implement.

Now HomeView: replace tagBar with groupBar, add sheet for GroupManagementView, and add "移动到分组" action perhaps in swipe leading. Also selection menu.

Design intent for 0017 minimal:
- Group row: HStack:
  Menu { Button 全部名片; ForEach groups } label: HStack { Text(currentGroupTitle).font(.subheadline.weight(.semibold)); Text(count).font(.caption).foregroundStyle(.secondary); Image chevron.down tiny? } 
  Spacer
  Button { isGroupManagementPresented = true } label: Label("分组管理", systemImage: "folder")
- Keep List.
- Since @State viewModel is optional, binding for sheet: pass Binding(get: { viewModel?.selectedGroup }, set: { viewModel?.selectedGroup = $0 }) — simpler: GroupManagementView(selectedGroup: Binding(...)). But viewModel optional; create a binding with fallback:
```swift
.sheet(isPresented: $isGroupManagementPresented, onDismiss: { viewModel?.reload() }) {
    GroupManagementView(selectedGroup: Binding(
        get: { viewModel?.selectedGroup },
        set: { viewModel?.selectedGroup = $0 }
    ))
}
```
Optional viewModel inside closure capture works? `viewModel` is @State optional; closure captures self. Yes.

Add "移动到分组" to swipe actions: opens a confirmationDialog with groups. Need state `movingCard: BusinessCard?`. Then ConfirmationDialog listing 未分组 + groups, on selection viewModel.move.

Maybe simpler: context menu with Menu of groups. But UI test easier with swipe + dialog.

Implement:
- @State private var movingCard: BusinessCard?
- swipe leading: Button "分组" sets movingCard.
- confirmationDialog("移动到分组") with buttons: 未分组 + groups.

Keep delete trailing swipe.

Also group bar needs count of visible. Use viewModel.visibleCards.count.

Also when filter selected, List shows only group.

Let me rewrite HomeView sections.

Also existing test expects `BizScan.Home.CardList` on List. Keep.

Accessibility identifiers: group menu `BizScan.Home.GroupMenu`, manage `BizScan.Home.GroupManage`, move `BizScan.Home.MoveGroup`.

Edit HomeView.

Now replace tagBar/tagChip with groupBar and add moveToGroup function. Read current region lines 145-200.

Potential issue: `Label(..., systemImage: "")` with empty string — SwiftUI may log/blank; better use conditional. Use `Image(systemName:)` only when selected. Simplify: Button label `Text("\(AppCopy.allGroups) \(count)")` plus checkmark via `if`. Menus support HStack labels. Let me fix to avoid empty systemImage.

Also `.accessibilityIdentifier` on Menu may work.

Fix labels:
```swift
Button { ... } label: {
    if viewModel.selectedGroup == nil {
        Label("\(AppCopy.allGroups) \(count)", systemImage: "checkmark")
    } else {
        Text("\(AppCopy.allGroups) \(count)")
    }
}
```
Similarly group.

Let me edit.

Now DetailViewModel: add group fields for editing (design later), and groupDisplayName. Also edit sheet should let setting group? T21 requires moving a card into group. Home swipe provides that. Detail group row display only. Add `var groupDisplayName: String { card?.group ?? AppCopy.ungrouped }`.

DetailViewModel also currently edit form has tags. Fine.

Add property.

Oops, my edits mangled formatting. First edit added weird missing newline (line 31-32), second removed newline before guard. Need fix.

Let me read that region and repair.

 

Now DetailView: add group row section, before tags. Use List section with Label(groupDisplayName, systemImage:"person.crop.circle"). Also remove tags section per 0017? Tags must not display on detail. So remove tags section from DetailView. Edit form still has tags.

Add group section after fields. Also add accessibility id "BizScan.Detail.Group".

Edit.

`content(_ viewModel:card:)` now doesn't use `card` except... check: image uses viewModel.image(); rows; group. `card` parameter unused → warning. Could remove param. It's called `content(viewModel, card: card)`. Remove parameter to avoid warning (warnings not errors). Let's change signature to `content(_ viewModel: DetailViewModel)` and call.

Edit both.

`if let viewModel, let card = viewModel.card` — card now unused → warning. Change to `if let viewModel, viewModel.card != nil`.

Edit.

Now tests:
1. HomeViewModelTests: replace testToggleTagFilter with group test; add group filter/count.
2. RepositoryTests: add group CRUD tests.
3. New GroupViewModelTests.
4. UI tests: SearchTagsUITests T16 references home tag chips → update to edit page tag retention; CardListUITests add T21/T22? Let me read those tests to adapt.

Also DetailViewModelTests may use content signature? No, VM only.

Let me read UI tests.

UI tests:
- testT16TagFilter must be rewritten: tags no longer on home. New T16: open David → 编辑 → verify Tag "Customer" visible → cancel. But edit sheet displays tags; good. Assert staticTexts["Customer"].exists in edit form. Also assert home doesn't show "Customer"? After dismiss.
- Home nav bar title stays "名片夹" until 0019; tests fine.

CardList: seeded groups now exist → groupBar shows "全部名片 3" and 分组管理. No conflict with staticTexts.

Add T21/T22 UI tests:
T21: launch seeded → tap "BizScan.Home.GroupManage" → add group → type → confirm → select group created (row) → back to home? Our row action dismisses sheet. Then assert home shows count 0 and no cards. Then move a card: swipe right on David? With empty filter list no cards. Better flow:
1. Create group 客户 via manage; after confirm selectedGroup=客户; dismiss sheet remains open (create alert confirm doesn't dismiss). Then tap Done.
2. Home filtered empty (0). Select 全部名片 via menu → swipe right? Swipe leading: `app.staticTexts["David Chen"].swipeRight()` reveals "分组" button; tap → dialog → tap 客户; then select menu 客户 → only David.

That's long/brittle. Simpler T21 UI test:
- Create group via manage → assert row exists with count 0 → Done.
- Select 客户 via group menu → assert "全部名片"/names absent.
- Switch back 全部名片 → names appear.
This covers create + filter, not move. Move covered by unit tests.

T22 UI: seeded group 客户 contains David. Use group management swipe delete 客户 → confirm → Done → open David detail → assert "未分组". But deleting seeded group via swipe: find row "客户" then swipeLeft, tap 删除分组, confirm 删除. Then check detail group label "未分组". Add to CardListUITests or DetailUITests.

T23: DetailUITests: open David → assert staticTexts["客户"] exists (group row). But "客户" might also appear elsewhere? No.

Note: `app.navigationBars["名片夹"]` still valid.

GroupManagementView is a sheet with navigationTitle "分组管理"; UI test can check.

Let's write unit tests first.

HomeViewModelTests: update makeCard to accept group; replace tag test:
```swift
func testGroupFilterShowsOnlyGroupCards() {
  let customer = makeCard(name:"Alice", group:"客户", updatedAt:100)
  ...
  viewModel.reload()
  XCTAssertEqual(viewModel.groups, ["合作伙伴","客户"]?) sorted by repository allGroups → InMemory groups.sorted() → Chinese sorted by Unicode: "合作" vs "客户"; compare Unicode code points: 合 U+5408, 客 U+5BA2 → 合 first. Fine.
  viewModel.selectGroup("客户")
  XCTAssertEqual(visible, ["Alice"])
  viewModel.selectGroup(nil) → 2
}
```
Also test counts and reload reset when group deleted.

RepositoryTests: add:
- testCreateGroupIsCaseInsensitive
- testRenameGroupMovesCards
- testDeleteGroupClearsCardGroup
- testSetGroupAssignsCard
- testEmptyGroupRejected

GroupViewModelTests: repository in-memory; create, duplicate reuse, rename duplicate error, delete updates counts.

Let me write.

Now RepositoryTests additions and GroupViewModelTests file.

RepositoryTests append group tests.

Note: InMemoryBusinessCardRepository init with cards but no groups: groups list empty even though cards have group; `allGroups()` returns only groups list, not derived from cards. But save() creates groups; constructor doesn't. In testReloadBuildsCounts I pass groups explicitly. In testGroupFilterShowsOnlyGroupCards, HomeViewModel moves? select group works on cards regardless of groups list. But `viewModel.groups` empty → `reload()` resets selectedGroup if not in groups! Indeed test: makeCard group "客户", repository groups empty; reload → groups = [] → selectedGroup nil; then selectGroup("客户") → visible filter works, title works, count works. `reload` already happened before select, so fine. But `testReloadResetsSelectionWhenGroupIsDeleted` passes groups.

However real app: seeded groups inserted; scanned cards group nil. Fine.

But InMemory repository semantics should mirror SwiftData: allGroups should include groups referenced by cards. Otherwise unit tests/Previews inconsistent. Better update InMemory `allGroups()` to union groups + cards' group. Then `testReloadResetsSelectionWhenGroupIsDeleted` after deleteGroup → cards' group cleared → groups empty, still fine. `testCreateGroupIsCaseInsensitive` fine.

Update allGroups to union. Also initializer doesn't need groups param for cards, but keep.

Edit:
```swift
func allGroups() throws -> [String] {
    var names = groups
    var seen = Set(names.map{$0.lowercased()})
    for card in cards.values {
        guard let g = card.group, !g.isEmpty else {continue}
        if !seen.contains(g.lowercased()) { names.append(g); seen.insert(...) }
    }
    return names.sorted()
}
```
Do it.

Now UI tests update.

T16 rewrite:
```swift
func testT16TagIsEditableAndHiddenOnHome() {
  let app = launchSeeded()
  XCTAssertFalse(app.staticTexts["Customer"].exists)
  app.staticTexts["David Chen"].tap()
  app.buttons["编辑"].tap()
  XCTAssertTrue(app.staticTexts["Customer"].waitForExistence(timeout:5))
  app.buttons["取消"].tap()
}
```
But navigationBars "名片夹" check in launchSeeded. Wait: with sheet? fine.

Careful: "Customer" staticText might exist in edit form section tags. Yes.

Add T21 to CardListUITests:
```swift
func testT21CreateGroupAndFilter() {
  let app = launchSeeded()
  app.buttons["BizScan.Home.GroupManage"].tap()
  XCTAssertTrue(app.navigationBars["分组管理"].waitForExistence(timeout:10))
  app.buttons["BizScan.Groups.Add"].tap()
  let field = app.textFields["BizScan.Groups.NameField"]
  XCTAssertTrue(field.waitForExistence(timeout:5))
  field.tap(); field.typeText("客户")
  app.buttons["BizScan.Groups.ConfirmCreate"].tap()
  XCTAssertTrue(app.staticTexts["客户"].waitForExistence(timeout:5))
  app.buttons["BizScan.Groups.Done"].tap()
  // open group menu and select 客户
  app.buttons["BizScan.Home.GroupMenu"].tap()
  let option = app.buttons["客户 0"].firstMatch
  XCTAssertTrue(option.waitForExistence(timeout:5))
  option.tap()
  XCTAssertFalse(app.staticTexts["David Chen"].exists)
  ...
}
```
Issue: group menu label includes counts and checkmark; after creation selectedGroup=客户 already (GroupManagementView sets binding on create). So Home after Done is filtered to 客户 with 0 cards; expect David absent. Then open menu, select "全部名片 3". Button label text is "全部名片 3". Use `app.buttons.matching(NSPredicate(format:"label BEGINSWITH %@", "全部名片")).firstMatch`. Might be accessible.

Also new group "客户" already exists in seeded data (David group 客户), so creating "客户" reuses existing with count 1! Then filter shows David, not empty. Better create "新分组". Use "新分组" and expect no names.

T21 flow:
- create "新分组" → selected → Done → assert David absent, label 新分组 0.
- open menu → tap "全部名片 3" → David exists.
- swipe right David → tap "分组" button → dialog → tap "新分组" → assert.
- open menu → select 新分组 1 → only David.

Complex but okay. Swipe right on `app.staticTexts["David Chen"]` reveals leading action labeled "分组". Then confirmationDialog buttons include "未分组", "客户", "合作伙伴", "新分组", "取消". Tapping "新分组" moves.

T22:
- launch seeded; GroupManage; find row "客户" (identifier BizScan.Groups.Row.客户) swipeLeft → buttons "删除分组" → tap → confirmation "删除" → tap. Then Done. Open David detail → assert "未分组" exists.
But `app.buttons["BizScan.Groups.Row.客户"]` maybe a button. Use `app.buttons["BizScan.Groups.Row.客户"]`.

T23 in DetailUITests: open David → staticTexts["客户"] exists. Note group row Label text "客户". Good.

Potential identifier collision: GroupManagementView row identifier includes group name; fine.

Let's write UI tests.

Potential T16 failure: after tapping edit, the form has tag "Customer" but the detail page may also have "Customer"? No. Also "取消" button exists. Fine.

Wait: EditCardView is a sheet; app.buttons["取消"] might match nav bar cancel. yes.

T22: swipe on row inside List; `app.buttons["BizScan.Groups.Row.客户"]` is Button with .buttonStyle(.plain) inside List; accessibilityIdentifier on Button. Swipe left should reveal actions. Then "删除分组" button label includes Label text. Good.

But confirmationDialog may present "删除" button; also the swipe action "删除分组" contains 删除... matching "删除" exact firstMatch might pick "删除分组"? XCUI exact label "删除" only. Fine.

Now build. Need xcodegen to include new files. Check verify script.

Verify script likely runs xcodegen? Let's check rest lines 60-120.

Good, xcodegen runs. Let's run core tests first (fast) then unit tests (iOS). Build may reveal compile errors.

Run `bash scripts/verify.sh --change 0017-card-grouping --scope unit` — runs core + xcodegen + iOS unit tests. Could take a few minutes. Let's do with timeout 600000.

Before that, check project compile issues:
- HomeView uses AppCopy.preview etc fine.
- GroupManagementView: `.alert(..., isPresented:)` with TextField + buttons — fine.
- GroupViewModel not Observable? used @Observable fine.
- `viewModel.count(for:)` in View uses counts.

Potential SwiftUI issue: In GroupManagementView `list(_ viewModel: GroupViewModel)` shadowed optional state; fine.

Potential compile: `ForEach(viewModel.groups, id: \.self)` inside confirmationDialog — allowed.

`Label(title, systemImage:)` in Button label inside Menu with if/else — SwiftUI ViewBuilder supports.

`DetailView` content no longer uses BusinessCard import? still imports BizScanCore for BusinessCard? It uses `let card = viewModel?.card` in exportCard, so still needs.

HomeViewModel still imports UIKit.

Test target includes new files via xcodegen.

Potential Core test compile: BusinessCard Equatable etc fine.

Let me run unit scope.

Unit tests pass (67). Need UI tests for T21-T23 and T16. Run UI scope (all UI tests) — may take several minutes. Let's run.

But first, note `-ui-testing-seed` now seeds groups; existing PersistenceUITests might assert counts? Let's just run UI.

Use --scope ui. It also reruns core. Timeout 10 min.

---

**User**

当前的UI差异为什么与稿子完全不同？

**User**

只要报告

**Assistant**

## 报告：当前 UI 与设计稿完全不同，因为改版只完成了第 1 步（数据结构与分组行为），视觉还原尚未开始

### 1. 原因

按你确认的实施顺序，整个改版被拆成 6 个独立增量：

```
0017 分组数据与筛选  ← 当前只做了这一步
0018 手动新建
0019 主页 1:1
0020 详情 1:1
0021 待核对
0022 存入通讯录
```

0017 的目标只是把「标签筛选」换成「分组筛选」并落库，**不含任何视觉重做**。所以现在看到的仍是旧的系统 `List`、系统导航栏、系统强调色、旧字号和旧间距，只在旧界面上加了一条分组栏和一个分组行。

### 2. 当前实际状态对照

| 区域 | 设计稿 | 当前实现 |
|---|---|---|
| 页面底色 | `#191919` 深色 | 系统分组背景色（跟随浅色/深色） |
| 标题 | 「名片」26/700 | 「名片夹」系统大标题 |
| 顶部 `+` | 40×40 圆角按钮 | 不存在 |
| 搜索 | 常驻圆角搜索框 | 仍是导航栏放大镜 |
| 分组行 | 「全部名片 2」+「分组管理」深色样式 | 已加分组行，但用系统字体与系统色 |
| 列表 | 98×64 缩略图、19pt 姓名、日期分组、`…` 菜单 | 旧版 64×40 缩略图、单行副标题、无日期分组、左滑删除 |
| 扫描按钮 | 底部居中 68pt 蓝色圆钮 | 右下角 56pt 系统强调色圆钮 |
| 空状态 | 线稿图标 + 一行提示 | 旧版图标 + 标题 + 描述 + 按钮 |
| 详情顶栏 | 蓝色 `#176FD1` 自定义栏 + 星标 | 系统导航栏（编辑/更多） |
| 详情结构 | 头像卡 + 4 个快捷圆钮 + 分段卡 | 旧版 insetGrouped 表单 |
| 详情分组 | 独立行 | 已加一行，样式为系统 Label |
| 底部按钮 | 固定「存入通讯录」 | 不存在 |

也就是：**0017 只改了数据和筛选逻辑，像素级还原在 0019（主页）和 0020（详情）**，这两步还没开始。

### 3. 为什么会这样拆

- 仓库 `openspec/AGENTS.md` 要求「一个 change 只包含一个可命名的行为增量」，超过 8 个任务必须拆分；把视觉重构和分组模型塞进同一个 change 会直接违反该约束。
- 视觉重构会重写 `HomeView` 和 `DetailView` 的全部布局，如果先做视觉、后补分组模型，等于同一批文件改两遍。
- 你上一条消息才确认「苹方、手动新建、标签保留编辑」，这些结论必须先落进计划，再做视觉。

### 4. 当前完成度与验证

- 已完成：`group` 字段、`CardGroupEntity`、分组 CRUD、迁移兼容、主页分组筛选、详情分组展示、标签从主页/详情移除。
- 单元测试：`BizScanCore` + `BizScanTests` 共 67 项全部通过。
- UI 测试：T21/T22/T23 与调整后的 T16 已写，但**被你打断，尚未执行**。
- 视觉：**0%**，只有 0017 的功能性中间态。

### 5. 要变成设计稿还需要做的事

- **0019 主页**：主题令牌、深色强制外观、自定义标题栏/搜索框/分组行、日期分组列表、行 `…` 菜单、底部居中 FAB、空状态。
- **0020 详情**：蓝色自定义顶栏、头像核心卡、查看原图、4 个快捷操作、分组/备注/联系方式分段卡、行内编辑、收藏、固定底栏。
- **0018 手动新建**：`+` 的表单与无原图名片。
- **0021/0022**：待核对标签、系统通讯录写入。

如果你希望**先看到设计稿的样子**，我可以跳过 0018，直接做 0019 + 0020 的视觉层，把功能接线留到后面；这不会影响已完成的 0017。你确认后我再执行。

---

**User**

算了，逐步执行

**Assistant**

The user says "算了，逐步执行" — forget it, execute step by step. So continue with the plan: finish 0017 verification (UI tests), docs, then proceed 0018, 0019, 0020, 0021, 0022 step by step.

First step: run UI tests (they were interrupted). Then docs for 0017, then move to 0018.

Let's run UI tests now.

Two failures. Need to find both. T16: after edit sheet opens, "Customer" not found as staticText. Maybe tags section requires scrolling down the Form; XCUI `.exists` only matches on screen? XCUI finds offscreen elements in scroll views? It does find them if in hierarchy, but SwiftUI Form lazily renders rows; tags section far below → not rendered. Need to swipe up in form or use `app.swipeUp()`.

Alternatively verify tag data via edit text? Better: `app.swipeUp()` twice then check "Customer". Let's adjust test: after edit opens, swipeUp until Customer exists.

Second failure unknown — log shows "Executed 17 tests, with 2 failures". Need find the other failure in log. grep "error:".

Let me grep the log for "error:" and "failed".

T21 fails at line 62: `XCTAssertTrue(app.navigationBars["分组管理"].waitForExistence(timeout: 10))` — navigationBars title may not be "分组管理" because sheet's NavigationStack inline title... It should be. Perhaps the tap on GroupManage didn't open because button is inside Menu? No, it's a Button. Wait line numbers: file line 62 in CardListUITests after edit? Let me view lines 54-70. Line 62 might be `nameField.waitForExistence`. Let's check.

Actually earlier: line 57 GroupManage tap, 58 assert nav bar, 60 Add tap, 61 let nameField, 62 XCTAssertTrue(nameField.waitForExistence). So the alert text field not found.

Issue: SwiftUI alert with TextField + custom accessibilityIdentifier inside alert may not expose identifier. Also `.alert` with TextField only shows when tapped; the alert may not appear because toolbar button identifier? `app.buttons["BizScan.Groups.Add"]` — toolbar plus button with identifier; likely exists. But alert TextField identifier may be dropped (system alert). Fallback: `app.alerts.textFields.firstMatch` or `app.textFields.firstMatch`.

Also potential: tapping plus while List sheet just opened task not done; but nav bar existed.

Fix test: after tapping Add, use `let alert = app.alerts["新建分组"]; XCTAssertTrue(alert.waitForExistence(...)); let field = alert.textFields.firstMatch; field.typeText("新分组"); alert.buttons["确认"].tap()`.

Alert button identifiers also may not carry; use alert.buttons["确认"].

Similarly rename alert later.

For T16: scroll the form. Use `app.swipeUp()` twice before asserting Customer. Or verify edit page tag by scrolling. Let me add:
```swift
let sheet = app.navigationBars["编辑"]
...
for _ in 0..<3 where !app.staticTexts["Customer"].exists { app.swipeUp() }
XCTAssertTrue(...)
```
Swift `where` in for with condition closure? `for _ in 0..<3 { if app.staticTexts["Customer"].exists { break }; app.swipeUp() }`.

Then cancel: after scrolling, "取消" button still in nav bar visible (inline). Fine.

But maybe the tags section shows `Customer` as TextField value? It's Text in HStack. Scrolling should reveal.

Also T16 assertion `XCTAssertFalse(app.staticTexts["Customer"].exists)` right after launch: home doesn't show tags now. Fine.

Let me apply fixes and rerun only affected tests to save time: xcodebuild -only-testing:BizScanUITests/CardListUITests/testT21CreateGroupAndFilter -only-testing:.../SearchTagsUITests/testT16... Use direct xcodebuild after xcodegen. But verify.sh runs all UI. Faster: run xcodebuild with -only-testing for these two. Then full UI at end.

Let me edit tests.

Also T21 after creation: `XCTAssertTrue(app.staticTexts["新分组"].waitForExistence)` — row text. Then Done. After Done, home filtered to 新分组 (selectedGroup set by create). Home group bar shows "新分组". Then asserting `app.staticTexts["新分组"]` might match bar text, good; and David absent. Then open GroupMenu button. But if the bar's Menu label and staticTexts both have 新分组, `app.buttons["BizScan.Home.GroupMenu"]` still unique.

Then `app.buttons.matching(label BEGINSWITH "全部名片")` — Menu items appear in a popover; fine.

Swipe right on David: leading swipe action. Then `app.buttons["分组"]` — label of swipe action. Good.

Then confirmationDialog buttons: "新分组" exists. Tap.

But moving card triggers reload while filter is 全部; after move, list still all. Then open menu select 新分组 (label "新分组 1"). OK.

Potential issue: `app.buttons["新分组"].tap()` in confirmationDialog could match menu item? Menu is closed by then. Fine.

Run the two tests directly. xcodegen first. Then xcodebuild test -only-testing both.

Command:
xcodegen generate && xcodebuild test -project ... -only-testing:BizScanUITests/CardListUITests/testT21CreateGroupAndFilter -only-testing:BizScanUITests/SearchTagsUITests/testT16TagIsEditableAndHiddenOnHome ...

Destination iPhone 16 OS 18.0 as script. Use derivedDataPath build/DerivedData.

Run.

Both pass. Need full UI run to ensure T22/T23 etc. But T22/T23 were in the previous run: 17 tests, 2 failures = only these two. So others passed, including T22/T23. Good.

Still should run full verify (all) once at the end for evidence. But that's ~3min. We'll do after docs.

Now docs for 0017:
- docs/verify/0017-card-grouping.md using template.
- docs/traceability.md update T16 + add T21-T23.
- README stage board.

Read template and docs/verify dir + README relevant sections.

Now write verify doc for 0017 with actual evidence: unit 67 pass, UI 17 tests with 2 initial failures then targeted rerun pass; full UI not rerun after fix. To be accurate, I should run full unit+ui once after fixes. Let's do full verify now (core+unit+ui, ~3-4min). That gives a single log + xcresult for the report. Do it.

Then write docs.

Full pass. Get log filename and environment info for verify doc.

Now write docs/verify/0017-card-grouping.md.

Scenarios:
card-list ADDED:
- T21 创建分组并按分组筛选 → BizScanUITests/CardListUITests.testT21CreateGroupAndFilter (PASS) + unit HomeViewModelTests.testGroupFilter..., RepositoryTests...
- T22 删除分组后名片回到未分组 → testT22DeleteGroupMovesCardToUngrouped PASS + RepositoryTests.testDeleteGroupClearsCardGroup
- 分组名去重 → RepositoryTests.testCreateGroupIsCaseInsensitive + GroupViewModelTests.testCreateGroupReusesExistingName PASS
card-detail ADDED:
- T23 详情展示分组 → DetailUITests.testT23DetailShowsGroup PASS
search-tags REMOVED 标签管理 + ADDED 标签编辑与保留:
- T16 添加标签并保留在编辑页 → SearchTagsUITests.testT16TagIsEditableAndHiddenOnHome PASS
- 删除标签 → no automated? RepositoryTests.testDeleteTagRemovesItFromCards (PASS) covers data; UI edit deletion not covered → mark PASS (L2) noting UI 未覆盖.
- 重复标签 → RepositoryTests.testTagCreationIsCaseInsensitive PASS.

Regression: make unit 67 pass; make ui 17 pass.

Deviations: D1 标签删除仍只有 L2，无 UI; D2 分组管理页无设计稿，自绘; D3 主页视觉未改（0019）. Level general.

Conclusion Ready for archive? All scenarios pass, no blocking. But 0017 review: user might not want archive yet. Mark Ready for archive with note.

Then traceability update:
- T16 row: rename scenario to "T16 添加标签并保留在编辑页"; test method; status 通过（0017）
- Add T21-T23 rows after T20. Note header "T01–T23".
Also T21/T22/T23 specs maps.

README stage board: add P8 row? Current P7 row. Add P8 UI 改版（0017…）进行中 with evidence link. Let's inspect README around stage table lines 38-55 to insert properly.

Add P8 row. Also update T16/T21-23 in traceability.

Write verify doc first.

Now update traceability: header T01–T23; T16 row; add T21–T23 rows.

Read line 11 & 26 exactly to edit. Already saw T16 row line 26. T20 last line. We'll edit.

Now README P8 row + verification-debt D3 entry.

Add P8 row after P7. Also update line 3 of traceability "20 个 Reference Test Scenarios" maybe to 23? The text says 要求/01 defines 20; T21-23 are new. Update to "T01–T23" semantics. Edit line 3.

README P8:
| P8 | 名片 UI 改版（分组/新建/主页/详情/待核对/通讯录） | `0017`…`0022` | 进行中：`0017` 分组数据与筛选完成，core 67 + UI 17 全绿；`0018`–`0022` 待开始 | [`docs/verify/0017-card-grouping.md`](...) |

verification-debt add D3? Let's read its structure briefly.

Also verification-debt D3 mention maybe. Let's check file structure quickly and add a row for 0017 T16 UI deletion? The verify doc says "已登记 docs/verification-debt.md". Must actually add or remove claim. Add entry.

Read file head/structure.

Add row to L2 table for 0017 debt D3. Find L2 table end.

Update HomeViewModel row (3 → now 6 tests, group filtering), add GroupViewModel row, add debt for tag delete UI.

Edit rows.

0017 is done (code + tests + docs). Should I archive? Repo says Merge only after human approval. Don't archive; leave for user. Mark tasks complete in tasks.md? Repo says build marks tasks. Update checkboxes [x] for 1-7, and 8.1/8.2 done. Do it.

Now proceed to 0018 manual card creation. "逐步执行" means continue step by step. Let's do 0018.

Scope:
1. Core: originalImagePath optional.
2. Entity optional.
3. Update usages:
   - SwiftDataBusinessCardRepository.delete: if let path = entity.originalImagePath
   - DetailViewModel.image(): guard let path
   - HomeViewModel.thumbnail: guard
   - SearchViewModel.thumbnail: guard
   - ReviewViewModel: BusinessCard(id:originalImagePath:"") → nil; set path.
   - Tests: ReviewViewModelTests `stored.originalImagePath.isEmpty` → `XCTAssertNotNil`; `imageStore.data(forRelativePath: stored.originalImagePath)` needs unwrap.
   - VCardExporter unaffected.
   - PersistenceTests comparisons with optional fine (XCTAssertEqual optional vs string works).
4. NewCardView + NewCardViewModel:
   - fields: same as EditCardView plus group and tags? Tags hidden in display but editable; keep in edit page. For new card, include tags? Simpler: mirror edit form sections: 基本信息, 联系方式, 备注, 分组; tags maybe keep for parity. Since tags UI remains in edit, include tags in new form too (consistency). But scope creep; include group selection.
   - Save via repository (originalImagePath nil, processed nil).
   - Empty card confirmation (reuse semantics: if all fields empty → confirm).
   - Group passed from Home: new card should default to currently selected group (if filtered). Nice.
   - Navigation title "新建名片"; 取消/保存.
   - accessibility IDs: BizScan.New.Name.
5. HomeView `+` in toolbar: present sheet NewCardView.
   - Home currently toolbar has search. Add plus trailing.
   - Design's plus is visual 0019; here functional.

Protocol additions already made. BusinessCard init accepts String? after change; callers with strings compile.

Important: `originalImagePath` optional in Core affects `imageStore.image(forRelativePath:)` calls. Check signatures: ImageStoring takes String. Use guard.

Let's inspect ImageStore protocol and SearchViewModel.

Also `BusinessCard.displayTitle` etc unaffected.

Implement.

First create OpenSpec change 0018 with proposal/design/tasks/specs deltas:
- card-model MODIFIED: `originalImagePath` optional (manual card). Also T12 scenario says record contains 两张图像路径 — modify? The requirement "名片记录结构" scenario T12 says MUST include id、两张图像路径、createdAt. Need MODIFIED requirement to allow manual cards without images. Write delta.

New requirement: 手动新建名片 (card-list? or new capability "manual-create"). Specs are capability-based; adding a new capability directory `manual-card-create`? AGENTS says new capabilities allowed. Simpler: add to card-list spec ADDED requirement "手动新建名片" with T34/T35. But list capability covers home entry; acceptable. Hmm, better new spec `card-create/spec.md`? OpenSpec allows new capability spec in change. But archive would create new capability. I'd put ADDED requirement into card-list since entry is home and behavior is list update. Also card-model modified.

T34 手动新建无原图名片; T35 手动新建空卡需确认.

Validation: card-model MODIFIED must keep scenarios. We'll copy existing scenarios with modifications.

Card-model data table is outside Requirements; delta can't modify table. Add MODIFIED requirement "名片记录结构" that states image paths optional for manual.

Let's create 0018 change files, validate, then implement.

Proposal/design concise. Tasks ≤ 8.

Do it.

Now 0018 manual create. Need OpenSpec change with deltas:
- card-model MODIFIED: originalImagePath becomes String? optional; new requirement? The data model section says "字段增删、类型变化必须通过 MODIFIED Requirements". We can add a MODIFIED Requirement "名片记录结构" reflecting optional image path for manual cards + new scenario T34.
- card-list ADDED: Requirement "手动新建名片" T34/T35 maybe.
- card-list MODIFIED "名片列表展示"? scenario 列表缩略信息 requires thumbnail; manual card has none → placeholder. Could add scenario within new requirement.

Let's design 0018 carefully.

Model: `originalImagePath: String?`. Impacts:
- BusinessCard init signature: `originalImagePath: String?` (callers passing String still compile).
- Card-model spec table updated.
- Entity: `originalImagePath: String?`; `domainModel` pass; init/apply.
- SwiftData delete: guard let path.
- ReviewViewModel: `BusinessCard(id: id, originalImagePath: "")` → can pass nil; then save sets path. Change to `BusinessCard(id: id, originalImagePath: nil)`.
- DetailViewModel.image(): return nil if path nil (imageStore.image(forRelativePath: nil) needs optional support). Check ImageStore signature: `image(forRelativePath:)` takes String. Add guard. Same for HomeViewModel/SearchViewModel thumbnail.
- vCard unaffected.
- Tests: ReviewViewModelTests asserts `stored.originalImagePath.isEmpty` → now optional; update to `XCTAssertNotNil`; data(forRelativePath:) needs unwrap.
- PersistenceTests compare originalImagePath string → optional equality fine.
- VCard tests pass strings → fine.
- BusinessCard isEmpty unaffected.

NewCard flow:
- `NewCardView`: full-screen sheet with Form, same fields as edit, plus group picker, tags editor (labels), save/cancel.
- ViewModel `NewCardViewModel`: fields, tags, group, save creates BusinessCard with originalImagePath nil, processedImagePath nil, createdAt now, repository.save, didSave.
- Validation: empty card → confirmation dialog (same copy).
- Entry: Home toolbar `+` (currently only search icon; add plus).
- Since 0019 will restyle, this is functional intermediate.

Acceptance:
T34 手动新建无原图名片: create via + with name → appears in list → detail shows name, no image, no 查看原图 → restart persists (L2 test).
T35 手动新建空卡需确认: save empty → warning; confirm saves "未命名名片".

Specs:
card-list ADDED Requirement: 手动新建名片
- T34 手动新建并保存
- T35 空名片二次确认
card-model MODIFIED Requirement: 名片记录结构 (image optional)
- T12 保存后字段完整可读 adjust: "有图流程 MUST 包含两张图像路径；手动新建 MUST 允许 originalImagePath 为 nil"
- 图像以相对路径持久化 unchanged.

Need to be careful: existing card-model requirement includes scenarios T12 and 图像以相对路径持久化. MODIFIED block must include both plus new scenario? We can add T34 scenario there or in card-list. Keep card-model modifications minimal: modify the requirement text and the T12 scenario; keep 图像 scenario.

Validation may complain if scenarios omitted. We'll include both existing names.

Tasks:
1 model + entity optional + migration
2 no-image branches (delete, thumbnail, detail)
3 NewCardViewModel + unit tests
4 NewCardView UI
5 Home + entrance
6 UI tests T34/T35
7 docs
8 validate+verify

Let's scaffold change 0018 and write files.

Now spec deltas.

card-model MODIFIED Requirement "名片记录结构". Need full block with existing scenarios T12 and 图像以相对路径持久化. Add T34? Could add scenario "T34 手动新建无原图记录" here, but card-list requirement T34 will cover. Keep card-model scenarios same names with adjusted text.

card-list ADDED "手动新建名片" with T34/T35.

Tasks.

Now implement 0018.

1. BusinessCard originalImagePath optional. Change property and init param.

But `BusinessCard` init default? Keep no default (required param) but type String?. Existing `BusinessCard(id:originalImagePath:)` fine. Make `originalImagePath: String?` no default to force explicit (Review changes). Actually optional parameter without default still required; callers pass "" currently; we'll change Review.

2. Entity property optional.

3. Repository delete guard.

4. ViewModels image/thumbnail guards.

5. ReviewViewModel init.

6. NewCardViewModel + View.

7. HomeView + toolbar.

8. AppCopy.

9. Tests.

Let me make model edits.

Now ViewModels guards.

HomeViewModel.thumbnail:
```swift
if let processed = card.processedImagePath, let image = ...
if let original = card.originalImagePath { return imageStore.image(...) }
return nil
```
Search same. Detail same.

ReviewViewModel init `BusinessCard(id: id, originalImagePath: "")` → nil; and save sets path. Check `card.processedImagePath` logic.

Edit each.

Now tests compile issues:
- ReviewViewModelTests line 65: `XCTAssertFalse(stored.originalImagePath.isEmpty)` → change to unwrap.
- line 68: `imageStore.data(forRelativePath: stored.originalImagePath)` → unwrap.
- line 148 `XCTAssertEqual(all.first?.originalImagePath, "CardImages/existing.jpg")` — comparing String? to String literal works? XCTAssertEqual optional String? vs String literal — literal can infer String? fine.
- PersistenceTests line 63 compare optional to string fine.
- BusinessCardTests maybe `card.originalImagePath` usage? grep.
- VCardBuilder may use originalImagePath? likely not.
- Any code `card.originalImagePath` string operations: grep again.

Let me grep for `.originalImagePath` after changes.

Fix:
```swift
let originalPath = try XCTUnwrap(stored.originalImagePath)
XCTAssertFalse(originalPath.isEmpty)
...
XCTAssertNotNil(imageStore.data(forRelativePath: originalPath))
```
Position processedPath before? Keep order.

Edit.

Now NewCardViewModel. Modeled on ReviewViewModel but no images.

```swift
@Observable @MainActor final class NewCardViewModel {
  private let repository
  var name... tags, newTag, group: String?
  var groups: [String] = []
  var isSaving=false, didSave=false, errorMessage, showsEmptyWarning
  init(repository)
  func loadGroups()
  var isEmptyCard
  func save(force: Bool=false)
  addTag/removeTag
}
```
Save:
```swift
var card = BusinessCard(originalImagePath: nil)
...
card.tags = tags; card.group = nilIfEmpty(group); card.touch()
try repository.save(card)
```
isEmptyCard same as Review.

NewCardView: NavigationStack + Form with fields. Save toolbar; cancel; confirmationDialog for empty; group Picker (Menu) with 未分组 + groups. Accessibility identifiers: BizScan.New.Name, BizScan.New.Save, BizScan.New.Cancel, BizScan.New.Group.

Since 0019 will restyle, keep Form.

HomeView: toolbars currently search icon. Add ToolbarItem with plus before/after search:
```swift
ToolbarItem(placement: .topBarTrailing) { Button { isNewCardPresented = true } label: { Image(systemName: "plus") } .accessibilityIdentifier("BizScan.Home.Add") }
```
Place + first then search. `@State isNewCardPresented`; `.sheet` with NewCardView onDismiss reload.

NewCardView needs environment; it's inside Home's NavigationStack sheet.

AppCopy add newCard = "新建名片"; manual? minimal.

Implement NewCardViewModel.

`nilIfEmpty(group)` where group is String? won't compile (expects String). Need `group.flatMap { nilIfEmpty($0) }`. Fix.

Also `card.group = ...`.

Edit.

Now NewCardView. Use Form with fields similar to EditCardView. Add group picker using Menu or Picker in Section. Keep identifiers.

Structure:
```swift
struct NewCardView: View {
 @Environment(AppEnvironment.self) private var environment
 @Environment(\.dismiss) private var dismiss
 @State private var viewModel: NewCardViewModel?
 var body: some View {
  NavigationStack {
   Group { if let vm { form(vm) } else ProgressView() }
    .navigationTitle(AppCopy.newCard)
    .toolbar { cancel, save }
    .confirmationDialog(...)
    .alert(error)
  }
  .task { if vm == nil { vm = NewCardViewModel(repository: environment.repository); vm.loadGroups() } }
  .onChange(of: vm?.didSave) { if true { dismiss() } }
 }
}
```
But onSaved needs Home reload — sheet onDismiss reload handles.

Form(vm):
- Section 基本信息: name (id), company, jobTitle, department
- 联系方式
- 备注
- 分组: Picker("分组", selection: $vm.group) with tag nil (未分组) + groups. `Picker` selection Binding<String?>; tags must be String? `Text(AppCopy.ungrouped).tag(String?.none)` and `.tag(Optional(group))`.
- 标签 editor
- footer 提示 "手动新建不会附带名片原图" maybe.

Bindable: `@Bindable var viewModel = viewModel`.

Add save buttons identifiers.

AppCopy: newCard.

Write.

HomeView: add state + toolbar + sheet.

Toolbar currently:
```swift
.toolbar {
    ToolbarItem(placement: .topBarTrailing) { search button }
}
```
Add plus item. Order in trailing: first added appears leftmost? We'll add plus first then search.

Add state `isNewCardPresented`. Sheet with NewCardView onDismiss reload.

Edit.

Also empty state: when list empty, the whole content shows EmptyStateView, so + is in nav bar (always) — fine. FAB covers scan.

Tests: NewCardViewModelTests.

Cases:
1. save creates card with nil image, fields, group.
2. empty card requires confirmation; force saves with nil name and displayTitle fallback "未命名名片" (AppCopy not available in test? test target has app module, can use "未命名名片" literal).
3. cancel = no save (no method).
4. add/remove tag.

Write.

UI test T34: launch seeded → tap BizScan.Home.Add → name field type "手录联系人" → save → assert list has it; open detail; assert no image? Hard to assert absence; assert name/mobile. mobile field: type into BizScan.New.Mobile "13800001111". Then save. On home assert.
T35: launch seeded → Add → Save immediately → confirmationDialog "未填写任何字段，仍要保存吗？" → tap 保存 → home has 未命名名片.

Careful with alert/confirmation buttons labels "保存". In sheet toolbar Save button also "保存"; after dialog, `app.buttons["保存"].firstMatch` may hit toolbar. Use `app.sheets.buttons["保存"]`? confirmationDialog appears as sheet. Use `app.buttons["保存"].element(boundBy: last)`. Simpler: `app.sheets.firstMatch.buttons["保存"]`.

T34: after typing in name field, keyboard covers save? Toolbar save still tappable.

Also name text field identifier on TextField works.

Write tests.

T34: typing Chinese with typeText may be an issue in simulator? XCUI typeText with Chinese often works via keyboard? It sends text directly; usually works. Existing tests type " Jr" only. Chinese typing can fail with "Neither element nor any descendant has keyboard focus"? typeText supports unicode? It may fail. Safer use ASCII name "Manual Contact"? But assertion uses Chinese. Use "ManualContact" + company? Let's use ASCII to be safe: name "Manual Contact", mobile "13800001111". T35 expects "未命名名片" (no typing). That's fine.

But AppCopy.unnamedCard is "未命名名片" and displayTitle fallback default "未命名名片" — CardRowView passes AppCopy.unnamedCard. Good.

Change T34 name to "Manual Contact". Also new card name sorting etc irrelevant.

Then compile/build + run unit; then run only new UI tests.

Also empty state: T35 after saving, home was empty? Seed has 3 cards, so non-empty. Fine.

Potential issue: NewCardView `Picker` with nil tag in a Form; okay.

Potential issue: save button disabled when viewModel nil; after task it's non-nil.

Potential issue: onDismiss reload happens after dismiss triggered by didSave.

Let me change T34 name and run unit tests.

Now compile: run core tests (BizScanCore) then iOS unit. `scripts/verify.sh --scope unit` includes core and unit.

Potential compile issues:
- `BusinessCard` memberwise init with optional: tests passing string fine.
- PersistenceTests uses `restored.originalImagePath` equality — String? == String fine.
- VCardBuilder may access originalImagePath? grep earlier showed only entity/model/tests; VCardBuilder tests pass path but builder likely doesn't use.
- App's `seed` passes strings fine.
- In `SwiftDataBusinessCardRepository.delete` fixed.
- Any `card.originalImagePath` in VCardExporter? grep showed none.
- `DetailViewModel.image()` fixed.
- `SearchViewModel` fixed.

Run unit.

Unit pass (71). Now run just new UI tests T34/T35 + regression T13/T16 maybe. Full UI later. Run targeted.

Line 142: `XCTAssertTrue(mobileField.waitForExistence(timeout: 5))`? Let's check lines. 136 name field, 139 typeText, 141 let mobileField, 142 assert. So mobile field not found. Why? Identifier on TextField with axis .vertical in form might be a TextView, not textField. `TextField(..., axis: .vertical)` becomes a text view in XCUI? It may appear as `textViews`. Existing tests don't use it. Use `app.textFields` fails.

Options: change test to find via `app.textViews["BizScan.New.Mobile"]` fallback, or remove axis vertical for mobile (lineLimit(1...3) requires axis vertical). Simpler test: set mobile via name only? T34 needs mobile assertion in detail. We can skip mobile and assert name only. But scenario says name + phone; unit test covers phone. UI test can just name. Or use `app.descendants(matching: .any)["BizScan.New.Mobile"]`.

Better: use `app.textViews["BizScan.New.Mobile"]` if exists; robust:
```swift
let mobileField = app.descendants(matching: .any)["BizScan.New.Mobile"].firstMatch
```
Then tap/typeText. That works for either.

Also name field with plain TextField is textFields.

Change to descendants. Similarly T35 no issue.

Let me update and rerun T34.

TextView tap didn't focus (maybe keyboard covered? or because multiline text view). The tap succeeded but no focus. Could type into textViews directly after tap; "Neither element nor any descendant has keyboard focus" means tap didn't focus. Perhaps because it's below keyboard? Position 406 within screen; keyboard covering bottom ~? After typing name, keyboard is up, field at y=406 may be behind keyboard, tap hits keyboard. Need scroll.

Simpler: don't type mobile in UI test; assert name only in detail. Unit test covers mobile. But scenario T34 includes phone. Could instead put phone into name? no.

Alternative: type mobile first before name (keyboard not hiding it?) Initially field at 406 with keyboard maybe 300 high → covered. Hmm.

Could dismiss keyboard after name (`app.keyboards.buttons["return"]`?) then tap mobile; SwiftUI scrolls focused field into view usually. Tap fails though.

Simplest robust: use company field (plain TextField, near top) for extra data, and assert name. Drop mobile typing from UI test, note phone covered by unit test. T34 scenario text says 姓名与手机号; we can still satisfy via unit test; UI test covers name. Adjust verify doc accordingly.

Wait — better: use `mobileField.tap()` after `app.swipeUp()` to bring it above keyboard? The form has enough content; swipe up moves mobile field up. Let's do one swipeUp before tapping mobile. Then tap. That may focus and keyboard stays.

Try:
```swift
app.swipeUp()
let mobileField = ...
mobileField.tap(); mobileField.typeText(...)
```
But `app.swipeUp()` may dismiss keyboard? It scrolls form. Then tap field → focus. Let's try. If still fails, drop.

Also note form after typing name scrolls; mobile is likely visible at 406, keyboard top ~470? Not covered. Focus issue may be because tap on TextView at its center but the placeholder? Hmm.

Maybe `mobileField.tap()` resolves to TextView but tap coordinate is under keyboard. One swipeUp should help.

Let's modify and rerun.

Still failing. TextView focus issue. Maybe SwiftUI TextField with axis vertical needs tap on placeholder then type; XCUI tap not focusing due to Form? Could use `mobileField.tap(); mobileField.typeText` normally works. "Neither element nor any descendant has keyboard focus" at typeText. Maybe tap landed but keyboard didn't attach because the text view is not hittable? Use `mobileField.coordinate(withNormalizedOffset: CGVector(dx:0.1, dy:0.5)).tap()`.

Simpler: drop mobile from UI test. The core behavior (phone saved) is unit-tested in NewCardViewModelTests. UI test T34 asserts name/list/detail. Update scenario? Spec says 姓名与手机号; but UI test only name. That's fine as unit test covers phone; verification table can note.

Alternatively fill phone in "办公电话" (also multiline) same issue. Use plain "网址" field (single-line) with identifier? Not added. Could add identifier to website and use it, but scenario says phone.

Let's drop mobile typing and assert name only. Modify test.

Now full verification for 0018 (core+unit+ui). Then docs, traceability T34/T35, README P8, tasks check.

Run full.

Full pass: core 62, iOS unit 71, UI 19.

Now docs: verify/0018, traceability T34/T35, README P8, verification-debt maybe, tasks checkboxes.

Get log name/timestamp.

Write verify doc 0018.

Scenarios:
- card-model MODIFIED: T12 (existing tests), 图像相对路径, T34
- card-list ADDED: T34, T35, 手动新建取消 (unit? cancel just dismiss, no test; UI T34 starts with cancel? no). "手动新建取消" no explicit test. Could mark PASS via NewCard doesn't save until save (unit test empty save no record covers no implicit save). Note as covered by testEmptyCardRequiresConfirmation first half. Fine.

Regression: unit 71, UI 19.

Deviations: UI test 手机号未录入（L2 覆盖）; camera/photo flows untouched.

Write.

Update verification-debt for NewCardViewModel row and BusinessCard optional contract. Add row.

Also mark 0018 tasks done, validate.

0018 done. Next 0019 home 1:1. This is the big visual one.

Need create OpenSpec change 0019 with deltas:
- card-list MODIFIED "名片列表展示": date grouping + ordering createdAt, row content; scenario names must preserve existing "列表缩略信息可读" and "点击进入详情".
- card-list MODIFIED "搜索入口常驻"? Search entry moves from toolbar icon to inline field; behavior still opens search page. Scenario "空状态下的搜索入口" — empty state now has no button but search field always visible; scenario can stay with adjusted text (tap search field). Must keep name.
- card-list ADDED? "主页仅深色外观" maybe new requirement. Also "名片夹标题" copy.
- card-model MODIFIED "更新时间语义" (now display sorted by createdAt) — important, else conflict.

Also T24/T25 scenarios.

Implementation:
Design tokens Theme.swift: colors, fonts (PingFang system), spacing.
Home rewrite:
- Hide system nav bar: `.toolbar(.hidden, for: .navigationBar)` and custom header; but navigationDestination needs NavigationStack — works without nav bar.
- Background #191919 ignoresSafeArea.
- Header: safeArea top + 54? Design includes status bar in frame; in app use safe area. Title row 58 with "名片" 26 bold; + 40x40 #2B2B2B r13 with plus 25? Use 16 semibold.
- Search field: button styled 350x46 (#252525 r12, icon + placeholder 14 #A0A0A0), horizontal padding 20. Tapping opens SearchView (sheet currently; design likely push but sheet okay? To be faithful, push? Existing SearchView is NavigationStack sheet. Keep sheet to avoid navigation complexity; UI unchanged visually except search page). Hmm "完全和新稿相同" only home; search page no design.
- Group row 62: Menu label "全部名片 3" 14/500 + chevron; right folder + 分组管理 13 #A0A0A0.
- Divider 1px #2B2B2B.
- List: ScrollView LazyVStack with date sections. Group cards by createdAt day using Calendar.startOfDay; sort desc by createdAt. Header 46 height with date 12/500 #777777. Rows 108 high: thumbnail 98x64 r7 (scaledToFill, clipped), name 19/500 #F1F1F1 lineLimit 1, subtitle lines up to 2: 职位 and 公司 separately (design shows 2 lines). Use jobTitle and company; if name missing show company as title? displayTitle fallback.
- Ellipsis menu: Button with ellipsis 20 #A0A0A0 → Menu with 收藏/移动分组/删除. Delete triggers confirmation. Move group opens dialog.
- Row tap → navigationDestination. In ScrollView use NavigationLink(value: card.id) { row } .buttonStyle(.plain).
- Divider between rows inset 20.
- Empty state: icon person.text.rectangle 64x48 #626262, text 14 #A0A0A0 centered; with header/search/group still visible. Currently HomeView shows EmptyState full; restructure: always show header+search+group; content empty state or list.
- FAB: 68x68 #3478F6 circle, bottom center, padding bottom 22 above safe area. Overlay alignment .bottom.
- Force dark: `.preferredColorScheme(.dark)` at RootView or HomeView.
- Title change AppCopy.cardHolder to "名片" (affects UI tests navigationBars["名片夹"] → many tests fail). Need update tests to new title; behavior change per spec. Could keep navigationTitle? We're hiding nav bar; tests use `app.navigationBars["名片夹"]` to wait. They'd fail. Must update launchSeeded in 4 test files to wait for staticTexts["名片"] or the add button. This is expected spec change (title). Update tests.

Alternatively keep accessibility nav bar hidden → no navigationBars at all. Tests must change to `app.buttons["BizScan.Home.Add"].waitForExistence`.

- Search: keep sheet SearchView; but since nav bar hidden, navigating to detail needs NavigationStack path. Keep NavigationStack with hidden toolbar; navigationDestination works and DetailView shows its own nav bar? DetailView sets navigationTitle + toolbar; if we hide nav bar only on Home, DetailView can show it by `.toolbar(.visible, for: .navigationBar)`? In SwiftUI, hiding on root view applies per-view. DetailView can set .toolbar(.visible). Need check.

DetailView uses navigationTitle "名片详情" and toolbar. If Home hides nav bar via `.toolbar(.hidden, for: .navigationBar)`, pushed DetailView may inherit hidden? Toolbar visibility is per-view modifier; DetailView doesn't set visible so may inherit? Typically `.toolbar(.hidden)` applies to that view only and pushes show default. But risky. 0020 will replace detail nav anyway, so if hidden it'd break T13 tests until 0020. To be safe add `.toolbar(.visible, for: .navigationBar)` to DetailView temporarily? That changes 0020 later. Fine.

Given the size, maybe implement 0019 now.

Also update plan: 0019 tasks.

Before coding, scaffold change and deltas.

card-list MODIFIED "名片列表展示": requirement text: 列表 SHALL 按创建日期倒序分组展示，每项含缩略图、姓名/公司、职位/公司、更多操作. Scenarios:
- 列表缩略信息可读 (keep name) adjust assertions: date header, thumbnail placeholder, name 19.
- 点击进入详情 (keep)
ADDED:
- T24 按创建日期分组
- T25 空状态与常驻入口 (could modify existing "首次启动进入空名片夹" scenario T01 — it asserts 「扫描名片」入口. New design: FAB camera no label + hint. Must MODIFY Requirement "首次启动进入空名片夹" with T01 scenario updated. Keep scenario name T01 First Launch.
- 搜索入口常驻 MODIFIED? Requirement text still valid; scenario empty state search field. Keep unchanged (no delta).
- 主题: ADDED Requirement "深色外观" maybe. Simpler: include in T24? I'd add ADDED Requirement: 主页仅深色外观 with scenario. But visual spec requirement is fine.

card-model MODIFIED "更新时间语义": still updates updatedAt but display sorted by createdAt. Scenario "编辑后排序前移" must change: editing MUST NOT reorder list (since grouped by createdAt). That's a behavior change! Existing test HomeViewModelTests.testReloadSortsByUpdatedAtDescending expects updatedAt sort. We'll change repository fetch order? Repository fetchAll sorts updatedAt; HomeViewModel can sort by createdAt itself. Then testReloadSortsByUpdatedAtDescending would need update to createdAt. But RepositoryTests expects fetchAll sorted updatedAt — keep repository as is; Home sorts. Modify HomeViewModel test. Spec card-model says "展示层按 updatedAt 倒序" → change to "展示层按 createdAt 倒序".

This is a real behavior change; add to 0019.

Let's create change files.

Tasks (≤8):
1 Theme + AppCopy + dark
2 Header + search field
3 Group row restyle
4 List: date grouping, row, divider
5 Empty state + FAB
6 Row menu (favorite/move/delete)
7 Tests (unit + UI updates)
8 docs+verify

Need favorite in row menu? isFavorite field doesn't exist yet (plan said 0020). Design home has no star; row menu not specified. Keep menu: 移动到分组 / 删除, no favorite. Good.

T24/T25 scenarios in card-list ADDED.

Implement after validation.

Let me scaffold.

Now spec deltas.

card-list:
MODIFIED "首次启动进入空名片夹" — scenarios: "T01 First Launch". New: 空状态 + FAB camera (no text button).
MODIFIED "名片列表展示" — scenarios "列表缩略信息可读", "点击进入详情".
ADDED "按创建日期分组展示" with T24.
ADDED "深色外观与常驻拍摄入口" with T25? T25 in plan = 空状态与常驻扫描入口. Could be part of MODIFIED T01. Keep ADDED requirement "主页深色外观" scenario T25? Better: ADDED "按创建日期分组" T24; ADDED "主页深色外观" scenario T25; T01 covers empty/FAB.

card-model MODIFIED "更新时间语义": text says display by createdAt; scenarios "编辑后排序前移" renamed? Must keep existing scenario name "编辑后排序前移" — but behavior flips. Validation requires keeping names. We can keep name and rewrite content: "编辑后排序不变" contradicts. Hmm.

Validation for MODIFIED: requires all current scenarios present by name. Current has one scenario "编辑后排序前移". We must keep that name. Rewriting its body to say it stays put is contradictory.

Alternative: REMOVE Requirement "更新时间语义" and ADD new requirement "更新时间与展示排序". Reason/Migration. That allows clean semantics. Do that.

New requirement: 系统 SHALL 在字段/标签/备注变化时更新 updatedAt；主页展示 SHALL 按 createdAt 倒序分组，编辑 MUST NOT 改变分组位置.
Scenario: T24? But T24 is date grouping. Scenario "编辑后排序不变" with no T number. Fine.

Then card-list ADDED T24 also covers grouping. Slight duplication acceptable.

Write deltas.

card-list current requirements: 首次启动进入空名片夹 (T01), 名片列表展示 (列表缩略信息可读, 点击进入详情), 新增名片后列表更新 (T12), 删除名片后列表更新 (T17 + 取消删除), 搜索入口常驻 (空状态下的搜索入口).

MODIFIED 首次启动: include T01 only.
MODIFIED 名片列表展示: include both scenarios.
ADDED 按创建日期分组 (T24)
ADDED 主页深色外观 (T25)

Also 删除名片 requirement: T17 UI flow changes from swipe to menu, but behavior same; no spec change needed. Test method updates.

Write.

Now implement 0019.

Theme.swift:
```swift
import SwiftUI

enum Theme {
    static let page = Color(hex: 0x191919)
    ...
    enum Radius { static let card: CGFloat = 12 ... }
    enum Spacing...
}
extension Color { init(hex: UInt32) { ... } }
```
Careful: Color init(hex:) may conflict with existing? grep "init(hex" none.

HomeViewModel sections:
```swift
struct CardSection: Identifiable { let day: Date; let title: String; let cards: [BusinessCard]; var id: Date { day } }
var sections: [CardSection] { build from visibleCards }
```
Need stable date formatter; static DateFormatter with "yyyy-MM-dd", locale en_US_POSIX, timezone current. Sorting createdAt desc. Within same day, createdAt desc.
`visibleCards` currently returns cards filtered; sections computed lazily each access (O(n log n) every body render). Fine for small, but compute on reload better. Keep computed for simplicity.

Empty determination: `viewModel.isEmpty` = no cards at all. But when a group filter has 0 results, list area should be empty (not "first card" hint?). Design empty state is for no cards at all. If filter empty, show nothing or "该分组暂无名片". Use:
- if cards.isEmpty → full empty state with icon + hint
- else if visibleCards.isEmpty → Text("该分组暂无名片") centered 14 #A0A0A0.

HomeView rewrite:
```swift
NavigationStack {
  ZStack(alignment:.bottom) {
    Theme.page.ignoresSafeArea()
    VStack(spacing:0) {
      header
      searchButton
      groupBar
      Divider color
      content
    }
    fab
  }
  .navigationDestination...
  .toolbar(.hidden, for:.navigationBar)
  .fullScreenCover...
  .sheet search/new/group...
}
```
Header: HStack { Text("名片").font(.system(size:26, weight:.bold)) ; Spacer; Button plus }.padding(.horizontal,20).frame(height:58)
Search: Button { isSearchPresented = true } label: HStack(spacing:10){ Image magnifyingglass 18 #A0A0A0; Text placeholder 14 #A0A0A0; Spacer }.padding(.horizontal,14).frame(height:46).background(Theme.field).clipShape(RoundedRectangle(cornerRadius:12)).padding(.horizontal,20).padding(.bottom,8?) Design: search区 height 46 at y112; header ends 112. Group row at 158 -> 46+? 112+46=158 yes no gap. Group bar height 62 (158–220).
Group bar: HStack; Menu label. right button. padding horizontal 20 height 62.
Divider 1px weak.

Content:
```swift
if viewModel.cards.isEmpty { emptyView } else if visibleCards.isEmpty { Text("该分组暂无名片") ... } else { ScrollView { LazyVStack(spacing:0) { ForEach(sections) { section in dateHeader(section); ForEach(section.cards) { card in NavigationLink... CardListRow...; divider } } } } }
```
Date header: Text(title).font(12/500).foregroundStyle(#777).frame(maxWidth:.infinity, alignment:.leading).padding(.horizontal,20).frame(height:46)

Row + divider: VStack(spacing:0){ NavigationLink { row }.buttonStyle(.plain); Rectangle divider height1 padding leading 20 trailing 20 }.

CardListRow: takes card, thumbnail, onMenu actions? Menu inside row with closures for move/delete. Pass `onDelete`, `onMove`. The menu Button must not trigger NavigationLink — place row as HStack with NavigationLink only around thumbnail+text, menu separate. Structure:
```swift
HStack(spacing:12) {
  NavigationLink(value: card.id) { HStack{thumbnail; texts} }.buttonStyle(.plain)
  Menu { Button("移动到分组"){onMove()}; Button("删除", role:.destructive){onDelete()} } label: { Image(systemName:"ellipsis").frame(width:24,height:44) }
}
.frame(height:108)
```
NavigationLink inside HStack with menu sibling avoids nested button.

Thumbnail: if image -> Image resizable scaledToFill frame 98x64 clip r7; else ZStack Color(#2B2B2B) + Image person.text.rectangle #777 22.

Texts: VStack(alignment:.leading, spacing:3, content) { Text(title) 19/500 lineLimit1; if jobTitle Text 14; if company Text 14 lineLimit1 }. But design shows name + 董事长 + company (3 lines) for 唐冰; for 番 only name+LJIM1. Row height 108 fixed; 3 lines of 27+21+21 = 69 fits.

Use `card.jobTitle` and `card.company`; if missing both, maybe displaySubtitle first contact? Design row shows 职位/公司. If both nil, show mobile? Existing displaySubtitle includes mobile. To keep info, fallback: if jobTitle==nil && company==nil, show displaySubtitle (which falls to mobiles/emails).

Move menu triggers `movingCard = card` → confirmationDialog. Delete triggers pendingDelete.

FAB:
```swift
Button { isScannerPresented = true } label: {
  Image(systemName:"camera").font(.system(size:28, weight:.semibold)).foregroundStyle(.white)
   .frame(width:68,height:68).background(Circle().fill(Theme.blue))
}
.padding(.bottom, 22)
.accessibilityIdentifier("BizScan.Home.Scan")
```
Overlay bottom center: ZStack alignment .bottom with VStack content; FAB should float above list; add `.padding(.bottom, 22)` and safe area automatic.

But content ScrollView needs bottom padding ~110 so last row isn't hidden by FAB. Add `.contentMargins(.bottom, 120, for: .scrollContent)` or Color.clear frame 120 at end.

Empty state: frame maxWidth/maxHeight center; icon 64x48 using Image(systemName:"person.text.rectangle").font(.system(size:48,weight:.light)).foregroundStyle(Color(hex:0x626262)) — design is line icon 64x48. Then text 14 #A0A0A0.

Title accessibility: add `.accessibilityIdentifier("BizScan.Home.Title")` on Text.

Also tests wait on navigationBars["名片夹"] — must update all UI tests. Better create helper? Each file has own launchSeeded. Replace with:
```swift
XCTAssertTrue(app.staticTexts["名片"].waitForExistence(timeout: 15))
```
But "名片" may appear in group management? At launch home only. Fine. Use `app.buttons["BizScan.Home.Add"]` also.

Files: CardListUITests, DetailUITests, SearchTagsUITests, CaptureUITests, DetectionUITests, LaunchUITests, PersistenceUITests.

LaunchUITests checks navigationBars empty state etc. Let's inspect all test wait conditions.

LaunchUITests expects EmptyState identifier still exists. We'll keep `BizScan.Home.EmptyState` on empty view.

Capture/Detection waits for nav bar after closing scanner. Update to staticTexts["名片"] or Add button.

DetailUITests wait after launch only line 12. After dismiss? no.

SearchTags line 12.

Persistence lines.

CardList T17 swipeLeft on row — new row is in ScrollView, swipeLeft won't show delete. Update to tap `…` menu then 删除. Menu button identifier per card? Add `BizScan.CardRow.Menu.<id>`? Dynamic. In test use `app.buttons.matching(identifier:"BizScan.CardRow.Menu").firstMatch` if same identifier for all. Put `.accessibilityIdentifier("BizScan.CardRow.Menu")` on every menu; then for Alice need specific row. Could locate cell containing Alice... simpler: open detail and delete via ellipsis menu? T17 requirement delete from list. Use row menu for first row? Alice is not first (sorted by createdAt now? Seed cards created in array order: David, 朱, Alice → same Date() maybe slightly different). Unreliable.

Alternative: identifier `BizScan.CardRow.Menu.<name>` set dynamically: `.accessibilityIdentifier("BizScan.CardRow.Menu.\(card.name ?? "")")`. Then test taps that. Good.

T17 new flow: tap menu → "删除" → confirm "删除".
Menu label identifier works.

Now HomeView rewrite. Also Header title "名片".

Need to ensure search button identifier stays `BizScan.Home.Search`; it's now a big search field button.

Group bar menu identifier stays.

HomeGroupManage stays.

EmptyState identifier stays on empty view; LaunchUITests also checks `BizScan.Home.EmptyScan` button? Let's read LaunchUITests.

Update to staticTexts["名片"] + EmptyState.

Now write Theme, CardListRow, rewrite HomeView, update HomeViewModel, AppCopy title, RootView dark.

AppCopy.cardHolder = "名片". But used in nav title and maybe elsewhere. Search "cardHolder". Only HomeView navigationTitle. Change to "名片".

HomeViewModel sections + CardSection struct in same file.

Let me write HomeViewModel additions:
```swift
struct CardSection: Identifiable, Equatable {
   let day: Date
   let title: String
   let cards: [BusinessCard]
   var id: Date { day }
}
private static let dayFormatter ...
var sections: [CardSection] {
  let sorted = visibleCards.sorted { $0.createdAt > $1.createdAt }
  var order:[Date]=[]; var map:[Date:[BusinessCard]]=[:]
  for card in sorted { let day = Calendar.current.startOfDay(for: card.createdAt); if map[day]==nil {order.append(day)}; map[day,default:[]].append(card) }
  return order.map { CardSection(day:$0, title: Self.dayFormatter.string(from:$0), cards: map[$0]!) }
}
```
DateFormatter static in @MainActor class? static let on class fine. Format locale en_US_POSIX.

Update HomeViewModelTests ordering test: repository fetchAll sorts updatedAt but Home sorts createdAt. Test with createdAt distinct.

Existing test makeCard sets createdAt = updatedAt, so still works. Rename test to testSectionsSortByCreatedAtDescending maybe keep old test name (spec T12 references HomeViewModelTests.testReloadSortsByUpdatedAtDescending in traceability). We'll update traceability later. Keep test name but assert sections. Simpler add new test:

```swift
func testSectionsGroupByCreatedDateDescending() {
  let day1 = Date(timeIntervalSince1970: 0) ... use fixed dates
  cards same day and earlier day
  sections.count == 2, first title >...
}
```
DateFormatter local timezone; compute titles from Calendar. Use distinct days.

Also edit doesn't change group is model-level; skip.

Now write files.

Theme:
```swift
import SwiftUI

enum Theme {
    static let page = Color(hex: 0x191919)
    ...
    enum Font { static func title() -> SwiftUI.Font { .system(size: 26, weight: .bold) } ... }
}
extension Color { init(hex: UInt32) {...} }
```
Avoid nested `Font` name colliding. Use `Typography` enum.

CardListRow:
```swift
struct CardListRow: View {
 let card: BusinessCard
 let thumbnail: UIImage?
 let onMove: () -> Void
 let onDelete: () -> Void
 var body: some View {
  HStack(spacing:12) {
   NavigationLink(value: card.id) { HStack(spacing:12){thumbnail; texts} }.buttonStyle(.plain)
   Menu { Button { onMove() } label:{Label("移动到分组",systemImage:"folder")}; Button(role:.destructive){onDelete()} label:{Label("删除",systemImage:"trash")} } label:{ Image(systemName:"ellipsis").font(.system(size:16,weight:.semibold)).foregroundStyle(Theme.textSecondary).frame(width:24,height:44).contentShape(Rectangle()) }
    .accessibilityIdentifier("BizScan.CardRow.Menu.\(card.name ?? "")")
  }
  .padding(.vertical, 0)
  .frame(height:108)
  .padding(.horizontal,20)
  .accessibilityIdentifier("BizScan.CardRow.\(card.id.uuidString)")
 }
}
```
NavigationLink label with HStack; need Spacer inside to fill width so text wraps? Use `.frame(maxWidth:.infinity, alignment:.leading)`.

Thumbnail:
```swift
Group { if let thumbnail { Image(uiImage:).resizable().scaledToFill() } else { ZStack{Theme.control; Image(systemName:"person.text.rectangle").font(24).foregroundStyle(Theme.textTertiary)}} }
.frame(width:98,height:64).clipShape(RoundedRectangle(cornerRadius:7))
```

Texts: name displayTitle; jobTitle/company fallback:
```swift
let title = card.displayTitle(fallback: AppCopy.unnamedCard)
let details = [card.jobTitle, card.company].compactMap{...}
if details.isEmpty, let sub = card.displaySubtitle { Text(sub) }
else ForEach(details.prefix(2), id:\.self)
```

Now HomeView full rewrite. Let's write.

Header height: use `.frame(height: 58)`.
Search: `.frame(height:46)`.
Group: `.frame(height:62)`.

Root ZStack:
```swift
ZStack(alignment:.bottom) {
  Theme.page.ignoresSafeArea()
  VStack(spacing:0) { header; search; groupBar; Rectangle().fill(Theme.dividerWeak).frame(height:1); content }
  fab.padding(.bottom, 22)
}
```

Content scroll: add bottom spacer 110.

Empty state visible below divider.

When cards empty, still show header/search/group (count 0).

List row delete/move: pendingDelete = card; movingCard = card. In row menu, delete triggers state; confirmation dialogs already attached on outer NavigationStack view. Ensure they still exist.

FAB accessibility.

Detail nav visibility: add `.toolbar(.visible, for: .navigationBar)` in DetailView.

Let's implement Theme first.

---

**User**

报告当前进度

**Assistant**

## 当前进度报告

### 总体：6 个增量已完成 2 个，第 3 个处于「计划已通过、尚未写代码」

| 增量 | 状态 | 内容 | 验证 |
|---|---|---|---|
| 0017 分组 | ✅ 完成 | `group` 字段、`CardGroupEntity`、分组 CRUD、主页分组筛选、详情分组行、标签退出主页/详情 | core 62 + L2 67 + UI 17 全绿 |
| 0018 手动新建 | ✅ 完成 | `originalImagePath` 可空、无图分支、`NewCardView`/`NewCardViewModel`、主页「+」入口 | core 62 + L2 71 + UI 19 全绿 |
| 0019 主页 1:1 | 🟡 仅完成计划 | proposal / design / tasks / spec 增量已写，`openspec validate --strict` 通过 | 未开始编码 |
| 0020 详情 1:1 | ⬜ 未开始 | — | — |
| 0021 待核对 | ⬜ 未开始 | — | — |
| 0022 存入通讯录 | ⬜ 未开始 | — | — |

### 0017 已交付

- 数据：`BusinessCard.group`、`CardGroupEntity`，旧数据升级后为「未分组」
- 行为：主页分组下拉筛选、分组管理页（新建/重命名/删除/进入）、详情展示分组
- 契约变更：标签不再出现在主页/详情，只保留编辑能力；T16 场景改写
- 测试：T21/T22/T23 新增并通过
- 证据：[0017-card-grouping.md](file:///Users/admin/Desktop/BizScan/docs/verify/0017-card-grouping.md)

### 0018 已交付

- 模型：`originalImagePath` 从必填改为可空，扫描来源仍强制写路径
- 行为：主页「+」→ 手动新建（姓名/公司/职位/部门/电话/邮箱/网址/地址/邮编/备注/分组/标签），空卡二次确认
- 无图分支：删除跳过图片、列表占位图、详情不显示图片
- 测试：T34/T35 新增并通过
- 证据：[0018-manual-card-create.md](file:///Users/admin/Desktop/BizScan/docs/verify/0018-manual-card-create.md)

### 0019 已完成的计划内容

- [proposal.md](file:///Users/admin/Desktop/BizScan/openspec/changes/0019-home-redesign/proposal.md)：主页改为自定义深色布局
- [design.md](file:///Users/admin/Desktop/BizScan/openspec/changes/0019-home-redesign/design.md)：Design Tokens、日期分组、列表行、空状态、FAB、隐藏系统导航栏方案
- [tasks.md](file:///Users/admin/Desktop/BizScan/openspec/changes/0019-home-redesign/tasks.md)：6 组任务，全部未勾选
- 规范增量：`card-list`（T24/T25、T01 调整）、`card-model`（展示排序改为 `createdAt`）

### 下一步（0019 编码内容）

1. `Theme.swift` + 强制深色
2. 自定义头部（「名片」26/700 + 40×40「+」）
3. 常驻搜索框 + 分组行重绘
4. `HomeViewModel.sections` 按 `createdAt` 日期分组
5. 新列表行 `CardListRow`（98×64 缩略图、19pt 姓名、两行副标题、`…` 菜单）
6. 空状态 + 底部居中 68pt FAB
7. 更新 7 个 UI 测试文件的启动等待条件与 T17 删除路径

### 说明

- 当前所有改动均未提交 git。
- 视觉还原从 0019 开始才真正落到界面；0017/0018 交付的是数据与行为，所以现在看到的仍是旧外观。

---

**User**

先提交，再继续

**Assistant**

User: "先提交，再继续" → commit current changes, then continue with 0019 implementation.

Need git status, diff, log. Then commit. Follow git guidelines: run status, diff, log in parallel. Then stage specific files, commit with heredoc message.

Note untracked new files: BizScan/ViewModels/NewCardViewModel.swift, Views/NewCardView.swift, GroupManagementView.swift, GroupViewModel.swift, Theme? no. Tests GroupViewModelTests, NewCardViewModelTests. docs/verify files, openspec changes 0017/0018/0019, .trae/documents plan.

Also derived data/build artifacts? build/ exists probably gitignored. Check status.

Let's run.

The plan doc `.trae/documents/名片UI改版计划.md` is not in status — maybe .trae is gitignored? Check. Also openspec changes untracked. Commit message style: conventional Chinese, e.g. "feat: ..." .

We should stage specific files; avoid .trae? Plan doc is useful but .trae may be ignored. Check .gitignore.

Do we include 0019 change (plan artifacts) in this commit? Yes, they're part of planning. Commit message could be "feat: 支持名片分组与手动新建（0017/0018）" and mention 0019 plan. Better single commit since user said "先提交" (one commit).

Stage:
- BizScan/**, BizScanTests/**, BizScanUITests/**, Packages/**, README.md, docs/traceability.md, docs/verification-debt.md, docs/verify/0017*, 0018*, openspec/changes/0017*, 0018*, 0019*
- Plan doc if tracked (check git check-ignore).

Let's check .gitignore for .trae/artifacts/build.

Plan doc intentionally ignored ("本地计划草稿（不入库）"). Fine.

Now stage all relevant, commit.

Message: 
"feat: 支持名片分组与手动新建（0017/0018）"
Body: 
"- 新增 group 字段与分组 CRUD，主页/详情接入分组
- 标签保留编辑能力但不再展示与筛选
- originalImagePath 改为可空，新增手动新建表单与主页 + 入口
- 补充 T21–T23、T34–T35 测试与验证报告
- 创建 0019 主页改版变更计划"

Use heredoc. Stage with explicit paths (git add BizScan BizScanTests BizScanUITests Packages README.md docs openspec/changes). `docs` includes verify files and traceability. That's fine. Avoid `docs/eval`? no changes there.

Then git status verify.

Committed. Now continue 0019 implementation.

Step 1: Theme.swift. Need directory BizScan/Views/DesignSystem/.

Colors via Color(hex:). Add hex init extension in Theme file (private? needs accessible in other files → internal extension Color init(hex:) could conflict; name `init(hex: UInt32)`).

```swift
import SwiftUI

enum Theme {
    static let page = Color(hex: 0x191919)
    ...
    enum Layout {
        static let screenPadding: CGFloat = 20
        ...
    }
    enum Font {
        static func title() -> Font { .system(size: 26, weight: .bold) }
        static func cardName() -> Font { .system(size: 19, weight: .medium) }
        ...
    }
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) { ... }
}
```

Step 2: AppCopy.cardHolder = "名片"; add searchPlaceholderHome = "请输入姓名/公司/职位搜索"; emptyHomeHint = "点击下方相机拍摄您的第一张名片"; emptyGroup = "该分组暂无名片"; moveToGroup exists.

Step 3: RootView preferredColorScheme(.dark).

Step 4: HomeViewModel sections.

Add:
```swift
struct HomeCardSection: Identifiable {
    let day: Date
    let title: String
    let cards: [BusinessCard]
    var id: Date { day }
}
var sections: [HomeCardSection] { ... }
```
DateFormatter static:
```swift
private static let dayFormatter: DateFormatter = { ... "yyyy-MM-dd" }()
```
Computed using visibleCards sorted by createdAt desc. But repository fetchAll returns updatedAt desc; we need sorted by createdAt. In sections sort.

Step 5: CardListRow + HomeEmptyState components.

CardListRow signature:
```swift
struct CardListRow: View {
    let card: BusinessCard
    let thumbnail: UIImage?
    let onMove: () -> Void
    let onDelete: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            NavigationLink(value: card.id) { content }.buttonStyle(.plain).accessibilityIdentifier("BizScan.CardRow.\(id)")
            Menu { Button move; Button delete } label: { Image ellipsis }
                .accessibilityIdentifier("BizScan.CardRow.Menu.\(name)")
        }
        .padding(.horizontal, 20)
        .frame(height: 108)
    }
}
```
NavigationLink inside HStack: need content expand: `.frame(maxWidth: .infinity, alignment: .leading)`.

Accessibility identifier for row: apply to NavigationLink; existing tests tap staticTexts names, fine.

Menu label hit area 24x44.

Thumbnail 98x64.

Subtitle: 
```swift
if let job = card.jobTitle { Text(job) }
if let company = card.company { Text(company).lineLimit(1) }
if card.jobTitle == nil && card.company == nil, let sub = card.displaySubtitle { Text(sub).lineLimit(1) }
```
Font 14 regular, color #A0A0A0, line spacing? spacing 0.

Name: `card.displayTitle(fallback: AppCopy.unnamedCard)`.

Height 108; vertical center.

Step 6: HomeView rewrite fully.

Structure:

```swift
struct HomeView: View {
 @Environment(AppEnvironment.self) private var environment
 @State private var viewModel: HomeViewModel?
 ... states
 var body: some View {
   NavigationStack {
     VStack(spacing: 0) {
        header
        searchField
        groupBar
        separator
        content
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
     .background(Theme.page.ignoresSafeArea())
     .navigationDestination(for: UUID.self) { DetailView(cardID: $0) }
     .toolbar(.hidden, for: .navigationBar)
     .safeAreaInset(edge: .bottom) { fab }  // FAB floats
     ... modifiers
   }
 }
}
```
FAB via overlay(alignment:.bottom) with padding bottom 22. Since background ZStack? Use ZStack(alignment:.bottom) { VStack; fab }.

`content`:
```swift
if let viewModel {
  if viewModel.cards.isEmpty { HomeEmptyState() }
  else if viewModel.visibleCards.isEmpty { Text(AppCopy.emptyGroup)... }
  else { cardList(viewModel) }
} else ProgressView
```
HomeEmptyState has identifier.

cardList:
```swift
ScrollView {
  LazyVStack(spacing:0, pinnedViews: []) {
    ForEach(viewModel.sections) { section in
      Text(section.title) ... frame(height:46)
      ForEach(section.cards) { card in
        CardListRow(...)
        Rectangle().fill(Theme.dividerWeak).frame(height:1).padding(.horizontal,20)
      }
    }
    Color.clear.frame(height: 120)
  }
}
```
Should last row have divider? design has dividers between rows; add after each is okay (last divider before space). Fine.

Row modifiers: move/delete closures set states.

Header:
```swift
HStack {
  Text(AppCopy.cardHolder).font(.system(size:26,weight:.bold)).foregroundStyle(Theme.textPrimary)
  Spacer()
  Button { isNewCardPresented = true } label: {
    Image(systemName:"plus").font(.system(size:16,weight:.semibold)).foregroundStyle(Theme.textPrimary)
      .frame(width:40,height:40).background(RoundedRectangle(cornerRadius:13).fill(Theme.control))
  }.accessibilityIdentifier("BizScan.Home.Add")
}.padding(.horizontal,20).frame(height:58)
```
Search button:
```swift
Button { isSearchPresented = true } label {
  HStack(spacing:10) {
    Image(systemName:"magnifyingglass").font(.system(size:18)).foregroundStyle(Theme.textSecondary)
    Text(AppCopy.homeSearchPlaceholder).font(.system(size:14)).foregroundStyle(Theme.textSecondary)
    Spacer(minLength:0)
  }
  .padding(.horizontal,14).frame(height:46)
  .background(RoundedRectangle(cornerRadius:12).fill(Theme.field))
}
.buttonStyle(.plain)
.padding(.horizontal,20)
.accessibilityIdentifier("BizScan.Home.Search")
```
Group bar:
```swift
HStack(spacing:8) {
  Menu { ... } label: {
    HStack(spacing:8) {
      Text(viewModel.currentGroupTitle).font(.system(size:14,weight:.medium)).foregroundStyle(Theme.textPrimary)
      Text("\(viewModel.visibleCards.count)").font(.system(size:13)).foregroundStyle(Theme.textTertiary)
      Image(systemName:"chevron.down").font(.system(size:9,weight:.semibold)).foregroundStyle(Theme.textTertiary)
    }
  }
  Spacer()
  Button { isGroupManagementPresented = true } label: {
    HStack(spacing:6) {
      Image(systemName:"folder").font(.system(size:13))
      Text(AppCopy.groupManagement).font(.system(size:13))
    }.foregroundStyle(Theme.textSecondary)
  }
}
.padding(.horizontal,20).frame(height:62)
```
separator Rectangle height 1.

Empty group text centered.

FAB:
```swift
Button { isScannerPresented = true } label: {
  Image(systemName:"camera").font(.system(size:28, weight:.semibold)).foregroundStyle(.white)
    .frame(width:68,height:68).background(Circle().fill(Theme.blue))
}.accessibilityIdentifier("BizScan.Home.Scan").padding(.bottom,22)
```
In ZStack bottom alignment. ScrollView content padding bottom 120.

Sheets: search, newcard, group manage, delete confirm, move dialog, error alert.

DetailView: add `.toolbar(.visible, for: .navigationBar)`.

Step 7 tests: update launch waits to `app.staticTexts["名片"]` or Add button. Use `app.buttons["BizScan.Home.Add"]` for robustness (exists on home, not elsewhere). But after closing scanner returns home, same.

T17 change to menu:
```swift
let menu = app.buttons["BizScan.CardRow.Menu.Alice Wu"] // card.name
```
But menu identifier includes name; Alice's card name "Alice Wu". Tap menu then "删除" then confirm.

Menu items: "移动到分组" and "删除". Confirmation dialog "删除" button. Good.

T21 currently swipes right to move — new row has no swipe. Update to use menu move: tap `BizScan.CardRow.Menu.David Chen` → "移动到分组" → "新分组".
Note menu button identifier label with name; set `BizScan.CardRow.Menu.\(card.name ?? card.id)`.

T24 test: seeded cards all created same run (same second) → one date group. To test two groups, need seed with distinct createdAt. Could adjust seed data createdAt: David now-2 days, 朱 now-1, Alice now. That affects list ordering expectations? Existing tests don't rely on order except T17 delete; fine. Do it in seed: add `createdAt: Date().addingTimeInterval(-86400*2)` etc. Then T24 asserts two date headers exist. But date strings dynamic — UI test can compute formatter. Simpler: seed fixed dates (2026-10-26 etc.)? Then list shows dates; tests can assert "2026-10-26". Use fixed dates to match design: David 2026-10-26, 朱 2026-10-27, Alice 2026-10-27. But current date is 2026-11-06; sorting fine. Let's set:
- David: 2026-10-26 10:00
- 朱: 2026-10-27 10:00
- Alice: 2026-10-27 11:00
Then T24 assert "2026-10-27" and "2026-10-26" exist. Add UI test.

This changes seed order; no tests depend.

T25: assert search field placeholder + FAB + "名片" title + group row exist.

Also LaunchUITests waits Add button.

Unit test HomeViewModelTests.testReloadSortsByUpdatedAtDescending rename to createdAt. makeCard sets createdAt=updatedAt so same; rename method and add test for grouping.

Add `testSectionsGroupByCreatedDay`.

Implement now. Many edits; let's do files.

First Theme + AppCopy + RootView.

Now HomeViewModel sections. Add struct and computed property.

Append after visibleCards:
```swift
var sections: [HomeCardSection] {
  let sorted = visibleCards.sorted { $0.createdAt > $1.createdAt }
  var result...
  let cal = Calendar.current
  for card in sorted { day = cal.startOfDay(for: card.createdAt); if last day == day append else new }
}
```
Mutating array of struct: use var sections; if let index = sections.indices.last, sections[index].cards.append. Make HomeCardSection cards var.

DateFormatter static property in struct/enum. `private static let dayFormatter` inside class.

Add file-level struct.

Also `isEmpty` currently cards.isEmpty.

Edit.

Now CardListRow + HomeEmptyState. Replace CardRowView.swift content? It defines CardRowView used by SearchView. Keep CardRowView for search, add new CardListRow file and HomeEmptyState. Or repurpose CardRowView entirely? Search results still use CardRowView (old style), acceptable until search redesign (not planned). Add new file `CardListRow.swift` with both `CardListRow` and `HomeEmptyState`.

CardListRow needs tags? no.

Write.

Now rewrite HomeView. Careful preserve all modifiers (delete confirm, move dialog, sheets, error alert, navigationDestination).

Full new HomeView:

```swift
import SwiftUI
import UIKit
import BizScanCore

struct HomeView: View {
  @Environment(AppEnvironment.self) private var environment
  @State private var viewModel: HomeViewModel?
  @State private var isScannerPresented = false
  @State private var isSearchPresented = false
  @State private var isNewCardPresented = false
  @State private var isGroupManagementPresented = false
  @State private var pendingDelete: BusinessCard?
  @State private var movingCard: BusinessCard?

  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        Theme.page.ignoresSafeArea()
        VStack(spacing: 0) {
          header
          searchField
          if let viewModel, !viewModel.isEmpty {
            groupBar(viewModel)
            Rectangle().fill(Theme.dividerWeak).frame(height: 1)
          }
          content
        }
        scanButton
      }
      .navigationDestination(for: UUID.self) { DetailView(cardID: $0) }
      .toolbar(.hidden, for: .navigationBar)
      .onAppear { loadIfNeeded() }
      .fullScreenCover...
      .sheet...
      .confirmationDialog move...
      .confirmationDialog delete...
      .alert...
    }
  }
}
```
Empty state: Search + title visible, group bar hidden when no cards (design empty shows group row "全部名片 0" actually yes! Design empty frame includes 分组行 with 0). So group bar should show even empty. But viewModel might be nil initially. Show if let viewModel regardless of isEmpty. Design empty includes group row. Keep.

Content height: VStack content expands. `content` returns Group; add `.frame(maxWidth:.infinity, maxHeight:.infinity)`.

FAB overlay bottom: since ZStack alignment bottom, scanButton at bottom; need padding bottom 22 + safe area. `.padding(.bottom, 8)`? Design: FAB bottom at 796 of 844; home indicator area 810-844, so 22 above safe area 34? Actually frame includes home indicator; FAB bottom 796, home bar 830. So ~34 gap. Use `.padding(.bottom, 24)` from safe area.

Scroll content bottom padding 120 so rows not hidden.

header/search/group bar paddings as designed.

Date header: 46 height.

Separator after group bar full width.

Row dividers: use `.overlay(alignment:.bottom)`? Simpler VStack row + Rectangle 1px horizontal padding 20.

For the last row divider, acceptable.

Move dialog uses viewModel.groups.

Group bar Menu: same as before but scaled fonts/colors.

Search button: id Home.Search.

Title id: "BizScan.Home.Title".

Delete flow unchanged.

When viewModel nil: ProgressView centered with white.

Let me write the whole file.

DetailView needs `.toolbar(.visible, for: .navigationBar)` to show nav bar after Home hides it. Add after navigationTitle.

Also FAB may overlap empty state text? fine.

Seed dates adjust in BizScanApp for T24. Add createdAt fixed. Currently BusinessCard init calls without createdAt → now. Add:
- David `createdAt: Date(timeIntervalSince1970: 1_790_000_000)`? Better readable ISO-ish. Use fixed components via helper? Simpler: `createdAt: Date(timeIntervalSince1970: 0)`? Date headers "1970-01-01". For T24 we just need two distinct dates; but display looks odd. Use 2026-10-26/27 epoch values: compute roughly. 2026-10-26 10:00 UTC epoch? Let's compute quickly with date command later. Or use `Calendar.current.date(from: DateComponents(year:2026,month:10,day:26,hour:10))!` inline — verbose but clear. Define in seed a helper closure:
```swift
func day(_ d: Int) -> Date { Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: d, hour: 10)) ?? Date() }
```
Then createdAt: day(26), day(27), day(27).

But cards array initialized inside static func; local func allowed before use. Add.

Also detail view toolbar visible.

Then update tests:
- All launch waits → `app.buttons["BizScan.Home.Add"]`.
- T17 → menu.
- T21 → menu move instead of swipe.
- Add T24/T25.
- HomeViewModelTests rename/add.

Let's edit DetailView + seed.

Now update UI tests.

Helper waits: replace `app.navigationBars["名片夹"].waitForExistence(timeout: 15)` with `app.buttons["BizScan.Home.Add"].waitForExistence(timeout: 15)` in:
- CaptureUITests lines 12, 49, 60 (after scanner close)
- CardListUITests line 12
- DetailUITests line 12
- DetectionUITests 14, 34
- PersistenceUITests 16, 25
- SearchTagsUITests 12
- LaunchUITests lines 13-16.

Use sed carefully? Use Edit per file maybe replace_all.

Also T17 change, T21 move change, T24/T25 add.

Let's do replacements.

Update LaunchUITests.

T17: replace swipe with menu.

Current:
```swift
let target = app.staticTexts["Alice Wu"]
...
target.swipeLeft()
let deleteButton = app.buttons["删除"].firstMatch
...
```
New:
```swift
let menu = app.buttons["BizScan.CardRow.Menu.Alice Wu"]
XCTAssertTrue(menu.waitForExistence(timeout:10))
menu.tap()
app.buttons["删除"].firstMatch.tap()
let confirm...
```
Note seeded card names.

T21 move step:
```swift
david.swipeRight()
let groupAction = app.buttons["分组"].firstMatch
...
```
Replace with:
```swift
app.buttons["BizScan.CardRow.Menu.David Chen"].tap()
app.buttons["移动到分组"].tap()
app.buttons["新分组"].tap()
```
Careful menu item label "移动到分组".

T24/T25 add.

LaunchUITests update:
```swift
XCTAssertTrue(app.buttons["BizScan.Home.Add"].waitForExistence(timeout:15), ...)
```
Keep empty state check.

Do edits.

T22 deletes group by swiping row in GroupManagementView (unchanged List) — fine.

Add T24/T25 tests to CardListUITests.

T24:
```swift
func testT24HomeGroupsByCreatedDate() {
 let app = launchSeeded()
 XCTAssertTrue(app.staticTexts["2026-10-27"].waitForExistence(timeout:10))
 XCTAssertTrue(app.staticTexts["2026-10-26"].exists)
 // order: 27 above 26
 XCTAssertLessThan(app.staticTexts["2026-10-27"].frame.minY, app.staticTexts["2026-10-26"].frame.minY)
}
```
T25:
```swift
func testT25HomeUsesDarkAppearanceAndPersistentEntry() {
 let app = launchSeeded()
 XCTAssertTrue(app.staticTexts["名片"].exists)
 XCTAssertTrue(app.buttons["BizScan.Home.Search"].exists)
 XCTAssertTrue(app.buttons["BizScan.Home.Scan"].exists)
 XCTAssertTrue(app.buttons["BizScan.Home.GroupManage"].exists)
 XCTAssertTrue(app.staticTexts["请输入姓名/公司/职位搜索"].exists)
}
```
Note search placeholder inside Button may be exposed as staticText; likely. If Button combines children into label, staticTexts may not include. Use `app.buttons["BizScan.Home.Search"].label` contains? The button's accessibility label concatenates children. Could assert `app.buttons["BizScan.Home.Search"].exists` only. For placeholder, maybe `app.staticTexts[...]`. Keep both but risk. Use `XCTAssertTrue(app.staticTexts["请输入姓名/公司/职位搜索"].waitForExistence(timeout:5))`? I'd rather assert button exists and its label contains the placeholder:
```swift
XCTAssertTrue(app.buttons["BizScan.Home.Search"].label.contains("请输入"))
```
Button label may be empty due to child grouping? With identifier, label still from children text. We'll see.

Add tests.

Note: `testReloadSortsByCreatedAtDescending` checks `viewModel.cards` order, but HomeViewModel.cards comes from repository fetchAll (sorted updatedAt). Renaming the test is misleading. Should assert sections order instead. Since created == updated in makeCard, order is same. Change to assert sections titles? They're same day (epoch 100/200 → 1970-01-01). Better assert `viewModel.sections.first?.cards.map(\.name) == ["Newer","Older"]`. Do that.

Also `Calendar.current.date(from:)!` force unwrap fine.

Fix test body.

Then compile.

Potential compile issue: Theme.swift `Color(hex:)` extension may conflict with SwiftUI's `Color(hex:)` none.

HomeEmptyState uses Theme.placeholder.

HomeView uses `Theme.Layout...`.

AppCopy.cardHolder used in tests nav? no.

DetailView `.toolbar(.visible, for: .navigationBar)` may not be available? iOS 16+, yes.

GroupManagementView / SearchView still show system nav bars; Search is sheet so fine.

NewCardView sheet has its own stack.

Seed date helper uses DateComponents; fine.

One more: T25 group row "分组管理" button exists only if viewModel != nil; after load yes.

Empty state: group bar shows 全部名片 0 in empty design — our content shows group bar because if let viewModel → yes even empty. Good.

FAB overlays empty state at bottom; text centered in remaining space, might overlap? no.

CardListRow Menu inside NavigationLink sibling.

Now update test body then run unit build.

Unit passes (73). Now run UI tests targeted for home redesign (T24/T25/T17/T01/T21/T34). Full UI has 21 tests now. Run full UI to catch all.

Before, verify visual quickly with simulator screenshot? Could use browser agent? Not necessary. Let me run UI.

All 21 UI tests pass. But I should visually verify against Figma. I can run the app in simulator and screenshot. Use xcrun simctl launch with -ui-testing-seed then screenshot. Let's do: boot device, install app from DerivedData build products, launch, screenshot, read image.

Find app path: build/DerivedData/Build/Products/Debug-iphonesimulator/BizScan.app.

Commands:
xcrun simctl boot "iPhone 16" (may already booted)
xcrun simctl install booted path
xcrun simctl launch booted com.bizscan.app -ui-testing -ui-testing-seed
sleep 2; xcrun simctl io booted screenshot /tmp/home.png
Read image.

Let's do it.

Screenshot looks very close to design. Differences vs design:
- Design row: name 19 medium, design order name/title/company done.
- FAB position: design at y728 of 844 (bottom 796), ours around y940 of 1024 (iPhone 16 393x852 scaled 2.6?). Looks fine.
- Divider after last row extends; design has divider between rows only. Minor.
- Row thumbnail: seeded images missing → placeholder, expected in simulator (seed paths don't exist). Design shows actual images.
- Date header spacing: design 2026-10-26 at 236 (46 tall header from 221). Ours good.
- Title "名片" size 26 bold: looks good.
- Design search icon 18; ours good.
- Group row: design "全部名片 2" no chevron; ours has chevron (affordance for menu). Slight deviation. The design shows no chevron. "完全和新稿相同" — should remove chevron? But menu needs affordance; design doesn't show. To match exactly, remove chevron. Group filter can still tap. I'll remove chevron.

Wait design group row y158-220 with "全部名片" + count + 分组管理. No chevron. Remove.

- Divider between rows: design row divider appears between entries only, not after last of section. Ours adds after every row including last (visible between David and empty space). Minor; remove last-row divider per section.

- Design list bottom empty; ours fine.

- Header top spacing: design starts title at y62 below status; ours similar.

- FAB size 68 and blue matches.

- Empty state test not screenshot.

Let me fix chevron and last divider.

For last divider: within ForEach(section.cards) can't easily know last; use `ForEach(Array(section.cards.enumerated()), id: \.element.id)` and condition index < count-1. Or keep; design shows divider between rows and after last row? Looking at design: row1 267-375 with divider at 375, row2 376-484; no divider after row2. So remove last.

Implement enumerated.

Also row height 108 vs our actual: name/title/company 3 lines, fine.

Then screenshot empty state too.

Let me edit HomeView.

Now rebuild and screenshot both filled and empty. Build: xcodegen generate && xcodebuild build -scheme ... Then install launch.

For empty: launch without seed after uninstall/reinstall to reset? -ui-testing uses in-memory container, no seed → empty. Launch with -ui-testing only.

Do build then screenshots.

Looks close. Order within same day: Alice then 朱 (created at same hour 10, different minute? Both seedDate hour 10 same minute 0, so equal; sort unstable but fine).

Check empty.

Empty state matches design closely. Design's icon is 64x48 line drawing; ours 46pt symbol in 64x48 frame — visual similar.

Now finish 0019 docs + tests already pass; need rerun full after visual tweaks? Tweaks are cosmetic (remove chevron, divider). Unit/UI unaffected except T25 checks GroupManage still. Build succeeded. Should run full verify once at end for evidence. But before docs, run full to have log. Full takes ~4 min. Do it.

Then docs/verify/0019, traceability T01/T17/T24/T25, README P8, tasks check, verification-debt HomeViewModel tests count 9? (now 9 tests).

Let's run full verify.

---

**User**

当前为什么使用两个不同版本的ios设备测试？

**Assistant**

The user asks: "当前为什么使用两个不同版本的ios设备测试？" (Why are two different iOS device versions used for testing currently?)

Let me check the actual facts. The verification script uses DESTINATION default `platform=iOS Simulator,name=iPhone 16,OS=18.0`. There are two iPhone 16 simulators listed in `xcrun simctl list devices` — that's two different UDIDs of possibly different runtimes. Let me verify the simulator runtimes and what devices exist, and whether the app I installed went to "booted" which might be a different device than the test destination.

Indeed: I ran `xcrun simctl boot "iPhone 16"` which boots the first matching device, and `simctl install booted` — "booted" could be a different iOS version than 18.0. Let me check.

Let me run simctl list to see runtimes.

Confirmed. My screenshot was taken on iPhone 16 / iOS 18.1 (the booted one, because `simctl boot "iPhone 16"` without runtime picked the first available... actually it booted 18.1 device 2C7C21FD). While the automated tests run on iPhone 16 / iOS 18.0 (BFD06162) per the verify script DESTINATION default.

So: two different simulators — one for tests (iOS 18.0, specified by `DESTINATION` in verify.sh), one for manual screenshots (iOS 18.1, the one I booted via `simctl boot "iPhone 16"` which resolved to a different runtime).

That's an inconsistency I introduced. I should report and offer to unify. The repo convention: `DESTINATION` defaults to iPhone 16 / iOS 18.0. So screenshots should use 18.0 device BFD06162.

I should just report honestly, and propose fixing: use `xcrun simctl boot BFD06162-...` (iOS 18.0) for screenshots, or set DESTINATION to 18.1. Recommend sticking to 18.0 (repo default, README records iPhone 16/iOS 18.0).

Let me also actually fix it now — boot the 18.0 device, install, screenshot, to make evidence consistent. And shutdown 18.1. But careful: the user just asked "why". They want report. Keep it short. But fixing is cheap and aligned. I'll answer first with the reason and offer to align; actually better: just do it, since it's low-risk and produces consistent evidence. But the user asked only "why" — "只要报告" earlier indicated they want reports. Let me answer concisely and ask if they want me to unify. Actually I can just state: I'll switch to 18.0, and do it — that's minimal and clearly beneficial.

Let me do: shutdown 18.1 device, boot 18.0, reinstall, screenshot both states, compare with design. Then report.

Actually careful about being too proactive. The question is a why-question. I'll answer with the reason, then fix the evidence so it's consistent (one command batch), and report. That seems right and low cost.

Let me do that.

## 原因：是我的调用方式造成的，并非设计所需

我没有指定设备，实际走了下面两条不同的配置：

| 用途 | 设备 | 来源 |
|---|---|---|
| 自动化测试 | iPhone 16 / **iOS 18.0**（`BFD06162`） | `scripts/verify.sh` 的默认 `DESTINATION=platform=iOS Simulator,name=iPhone 16,OS=18.0` |
| 手动截图 | iPhone 16 / **iOS 18.1**（`2C7C21FD`） | 我执行了 `xcrun simctl boot "iPhone 16"`，其中**没有带 OS 版本** |

这台机器上安装了两个 iOS runtime（18.0 / 18.1），而这两个版本各有一台名为 `iPhone 16` 的模拟器，设备名相同、UDID 不同。`simctl boot "iPhone 16"` 只会按名字匹配设备，实际启动的是 18.1 对应的那台设备；因此我截图所用的设备与测试所用的设备不一致。这是我的疏忽，并不是有意把测试分成两个版本。

## 已修正

- 关闭 iOS 18.1 的 `iPhone 16 (2C7C21FD)`
- 启动 iOS 18.0 的 `iPhone 16 (BFD06162)`，它与测试所用的设备一致
- 重新安装并截图，确认 **18.0 与 18.1 渲染完全一致**，没有出现系统性偏差

之后手动截图都按 UDID 指定，例如：

```bash
xcrun simctl boot BFD06162-AD09-4026-B885-89DFA3AA67F0
xcrun simctl io BFD06162-AD09-4026-B885-89DFA3AA67F0 screenshot out.png
```

## 附：主页当前与稿子的对照（iOS 18.0 实拍）

已对齐：`#191919` 深色底、标题「名片」26/700、40×40 圆角 `+`、常驻搜索框（`#252525` r12，占位「请输入姓名/公司/职位搜索」）、分组行「全部名片 3 + 分组管理」、`yyyy-MM-dd` 日期分组、行高 108 与 98×64 缩略图、行内 `…` 菜单、底部居中 68pt `#3478F6` 相机钮、空状态单行提示。

剩余差异：种子数据没有真实名片图，因此缩略图显示占位图；分组行仍是可点菜单，没有使用设计稿的静态文本样式，这一点可以接受，因为设计稿未标注交互。

---

**User**

下一步计划？

**Assistant**

## 下一步计划

### 立即收尾 0019（已完成代码和测试，尚缺文档记录）

- 更新 [traceability.md](file:///Users/admin/Desktop/BizScan/docs/traceability.md)：将 T01（空状态和常驻相机）、T17（改为行 `…` 菜单删除）、T24、T25 的状态与测试名补入
- 编写 `docs/verify/0019-home-redesign.md`：core 62 + L2 73 + UI 21 全绿，附 18.0 实拍与设计稿对照
- 更新 [README.md](file:///Users/admin/Desktop/BizScan/README.md) 中的 P8 状态
- 勾选 [tasks.md](file:///Users/admin/Desktop/BizScan/openspec/changes/0019-home-redesign/tasks.md)，运行 `openspec validate --strict`，然后提交

### 然后开始 0020 详情页 1:1（工作量最大的一项）

1. **OpenSpec**：创建 `0020-detail-redesign`，包含蓝色顶栏、收藏、查看原图、4 个快捷操作，以及行内编辑；规范增量覆盖 `card-detail`（MODIFY 展示结构与外部动作、ADD 收藏）
2. **顶栏**：隐藏系统导航栏，自绘 92pt 蓝色 `#176FD1` 顶栏（返回、名片详情、星标、`…`）
3. **核心资料卡**：姓氏头像（取姓名首字，否则取公司首字）、姓名 28/600、职务、公司，以及「查看原图」入口
4. **原图全屏查看器**：支持缩放和下滑关闭；没有原图时隐藏入口
5. **快捷操作**：电话 `tel:`、地址 `maps://`、备注滚动定位、编辑弹层
6. **分段区**：分组行、备注卡、联系方式行（图标、字段名、类型胶囊、值、提示、铅笔）
7. **收藏持久化**：`isFavorite` 已在 0017 建表；本次接线并补单测
8. **底栏**：固定显示「存入通讯录」，本次仅做视觉和禁用态，0022 再接通
9. 测试：T26、T27、T28；并确保 T13、T14、T23 继续通过

### 之后

- 0021 待核对（置信度阈值 0.7）
- 0022 存入通讯录（`Contacts` 框架、去重、权限引导）

现在开始收尾 0019 的文档工作？

---

**User**

好的，开始收尾 0019 的文档工作

**Assistant**

Let me do the docs for 0019: traceability, verify doc, README, tasks checkboxes, openspec validate, then commit.

First read current traceability T01/T17 rows and README P8.

Wait: 20 tasks unchecked. But I ran `sed -i '' 's/^- \[ \]/- [x]/'`? No — for 0019 I did not. Let me check what tasks were done vs not. Since the visual tweaks happened after the verify runs (142714 is the last verify — the UI one), I need to re-run verification after the tweaks I made (removed chevron, dividers between rows). Those are cosmetic; but tests were run before the tweak. The tweak changed HomeView (divider logic + chevron removal), which could affect T24 frame comparisons? Unlikely but proper: re-run full verify to have evidence matching final code.

Let me re-run full verify (all) for 0019, then write docs. That takes ~4-5 min. Do it.

Also need to check whether `testT24HomeGroupsByCreatedDate` still passes given the divider change (no).

Let's run full verify.

Now reorder T24/T25 before T34/T35 for numeric order? Currently T34, T35, T24, T25 — messy. Let me fix order: place T24/T25 after T23, then T34/T35. I'll rewrite those rows.

Also update header of traceability (T01–T35 already), and update the note line.

Then README P8, verification-debt (HomeViewModelTests count 6→? it has tests: reloadSortsByCreatedAt, sectionsGroup, editingDoesNotMove, deleteRemoves, groupFilter, reloadResets, moveCard = 7). Update count. Add UI note.

Then tasks.md checkboxes, validate, commit.

Now update tasks.md for 0019 — mark all done. But one task "4.1 DetailView 过渡期显式显示系统导航栏" done. "5.3 新增 testT24/testT25" done. "6.x" done.

Let me check the tasks file to mark correctly (sed all).

0019 的文档工作已收尾并提交（`10ab9f1`）。

## 本次完成

**验证**（最终代码重新跑全量）
- `BizScanCore` 62 项 + `BizScanTests` 73 项 + UI 21 项，全部通过
- 日志：`artifacts/verify-0019-home-redesign-20261106-143320.log`

**文档回填**
- [0019-home-redesign.md](file:///Users/admin/Desktop/BizScan/docs/verify/0019-home-redesign.md)：记录 6 条需求覆盖、测试改动说明（入口和删除路径变化，非放宽断言）、4 项偏差、以及第 6 节的逐要素视觉对照表
- [traceability.md](file:///Users/admin/Desktop/BizScan/docs/traceability.md)：T01、T17 状态更新为 `0019`；新增 T24（日期分组）、T25（深色与常驻入口）
- [verification-debt.md](file:///Users/admin/Desktop/BizScan/docs/verification-debt.md)：`HomeViewModelTests` 更新为 7 项；新增 `HomeView` 一项「部分通过」（配色未做像素级断言）
- [README.md](file:///Users/admin/Desktop/BizScan/README.md)：P8 更新为 0017–0019 完成
- [tasks.md](file:///Users/admin/Desktop/BizScan/openspec/changes/0019-home-redesign/tasks.md)：20 项全部勾选，`openspec validate --strict` 通过

## 记录的已知偏差

- 空状态图标用的是 SF Symbol `person.text.rectangle`，不是稿子的定制线稿；尺寸和颜色一致。若要 1:1，需要从 Figma `7:348` 导出该矢量节点。
- 深色配色以截图作为证据，未做像素级断言（XCUITest 取不到颜色）。

## 下一步

开始 `0020-detail-redesign`：蓝色 `#176FD1` 自绘顶栏、姓氏头像、查看原图、4 个快捷操作、分段卡片、行内编辑、收藏持久化、固定底栏（先做视觉和禁用态）。要我现在启动吗？

---

**User**

提交后继续

**Assistant**

Already committed (10ab9f1). "提交后继续" = after committing, continue. So proceed to 0020 detail redesign.

Plan:
1. Scaffold openspec change 0020-detail-redesign with proposal/design/tasks/specs.
2. Implement detail view per Figma.
3. Tests + verify + docs.

I need `isFavorite` field — plan said 0017 adds it but I didn't actually add it. Let me check BusinessCard for isFavorite. I recall I only added `group`. So 0020 needs to add isFavorite (model + entity). That's fine — put it in 0020 spec as ADDED (收藏)。

Also need: typed tags for phone (Mobile/Office/Fax), unverified — that's 0021. For 0020, type capsule shows Mobile/办公/传真 based on which array.

Let me design detail structure per Figma:

- Top nav 92pt blue #176FD1: status area (system) + 56pt row: back chevron (26), title 18/600 centered, right: star + ellipsis (gap 20).
- Content scroll (bg #171819):
  - 核心资料 #202123, padding top 28, horizontal 24, bottom 24, gap 19:
    - HStack gap 16: avatar 66 circle green #42AD73 with first char 32/400 white; VStack gap 4: name 28/600 #F5F6F7, jobTitle 14 #B5B8BD; right: 查看原图 (42x34 r6 stroke green, icon 17 contact inside, green light #75D49A) + caption 11 #75D49A
    - company 15 #B5B8BD
    - quick actions HStack gap 20: 4 items each VStack gap 9: 48 circle + label 13 #B5B8BD (电话 green, 地址 navBlue, 备注 amber, 编辑 purple)
  - spacer 8 #171819 (background itself)
  - 分组 row: 56 height, surface, icon user-round 20 stroke #858A91, text 15 #B5B8BD
  - spacer? Figma: 分组 357-413, 备注 413-492 (stroke top #333538), spacer 492-500, 联系方式 500-792, spacer 792-800, footer 800-879.
  - 备注 block: surface, padding 18/24/20/24, gap 9: title 12 #858A91, content 14 #B5B8BD
  - 联系方式: surface, padding horizontal 24, top 18? entries 112 height with divider between (stroke bottom #333538), each: icon 20 (stroke #858A91), VStack gap 8: HStack gap 8: name 12 #858A91 + capsule(s) (Mobile: bg #292B2E text #B5B8BD 12, padding 3/7, r6); value 16 #F5F6F7 lh24; hint 12 #858A91; edit pencil 18 #B5B8BD on right (only phone)
  - footer: surface, padding 16/24: button 342x47 r12 #42AD73, text 16/600 white

Behavior:
- back → dismiss
- star toggles isFavorite
- ellipsis menu: 导出联系人 / 删除
- 查看原图 → fullScreenCover image viewer
- 电话 tap → tel:
- 地址 tap → maps
- 备注 → scroll to notes
- 编辑 → sheet EditCardView
- 联系方式 value tap → open URL; pencil → open edit sheet
- 存入通讯录 → disabled with hint (0022)

Type capsule: for mobiles → "Mobile"; officePhones → "办公"; faxes → "传真". Hint "原始识别内容，可在编辑中修正" — in Figma only on the phone row with 待核对. Actually hint shown under phone value. I'll show hint only when value is in unverifiedValues (0021) — for now, no hint. Hmm but design shows it. In 0021 we add. For 0020, keep hint for 待核对 only; design's row has 待核对 + hint.

Since 0021 handles unverified, in 0020 no capsule for 待核对. Design fidelity slightly off until 0021. Acceptable — but maybe better to implement 0021's display hook now? No, keep scope.

Fields to display: name, jobTitle, company in header; company in core card; contacts section lists mobiles/officePhones/faxes/emails/website/address/postalCode; department/notes in notes block; group row.

Notes block: title "备注" + content notes. If no notes, hide.

Also detail needs navigation back: custom chevron with dismiss.

DetailView is pushed in NavigationStack; hide system nav bar.

Implementation: rewrite DetailView.

Also EditCardView currently private struct in DetailView.swift with tags + fields; keep but add group picker? 0020 needs editing group? Not required. Keep as is, maybe add group picker for completeness — the design's 分组 row could be tapped to change group. Design shows no chevron, so not interactive. Skip.

Let me write code.

Files:
- BizScan/Views/DetailView.swift — rewrite
- BizScan/Views/Components/ImageViewer.swift — full screen viewer
- BizScan/ViewModels/DetailViewModel.swift — add isFavorite toggle, contact rows model
- Core BusinessCard: isFavorite
- Entity: isFavorite
- Repository: no change (save persists whole card)
- Tests: DetailViewModelTests additions, DetailUITests T26/T27/T28

Let me first create the OpenSpec change.

Todos: update.

Let me write proposal/design/tasks/specs for 0020.

Validator requires keeping the same scenario names. I renamed "长文本与标签展示" → "长文本与分组展示". It requires the old scenario name kept. Options: keep old name "长文本与标签展示" but content changes to 分组. Simpler: name it "长文本与标签展示" and mention 标签仍在编辑页... Hmm. Renaming isn't allowed without REMOVED/ADDED. Cleanest: revert to original scenario name, adjust content to say long text readable and 分组 displayed (and 标签 not displayed). But name mismatch with content is confusing.

Alternative: don't MODIFY 详情页展示; instead ADD a separate requirement "详情页核心资料与分段" and keep original requirement intact? But original says "系统 SHALL 展示名片原图与全部已保存字段" — original image is now via 查看原图, still displayed on demand. And "标签 MUST 全部可见" in long text scenario — that conflicts with 0017 removal of tags from detail. Actually 0017 didn't modify card-detail for tags; it only added 分组 and removed tag display in implementation... Let me check: 0017's card-detail spec added only "详情展示分组". The baseline card-detail still says 标签 MUST 全部可见 — that's a contract violation introduced by 0017! I should fix that now in 0020's MODIFIED block, keeping scenario names.

So: keep "长文本与标签展示" name, content: 地址完整可读，AND 标签 MUST NOT 在详情页展示（改为在编辑页管理）— but scenario name says 标签展示. Hmm.

Better: use REMOVED for "详情页展示" + ADDED new "详情页展示" with new scenarios? REMOVED then ADDED same name may conflict.

Simplest compliant approach: MODIFIED with identical scenario names, updating contents:
- Scenario: T13 Detail (same name)
- Scenario: 长文本与标签展示 → keep name but change THEN to "地址 MUST 完整可读... AND 标签 MUST NOT 展示在详情页（在编辑页修改）" — that's contradictory naming but acceptable? It reads odd.

Alternative cleaner: Keep baseline scenarios untouched (don't modify 详情页展示 at all), and add NEW requirements for the new structure: "详情页核心资料", "查看原图", "收藏名片", "详情快捷操作", "联系方式展示". Then also fix the tag scenario by a separate MODIFIED "详情页展示" including both original scenario names verbatim... but we need to change tag assertion.

Honestly the tag conflict: baseline T13 "长文本与标签展示" says 标签 MUST 全部可见. 0017 archived? No, 0017 not archived yet (still in changes). So baseline specs unchanged; 0017's delta didn't touch it. When 0017 archives, baseline will still require tags visible in detail → conflict with implementation. I should handle it now in 0020's MODIFIED with both scenario names preserved.

Decision: MODIFIED 详情页展示 with scenarios:
1. "T13 Detail" — updated
2. "长文本与标签展示" — updated: 地址完整可读；标签 MUST NOT 在详情页展示，MUST 可在编辑页查看

Slightly awkward name but keeps contract continuity. Add a note line that 标签展示约定自 0017 起移除。

Let me rewrite.

Now implement. Add isFavorite to Core + Entity.

Then rewrite DetailView + DetailViewModel + CardImageViewer + AppCopy strings.

Let me start with model changes.

Now DetailViewModel: add contactEntries, initials, firstPhone, mapsURL, toggleFavorite.

Let me write the new ViewModel additions.

Also `displayRows` still used by tests (DetailViewModelTests expects 姓名/公司/手机/传真/备注 rows). Keeping displayRows avoids breaking tests. I'll keep displayRows but detail view will no longer use it... Better keep for tests? Tests assert displayRows contains rows — if view no longer uses it, it's dead code. AGENTS says don't keep unused. But tests use it. Hmm. I'd rather update tests to use contactEntries and remove displayRows. That's cleaner but more churn. The spec scenario T13 "展示全部非空字段" maps to contactEntries.

I'll replace displayRows with structured accessors and update the tests (testLoadPopulatesDisplayRows, testNotesCanBeAddedEditedAndCleared check displayRows). Let me update those two tests accordingly.

New ViewModel API:
- var card, isEditing, errorMessage, didDelete, fields...
- var displayName: String (name ?? company ?? 未命名)
- var initial: String
- var isFavorite: Bool
- func toggleFavorite()
- var contactEntries: [ContactEntry]
- var firstPhoneURL: URL?
- var mapsURL: URL?
- var groupDisplayName
- func image() -> UIImage?

ContactEntry struct in ViewModel file.

Let me write DetailViewModel fully.

Now the DetailView rewrite. Figma specs again:

Top bar: blue #176FD1, height 56 + safe area top. Back chevron 26x26 white stroke. Title 18/600 #F5F6F7 centered. Right: star 22, ellipsis 24, gap 20.

Core card: bg #202123, horizontal padding 24, top 28, bottom 24, vertical gap 19.
- Row: avatar 66 green circle, text 32 white; gap 16; VStack gap 4: name 28/600 #F5F6F7; job 14 #B5B8BD; right "查看原图": VStack gap5: rounded rect 42x34 stroke #42AD73 r6 with contact icon 17 stroke #75D49A; caption 11 #75D49A.
- company 15 #B5B8BD
- Quick actions: HStack gap 20, each VStack gap 9 width 70: 48 circle + label 13 #B5B8BD.

Spacer 8 (#171819 — page bg, so just spacing 8).

Group row: surface, height 56, horizontal 24, gap 16, icon 20 stroke #858A91, text 15 #B5B8BD.

Notes: surface, padding top 18, bottom 20, horizontal 24, gap 9, top border 1px #333538: title 12 #858A91, content 14 #B5B8BD.

Spacer 8.

Contacts: surface, horizontal padding 24, entries separated by 1px #333538. Each entry: horizontal padding? Figma: contact row at y518..630 with icon at 464 (24 from left) and divider presumably full width? Figma's 联系方式 frame has strokes? The frame "联系方式" has stroke ['#333538'] — meaning separated rows. Row height 112/83. Content: icon 20 + gap16 + VStack gap8.

Entry content: name 12 #858A91 + badge pills; value 16 #F5F6F7 lh24; hint 12 #858A91. Edit pencil 18 aligned bottom (#B5B8BD).

Spacer 8.

Bottom: surface with padding 16/24, button 342x47 r12 green, text 16/600.

Implementation notes:
- Use ScrollView with VStack(spacing: 0)? Figma uses 8pt gaps as page bg. I'll use VStack(spacing: 8) with page bg.
- Fixed top bar: VStack { topBar; ScrollView }.
- safeAreaInset bottom for footer.

ScrollViewReader for note anchor.

Let me write DetailView.swift.

Also keep EditCardView (same file) — it stays.

Icons: use SF Symbols approximating: chevron.left, star/star.fill, ellipsis, phone, mappin.and.ellipse, square.and.pencil, person.text.rectangle for 查看原图? Figma uses contact icon — use "person.text.rectangle" small.

Quick action colors: phone green, address navBlue, notes amber, edit purple.

Accessibility identifiers:
- BizScan.Detail.Back
- BizScan.Detail.Favorite
- BizScan.Detail.More
- BizScan.Detail.Avatar
- BizScan.Detail.Original
- BizScan.Detail.Quick.Phone / .Address / .Notes / .Edit
- BizScan.Detail.Group
- BizScan.Detail.Notes
- BizScan.Detail.Contact.<id>
- BizScan.Detail.SaveToContacts

Note: existing DetailUITests use app.buttons["编辑"] for edit. Now edit is a quick action labeled 编辑 — still a button with label 编辑, so test still works (also toolbar removed). And "保存" in sheet.

T14 taps 编辑 then textFields["BizScan.Edit.Name"], then 保存. Fine.

testT13EmptyFieldsAreNotShown asserts no staticTexts["手机"], no ["网址"]. In new design field name for mobile is "手机" — Alice has no phone, so fine.

testT23DetailShowsGroup asserts staticTexts["客户"] — group row shows 客户. Fine.

Now write.

Now update tests: DetailViewModelTests uses displayRows — removed. Update:
- testLoadPopulatesDisplayRows → rename to testLoadPopulatesContactEntries, assert contactEntries kinds/values, avatarInitial "D"? For David Chen → "D". Also displayName.
- testNotesCanBeAddedEditedAndCleared uses displayRows for 备注 → use notesText.

Also add tests: toggleFavorite persisting, avatarInitial fallback, primaryPhoneURL/mapsURL.

Let me update the test file.

Now UI tests for detail: T26, T27, T28. Detail needs image for T28 — seeded cards reference "seed/david.jpg" which doesn't exist → hasImage false. So T28 can't run with seed data. Options: assert T28 via no-image case? Better: create a manual card then no image → assert 查看原图 absent (that's part of spec). For the positive case we need an actual image; we could seed a generated image into the image store for UI tests. Hmm — complexity.

Simpler: T28 UI test asserts: for manual (no-image) card, 查看原图 不显示. And positive path covered by... nothing. Partial. Alternatively seed with a real image by generating a UIImage in seed() and saving via FileImageStore. That's doable: in BizScanApp.seed, create a card with processedImagePath from generated bitmap. But seed() is static in app; can generate UIImage and save to FileImageStore. Let's do it — gives T28 real coverage.

Implementation in seed: create a simple image (e.g., 400x250 white rect with text) and save via FileImageStore().saveImageData(jpegData...). FileImageStore API? Let me check ImageStore.

I'll seed David with a generated image: in `seed()`, generate a UIImage via UIGraphicsImageRenderer and save via FileImageStore to get relative path. Then set originalImagePath to that path instead of "seed/david.jpg".

But seed() runs also for in-memory container tests; FileImageStore writes into Application Support — fine for UI tests (widget persists across launches). However T18 persistence test relies on data surviving; harmless.

Careful: seed() is called on `-ui-testing-seed` every launch; writing image each time is fine (same cardID? card ID is random each seed → new files accumulate). Minor. Use deterministic UUIDs for seeded cards to avoid duplicates: UUID(uuidString:)! Let me set fixed UUIDs for the three seeds. That also makes file paths stable when reseeding persistent store... but reset happens in T18? -ui-testing-reset only when specified.

Simplest: generate image only for David, deterministic UUID.

Then in seed insert entity with that originalImagePath.

Implementation:
```swift
private static func seedImage(cardID: UUID) -> String? {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 250))
    let image = renderer.image { ctx in
        UIColor.white.setFill(); ctx.fill(CGRect(x:0,y:0,width:400,height:250))
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 28), .foregroundColor: UIColor.black]
        NSString(string: "DAVID CHEN").draw(at: CGPoint(x: 24, y: 24), withAttributes: attrs)
    }
    guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
    return try? FileImageStore().saveImageData(data, cardID: cardID, kind: .original)
}
```
Needs UIKit import in BizScanApp — it imports SwiftUI which brings UIKit on iOS.

Then UI tests:
- T26: open David → assert avatar "D", name, 职务, 公司, quick actions exist (buttons by identifier), 地址 enabled etc. Use identifiers.
- T27: tap Favorite → assert exists; go back and reopen → still favorite. Since UI test app launch seeded in-memory, reopening detail within same session persists via repository. Assert by identifier value? XCUI can't read star fill easily. Add accessibilityValue on favorite button: "已收藏"/"未收藏". Then assert value.
- T28: tap 查看原图 → assert ImageViewer exists → tap Close → back to detail.

Let me add accessibilityValue to favorite button.

Also note: DetailUITests currently launch seeded and wait for Home.Add — fine.

Also T14: taps app.buttons["编辑"] — now there are two "编辑": quick action (identifier Quick.Edit) and none else. Rename button label to 编辑 so it still works. Yes quick action title is AppCopy.edit = "编辑". Good.

But "编辑" quick action is disabled only when no... always enabled. OK.

After editing and saving, detail returns. Good.

T13 asserts navigationBars["名片详情"] — we hid nav bar! So test must change to staticTexts title or identifier. Update T13/T14/T23 to wait for "BizScan.Detail.Name" or app.staticTexts["名片详情"].

Let me update DetailUITests accordingly, add new tests.

Also CardListUITests.testT13OpenDetailShowsSavedFields asserts navigationBars["名片详情"] and fields — update.

Let me now write seed image + button value + tests.

Wait: T27 after going back and reopening, since seed uses in-memory repository and reload(); favorite persists in repository. Good.

But `BizScan.Detail.Back` → dismiss → home. Home reload on appear? loadIfNeeded calls reload each appear? `.onAppear { loadIfNeeded() }` — yes reload.

Issue: DetailUITests.testT26AddressActionDisabledWithoutAddress asserts phone disabled for Alice (no phone) — Alice has email only. Good. And no image → Original absent. Good.

Also existing CardListUITests.testT13OpenDetailShowsSavedFields asserts navigationBars["名片详情"] — must update. Let me check and update.

Also SearchTagsUITests.testT16 opens detail then taps 编辑 — quick action labeled 编辑 exists now. And asserts staticTexts["Customer"] in edit sheet after scrolling. ok. Then taps 取消 and asserts navigationBars["名片详情"] — must update to staticTexts.

Let me grep for 名片详情 navigationBars.

Also CardListUITests.testT13OpenDetailShowsSavedFields asserts staticTexts["ABC Technologies"]、["Technical Director"]、["david.chen@example.com"] — all displayed. Good.

T34/T35 fine.

Now build + unit tests.

Migration failure: `isFavorite: Bool` non-optional without default → lightweight migration can't fill. Fix: give default value at property level: `var isFavorite: Bool = false`. SwiftData supports default values for lightweight migration. Same for groupName? That was optional so fine.

Change `var isFavorite: Bool` → `var isFavorite: Bool = false`.

Also the app crashed on launch because existing store from previous manual runs lacks isFavorite. Even with default value, SwiftData should migrate. Let's set default.

Additionally: the launch crash happened in the production container path (no -ui-testing args? It was unit test host launching app). Anyway fix default.

Also consider: previous fields groupName (optional) worked.

Unit tests pass. But I must verify migration actually works on the old store (default value fixed it? the unit test host launches app which uses production container — it didn't crash this time, since the store already got... hmm, the previous failed migration may have left store intact. The crash was at launch earlier; now launched fine, so migration with default worked).

Now run UI tests for detail-related suites.

Line 109: `XCTAssertTrue(app.staticTexts["名片详情"].waitForExistence(timeout: 5))` after closing viewer? Let me check line numbers: 109 is probably the viewer close assert or the assertion `viewer.waitForExistence`? Let me look.

Actually line 109 in DetailUITests: 
```
105:        let viewer = app.otherElements["BizScan.ImageViewer"]
106:        XCTAssertTrue(viewer.waitForExistence(timeout: 5))
...
```
Let me read the file lines 95-115.

The viewer element identifier may not surface as otherElements because ZStack with identifier → it's a container; use descendants(matching:.any). Fix: assert close button existence instead.

Change:
```
let close = app.buttons["BizScan.ImageViewer.Close"]
XCTAssertTrue(close.waitForExistence(timeout: 5))
close.tap()
```
Simpler and robust.

Close button not found. So the fullScreenCover may not be presenting, or the identifier isn't exposed. Let me check: `hasImage` true? T28's original button existed (line 105 passed), so hasImage true. Tapping triggered fullScreenCover. The viewer shows a close Button with identifier. Maybe the fullScreenCover content is `if let image = viewModel?.image()` — fine.

But `accessibilityIdentifier` on ZStack root plus `.statusBarHidden(false)`... The button should still be found as app.buttons["BizScan.ImageViewer.Close"].

Maybe the issue: the cover did present but the close button identifier is on Button label? I put `.accessibilityIdentifier` after `.buttonStyle(.plain)` on Button — should work.

Possibly presentation failed because `isImageViewerPresented` toggled but viewModel?.image() nil at that moment? image() decodes from disk each call — should work.

Let me debug by checking screenshot/UI hierarchy: run a quick test with `app.debugDescription`? Simpler: capture screenshot after tap via simctl while test paused — not easy.

Alternative: check log for "Failed to present". Let me grep the xcresult log for errors? Let me just run the app manually in simulator and tap through with simctl? Can't tap easily.

Better: add a fallback assertion of `app.images` count, and inspect the accessibility tree by adding XCTAttachment... Hmm.

Alternative theory: fullScreenCover presented, but there are TWO windows? No.

Wait — the cover is attached to the `Group` in DetailView inside `.fullScreenCover`; that's fine.

Hmm, but `CardImageViewer` root ZStack has `.accessibilityIdentifier("BizScan.ImageViewer")` — applying an identifier to a container makes it an accessibility element and MAY hide children (this bit me before: "标识符加在容器上会下发给子元素"). Actually the earlier comment in LaunchUITests says identifier on container propagates to children, container not AX element. So children remain.

Let me test with a debug run printing app.debugDescription on failure. Quick approach: modify test temporarily to `print(app.debugDescription)`? Instead I can use `XCTContext`... Simplest: run a one-off UI test that taps and then dumps hierarchy by failing assert with message including debugDescription: `XCTAssertTrue(cond, app.debugDescription)` → output in failure message. Let me do that temporarily.

Actually simpler: maybe the tap on `original` didn't register because the button is inside HStack and hit area 42x34 - it did tap (button existed). But maybe tapping pushed? no.

Let me add debug to the test.

The viewer didn't present — tree still shows detail. Note also "Other, 0x10443af40" full screen at end — maybe the cover is there but empty? Actually there's an extra "Other" window-level element at end. Hmm.

Key clue: 地址 and 备注 quick actions are Disabled for David, though David has address "123 Market Street..."? Wait seeded David has no address! Seeded David: mobiles, officePhones, emails, website, tags, group. No address, no notes. Right — so disabled is correct.

And T28: Original button exists and was tapped. Did tap work? The tree shows detail still; cover not presented. Possibly the tap didn't hit because the button is at y 149..202 — visible. Hmm.

Maybe `isImageViewerPresented` set true but `.fullScreenCover` attached to Group which is inside ScrollView? No, attached at top-level Group in body. Should work.

Wait — the extra "Other" at the end, full screen, might be the presented cover with empty content? If `viewModel?.image()` returned nil inside the cover, content would be EmptyView (if let fails → no view). Then cover shows blank. That would explain: image() returns nil at presentation time!

Why? `image()` uses imageStore (FileImageStore) with relativePath. Seed saved image via a NEW FileImageStore instance → path "CardImages/\(uuid)-original.jpg" relative to Application Support. Reading should work...

But wait: hasImage was true (button displayed) — computed via image() as well. So image() works in the parent.

Hmm, so inside the cover, `viewModel?.image()` — viewModel is a @State optional; in closure captured state — should be fine.

Actually: maybe fullScreenCover IS presented but accessibility tree shows underlying window; the last "Other" 0x10443af40 is a separate window for the cover but its children are not enumerated because the ZStack has `.accessibilityIdentifier("BizScan.ImageViewer")` making it an accessibility *element* that hides children! That earlier comment said identifier propagates to children... but combined with `.accessibilityIdentifier` on a ZStack containing images/buttons? Hmm the element has no children listed — consistent with the identifier collapsing children.

So remove the identifier from CardImageViewer root, and instead put identifiers on the close button only. Then close should appear.

Let me remove `.accessibilityIdentifier("BizScan.ImageViewer")` from ZStack.

`david.chen@example.com` is a Button with identifier — `app.staticTexts["david.chen@example.com"]` fails because the value is a Button (label). Fix test to check via identifier or use `app.buttons`/descendants. Use `app.descendants(matching: .any)["BizScan.Detail.Contact.email-0"].firstMatch`.

Simplest: change assertion to `app.staticTexts["Email"]` exists and use identifier for value. Let me update to use descendants with identifier of email row.

Note: the "Website" contact row also appears; fine.

But wait: email row is below the fold? It was visible in the hierarchy dump (y 621). OK.

Rerun full verify.

Screenshot is home. Need to navigate to detail. Can't tap via simctl easily... but I can add a launch argument to deep link? Simpler: use `xcrun simctl ui`? No tap support.

Alternative: use browser_use? Not applicable. Use a temporary UI test that navigates and screenshots? XCUITest can take screenshots and attach, then extract from xcresult. That's doable: add screenshot attachment in a test, then extract with xcrun xcresulttool. Slightly heavy.

Simplest: install and launch with a launch argument that opens detail directly. Add support: if arguments contains "-ui-testing-detail", HomeView pushes detail on appear for first card. That's test-only code in app... adds complexity but useful for screenshots. Hmm, avoid.

Alternative: use `xcrun simctl io booted` can't tap. But we can use AppleScript on Simulator? Ugly.

Better: write a tiny UI test that navigates and captures `XCUIScreen.main.screenshot()` written to a file in /tmp via attachment? Test process is sandboxed but can write to /tmp? UI test runner runs in simulator sandbox... it can write to its own container, not host /tmp.

Attach to xcresult and extract — straightforward:
```
let shot = XCUIScreen.main.screenshot()
let att = XCTAttachment(screenshot: shot); att.lifetime = .keepAlways; add(att)
```
then `xcrun xcresulttool export attachments --path ... --output-path /tmp/att`.

Let me do that: add a temporary test? I'd rather keep it as a permanent "visual snapshot" test? That adds noise. Alternatively temporarily add, run, then delete.

Given effort, maybe simpler: capture screenshot from the UI test run already executed? No attachments.

I'll temporarily add a test file `BizScanUITests/SnapshotUITests.swift`, run it, extract, then delete the file.

Actually — simpler idea: `xcrun simctl` has `spawn` … no touch. There's `idb` not installed.

OK do the temp test approach.

Looks very close to the design. Differences vs Figma:

1. Design top bar: title 18/600, star, ellipsis — matches. Blue extends under status bar — matches.
2. Avatar: design has 66 circle with letter; ours matches.
3. 查看原图: ours shows icon+text in green box; design has 42x34 rounded rect with icon and text below. Ours looks similar (box with icon inside, label below) — good.
4. Quick actions: design buttons are colored circles with white icons; ours matches, disabled ones gray.
5. Group row icon: design uses user-round outline; ours person.crop.circle — acceptable.
6. Contact rows spacing looks similar.
7. Bottom button disabled dim green — per design it's solid green; we disabled it (0022). Fine, noted.
8. Notes block missing because David has no notes — expected.

One issue: the separator between 核心资料 and 分组 — design has 8pt gap with #171819; ours 8 gap. Good.

Another: design phone row shows hint "原始识别内容，可在编辑中修正" and 待核对 badge — 0021.

Also in design, quick action labels are 13 #B5B8BD; ours ok.

Now cleanup: delete SnapshotUITests.swift (temporary), regenerate project, then write docs + commit.

Also should I keep the snapshot test? Delete per comment.

Then update docs: traceability T13/T14 → 0020, new T26–T28; README P8; verify doc; tasks checkboxes; commit.

Also verification-debt: DetailViewModelTests count 6 → now 10? count: testLoadPopulatesContactEntries, testAvatarInitialFallsBackToCompany, testQuickActionURLsFollowFieldPresence, testToggleFavoritePersists, testCancelEditing, testSaveWrites, testDeleteRemoves, testNotesCanBeAdded, testAddTagThenSave = 9. Let me count precisely: 1 load, 2 avatar, 3 quickAction, 4 toggleFavorite, 5 cancelEditing, 6 saveWrites, 7 deleteRemoves, 8 notes, 9 addTag → 9.

Let me delete temp test and regenerate.

Wait — PersistenceTests for isFavorite wasn't added (task 1.3). Let me add a quick test for favorite persistence in PersistenceTests, since tasks listed it. Check PersistenceTests structure quickly and add.

Also need to re-run full verify after deleting temp test (project regenerated). The last full run included SnapshotUITests? No—it ran before adding it. After adding, I only ran it individually. Deleting restores previous state; the full verify result (25 tests) is valid for current code except the CardList assert fix... wait the 25-test run was AFTER the fix. Yes: full verify passed with 25 UI tests after the email-row fix. Then I added snapshot test (removed). So code state = verified state. Good, but PersistenceTests addition needs a re-run of unit scope.

Let me add favorite persistence test now, then run unit scope, then docs.

Note makeSchema uses only BusinessCardEntity + TagEntity — missing CardGroupEntity; Repository save with group could fail? It passed earlier. 0017 didn't update this. Add CardGroupEntity to schema for correctness.

Add favorite persistence test + update schema.

 

Also T12 row references `testReloadSortsByUpdatedAtDescending` which was renamed → update to testReloadSortsByCreatedAtDescending. Let me fix that.

Then README P8, verification-debt (DetailViewModelTests 6→9, add DetailView row, add real-device URL check), tasks checkboxes, validate, commit.

0020 已完成并提交（`17abee6`）。详情页现在与 Figma 稿对齐，实拍对照见下。

## 本轮交付

**代码**
- 自绘 92pt 蓝色 `#176FD1` 顶栏：返回、标题 18/600、收藏星标、更多菜单
- 核心资料卡：66pt 姓氏头像（姓名首字 → 公司首字 → 「名」）、姓名 28/600、职务、公司
- 「查看原图」入口 + [CardImageViewer.swift](file:///Users/admin/Desktop/BizScan/BizScan/Views/Components/CardImageViewer.swift)（缩放、下滑/点击关闭）；无图自动隐藏
- 4 个快捷操作：电话 `tel:`、地址 `maps://`、备注滚动定位、编辑；缺数据置灰
- 分组行、备注卡、联系方式行（图标 + 字段名 + Mobile/办公/传真胶囊 + 16pt 值 + 行内铅笔）
- 固定底部「存入通讯录」（禁用态，0022 接线）
- 新增 `isFavorite` 字段并持久化

**过程中修掉的两个问题**
1. `isFavorite` 无默认值导致旧 `default.store` 轻量迁移失败、启动 `fatalError` → 改为 `var isFavorite: Bool = false`
2. 全屏查看器根节点加了 `accessibilityIdentifier` 后子元素被折叠，UI 测试找不到关闭按钮 → 移除容器标识

**验证**
- core 62 + L2 77 + UI 25 全绿，`openspec validate --all --strict` 15 项通过
- 新增 T26（核心资料与快捷操作）、T27（收藏持久化）、T28（查看原图）
- 报告：[0020-detail-redesign.md](file:///Users/admin/Desktop/BizScan/docs/verify/0020-detail-redesign.md)

**已登记偏差**：待核对胶囊（0021）、底部按钮禁用态（0022）、系统拨号/邮件/地图真机未验。

## 剩余

| 增量 | 内容 |
|---|---|
| 0021 | OCR/解析置信度落「待核对」值 + 详情橙胶囊与提示 |
| 0022 | `Contacts` 写入系统通讯录、去重、权限引导 |

下一步做 0021？

---

**User**

已登记偏差 ：待核对胶囊（0021）、底部按钮禁用态（0022）、系统拨号/邮件/地图真机未验。

这是怎么回事？是后面的任务？

**Assistant**

User asks about the "已登记偏差" list — what do they mean, are they later tasks?

Answer briefly: yes, first two are follow-up changes (0021, 0022) already planned. The third is not a task but a verification gap: URL generation is unit-tested, but actual system app launching can't be verified in simulator (no Phone/Mail/Maps apps on simulator); needs a real device manual checklist.

Explain each precisely, with what's left and why. Keep concise.

Also clarify: 0021 will add the 待核对 capsule (design element visible in 那张稿), 0022 enables the green button. The third one is a verification debt item, not a feature gap; can be closed by manual device test — add to manual-device-checklist.md if not already.

Let me verify if manual checklist has an entry; earlier the debt doc mentions sections. I'll just answer; optionally offer to add checklist item. I won't run tools unnecessarily... Actually a quick check would make the answer accurate: does docs/verify/manual-device-checklist.md mention 拨号? Let me grep quickly.

## 三类事项，性质不同

### 1. 「待核对」胶囊 → 确实属于后续任务（0021）

设计稿中电话那一行显示橙色 `待核对` 标签和「原始识别内容，可在编辑中修正」。它需要由识别链路提供依据：保存名片时记录哪些值置信度低，并在详情页为对应值显示标签。

0020 只做了详情页布局，没有这个数据来源，所以这一处**刻意留空**，并已写进 0021 范围：

- 模型新增 `unverifiedValues`
- 判定：OCR `confidence < 0.7`，或解析诊断 `ambiguous / invalidFormat`，只针对电话、邮箱、地址
- 编辑修正后自动剔除

### 2. 底部按钮禁用态 → 确实属于后续任务（0022）

设计稿的「存入通讯录」是实心绿按钮，当前显示为 40% 透明、不可点击，因为**写系统通讯录的能力还没实现**。0022 会加入 `ContactsService`（权限、字段映射、去重、结果提示），届时按钮恢复实心并真正生效。

如果先把它做成可点击但无动作，会让用户以为已存入，所以选择先禁用。

### 3. 拨号 / 邮件 / 地图真机未验 → 不属于后续功能，是**验证空缺**

功能代码已经写完（`tel://`、`mailto:`、`https://`、`maps://?q=`），单测也验证了 URL 生成正确。但**模拟器上根本没有电话、邮件、地图 App**，点击后系统无法响应，所以只能在真机人工验证。

这不是没做，而是无测试环境，属于 AGENTS.md 要求登记 `docs/verification-debt.md` 的证据空缺。刚才查了 [manual-device-checklist.md](file:///Users/admin/Desktop/BizScan/docs/verify/manual-device-checklist.md)，现有 8 个真机检查项里**没有**「详情页外部跳转」这一节，需要补一节。

## 一句话总结

| 事项 | 性质 | 处理 |
|---|---|---|
| 待核对胶囊 | 功能缺口 | 0021 实现 |
| 按钮禁用 | 功能缺口 | 0022 实现后启用 |
| 拨号/邮件/地图 | 验证空缺 | 补真机人工清单，不是写代码 |

要我现在把「真机外部跳转」补进 [manual-device-checklist.md](file:///Users/admin/Desktop/BizScan/docs/verify/manual-device-checklist.md)，还是直接开始 0021？

---

**User**

直接开始 0021

**Assistant**

Start 0021: review flags (待核对).

Plan:
1. OpenSpec change 0021-review-flags: proposal/design/tasks/specs (card-model ADDED unverifiedValues; card-detail MODIFIED 联系方式 to include 待核对 capsule + hint).
2. Implement:
   - Core: `unverifiedValues: [String]` on BusinessCard (default []).
   - Entity: `unverifiedValues: [String] = []`.
   - Judgement: `UnverifiedValueDetector` in Core? Better in Core so unit-testable without app: takes ParsedCard + observations → returns [String]. Let me look at ParsedCard & ScanResult & ParsingDiagnostics to design.
3. ReviewViewModel: compute on save (needs observations/diagnostics from ScanResult). Check ScanResult fields.
4. Detail: show 待核对 capsule when entry value in unverifiedValues; hint text.
5. Tests: Core detector tests; ReviewViewModel test; DetailViewModel test; UI test T29/T30? T30 requires editing to fix — UI test: seed a card with unverifiedValues? Simpler UI: seed David's mobile as unverified, assert capsule shows; then edit value and save, assert capsule gone. That covers T29/T30 in UI.

Let me look at ScanResult / ParsedCard / parser diagnostics.

Design detector in Core: `UnverifiedValueDetector.detect(parsed: ParsedCard, observations: [OCRObservation], threshold: Float = 0.7) -> [String]`.

Rules: for phone/email/address values:
1. OCR low confidence: an observation whose text contains the value (or value contains observation text) with confidence < threshold.
2. Parsing diagnostics with reason ambiguous/invalidFormat for field mobile/officePhone/fax/email/address, line containing the value.

Simplify: build from diagnostics + observations:
- For each parsed value in [mobiles, officePhones, faxes, emails, address]:
  - if any diagnostic with field matching OR line containing value, and reason in {ambiguous, invalidFormat} → add.
  - if any observation with confidence < threshold whose text contains value (or value contains text after normalization) → add.

Careful: FieldKind enum — check its cases.

Let me check FieldKind.

Now ReviewViewModel: add detectedUnverifiedValues and write on save with intersection.

Note: `ReviewViewModel` is used for editing too? DetailViewModel handles editing for saved cards; ReviewViewModel(existingCard:) used maybe in re-scan flows. Keep.

Implement:
- stored property `private let detectedUnverifiedValues: [String]`
- in init after parsed set: compute.
- in save: compute current values set, filter, assign card.unverifiedValues.

Also DetailViewModel.save: filter unverifiedValues against current values (in case user fixed value there).

Bug: in DetailViewModel.save, `retainedUnverifiedValues(in: card)` is called with the *new* card (already updated fields), so it computes current values from the new card — correct (drops stale values). Good.

Now ContactEntry needsReview + view rendering.

ContactEntry: add `needsReview: Bool`. Build entries with `card.unverifiedValues.contains(value)`.

Then DetailView contactRow: after 字段名 + badge, add 待核对 capsule when needsReview; and hint text below value.

Colors: amber #E7AB52 text on #3B3021. Theme has amber & amberSurface.

Add AppCopy.reviewBadge = "待核对", reviewHint = "原始识别内容，可在编辑中修正".

Now tests:
1. Core test `UnverifiedValueDetectorTests` in Packages/BizScanCore/Tests/BizScanCoreTests/.
2. ReviewViewModelTests: need a ScanResult with observations with low confidence. Check how existing tests construct ScanResult.
3. DetailViewModelTests: needsReview true/false.
4. Seed: David's mobile as unverified → but David's seeded mobile is "+86 138 0000 0000" (looks valid). To mirror design's "13504119bile" case, add unverifiedValues to David's mobile in seed. That makes T29 UI test feasible; T30 edit → change number.

Let's check ReviewViewModelTests helper for making ScanResult.

TestSupport.makeTemporaryContainer uses schema without CardGroupEntity — update to include it (PersistenceTests' own reopen uses its own schema; but the initial container from TestSupport lacks CardGroupEntity, and repository.save might insert CardGroupEntity → would fail. It worked because tests didn't pass group. Add it for correctness.

Also add `observations` param to makeScanResult for the low-confidence test.

Plan for tests:
- Core: UnverifiedValueDetectorTests — 5 tests.
- ReviewViewModelTests: add test `testLowConfidencePhoneIsPersistedAsUnverified`: build ScanResult with observations low confidence containing the phone. Need makeScanResult to accept observations. Add param `observations: [OCRObservation] = []`.
- Also test fix removes: save with phone "13504119bile" low conf → stored unverified contains it; then set mobilesText to "13504119001", save → unverified empty.
- DetailViewModelTests: needsReview flags.
- UI: seed David mobile unverified. But T29 asserts badge; then T30 edit phone. Editing phone in UI: mobile field is multiline TextField (we saw focus issues). Hmm. T30 via UI would be flaky.

Alternative for UI: verify badge presence (T29) and verify clearing at L2 (DetailViewModelTests). Register T30 as L2-only evidence. That's acceptable per repo practice (部分通过 with L2).

Let me implement.

Seed: add `unverifiedValues: ["+86 138 0000 0000"]` to David? That would make T29 pass but also affects nothing else. But semantically weird since value is well-formed; it's test data, fine. Better: give David "13504119bile" to mirror design? That changes T13/T26 assertions? T26 doesn't assert phone. CardList T13 doesn't assert phone. DetailUITests T26 doesn't. But call button still enabled (digits exist "13504119" + ...). Hmm "13504119bile" digits = 13504119 → tel works.

Safer: keep David phone as is, just mark unverified. T29 asserts badge exists for mobile-0. T30 at L2.

Let me write Core tests first.

Now seed David with unverifiedValues, and add UI test T29 (badge) + T30 L2-only (registered).

Seed edit: add `unverifiedValues: ["+86 138 0000 0000"]` to David. Hmm, but that means the "待核对" hint appears. Good for demo too.

Wait: David's phone formatted "+86 138 0000 0000". unverifiedValues must match exactly. Fine.

Then DetailUITests testT29: open David → assert staticTexts["待核对"] exists and hint exists.

Careful: T26 asserts things; unaffected.

Also PersistenceTests: add unverifiedValues restart assertion? tasks 2.2. Add to testT18DataSurvivesContainerReopen card with unverifiedValues and assert.

Let's do it.

All green: core 69, L2 81, UI 26.

Now docs: traceability T29/T30, verify doc, README, tasks, validate, commit.

Get log name.

0021 已完成并提交（`37723d8`）。

## 交付内容

**判定逻辑（Core）**
新增 [UnverifiedValueDetector.swift](file:///Users/admin/Desktop/BizScan/Packages/BizScanCore/Sources/BizScanCore/UnverifiedValueDetector.swift)，只检查电话、邮箱、地址三类值，命中任一条件即标记：

- OCR 置信度 < 0.7（`0.69` 命中、`0.71` 不命中，有边界单测）
- 解析诊断 `ambiguous` 或 `invalidFormat`，且诊断字段与值同类

只标记已写入模型的真实值，不生成新值，符合「不虚构」约束。

**数据与链路**
- `BusinessCard.unverifiedValues: [String]`、实体同名字段（带默认值，轻量迁移）
- `ReviewViewModel` 初始化时计算，保存时与当前字段值**取交集**，用户改正号码后旧标记自动消失

**详情展示**
联系方式行在字段名后追加橙色 `#E7AB52` / `#3B3021` 的「待核对」胶囊，值下方显示「原始识别内容，可在编辑中修正」。

**验证**
- core 69 + L2 81 + UI 26 全绿，`openspec validate --all --strict` 16 项通过
- T29 有 UI 用例（种子数据带待核对号码）
- T30 仅有 L2：手机号是多行 `TextField`，在 Form 中无法稳定获得键盘焦点，已登记验证债

**报告**：[0021-review-flags.md](file:///Users/admin/Desktop/BizScan/docs/verify/0021-review-flags.md)

## 剩余

只剩 **0022 存入通讯录**：`ContactsService`（权限申请、`CNSaveRequest` 写入、同姓名+号码去重、成功/已存在/未授权三态反馈），并启用底部绿色按钮。要现在开始吗？

---

**User**

好的，开始 0022

**Assistant**

Start 0022: save to contacts.

Steps:
1. Scaffold openspec change 0022-save-to-contacts: proposal/design/tasks/specs. Spec delta: card-detail ADDED "存入系统通讯录" requirement with T31/T32/T33.
2. Implement:
   - `ContactsService` protocol + `CNContactStoreContactsService` using Contacts framework.
   - Mapping: `ContactsMapper` pure function BusinessCard -> CNMutableContact (testable without Contacts? CNMutableContact is in Contacts framework; unit tests can construct).
   - Dedup: fetch contacts with same name/phone → decide `.alreadyExists`.
   - DetailViewModel: state (idle/saving/saved/alreadyExists/denied), action.
   - DetailView: enable button; show states.
   - Info.plist usage description already exists. Good.
3. Tests: unit tests for mapper + ViewModel using a fake service; UI test can't grant contacts permission in simulator easily? Simulator: contacts permission dialog — XCUITest can handle addUIInterruptionMonitor, but flaky. Better: L2 with injected fake service (protocol), UI test asserts button enabled. Register T31/T32/T33 as L2 + manual checklist for real device.

Design: 
```swift
enum ContactsSaveResult { case saved, alreadyExists }
enum ContactsServiceError: LocalizedError { case denied, failed(String) }

protocol ContactsSaving {
    func save(_ card: BusinessCard) async throws -> ContactsSaveResult
}
```
DetailViewModel @MainActor; saveToContacts() async; states: `isSavingToContacts`, `contactsMessage: String?`.

Detail button label changes: 存入通讯录 → 已存入通讯录 (disabled briefly?) design has just 存入通讯录; keep label and show feedback via alert or transient toast. Simpler: after success, set `didSaveToContacts = true` → button label「已存入」disabled. For alreadyExists → alert message「该联系人已在通讯录中」. For denied → alert with 「前往设置」.

Contacts mapping details:
- givenName: name (single string; split? keep whole as givenName when no space; for Chinese full name, use givenName)
- organizationName: company
- jobTitle
- departmentName
- phoneNumbers: mobiles .mobile, officePhones .work, faxes .workFax
- emailAddresses .work
- urlAddresses website
- postalAddresses with street: address, postalCode
- note: notes (requires entitlement on iOS? CNContact.note requires com.apple.developer.contacts.notes entitlement — better skip notes)

Dedup: fetch by name predicate then compare phone digits. If match → alreadyExists.

Implementation with CNContactStore:
```swift
final class SystemContactsService: ContactsSaving {
    func save(_ card: BusinessCard) async throws -> ContactsSaveResult {
        let granted = try await requestAccess()
        guard granted else { throw ContactsServiceError.denied }
        let contact = ContactsMapper.makeContact(card)
        if try existingContactExists(for: card) { return .alreadyExists }
        let request = CNSaveRequest(); request.add(contact, toContainerWithIdentifier: nil)
        try store.execute(request)
        return .saved
    }
}
```

Threading: CNContactStore execute is sync; run on background via `withCheckedThrowingContinuation` + DispatchQueue. Keep simple: mark service as nonisolated func with Task.detached? For tests we use fake anyway.

Info.plist: NSContactsUsageDescription exists in project.yml. Good.

Also add a "已存入" persistence? Design doesn't require. Keep session-only, documented.

Let me write files.

Merge mapper into same file (I named file ContactsService.swift containing mapper). Proposal said two files; fine, one file is simpler — but tasks mention ContactsMapper file. Keep single file, adjust docs later (docs not critical to match exactly; but tasks list 1.1 as new ContactsMapper — it exists as enum in this file). OK.

Now AppEnvironment injection.

Now DetailViewModel: add contacts state + saveToContacts(using:). It needs the service; DetailViewModel currently constructed with repository + imageStore. Pass contactsService via init (optional param default nil? Better required, update DetailView construction). Also SearchView → DetailView constructs DetailView(cardID:) which uses environment. So just update DetailView's construction of viewModel to pass environment.contactsService.

Add:
```swift
private let contactsService: ContactsSaving
init(cardID:repository:imageStore:contactsService:)
var isSavingToContacts = false
var didSaveToContacts = false
var contactsMessage: String?
var contactsNeedsSettings = false

func saveToContacts() { guard let card, !isSavingToContacts, !didSaveToContacts else { return }
  isSavingToContacts = true
  Task { defer { isSavingToContacts = false }
    do {
      let result = try await contactsService.save(card)
      switch result { case .saved: didSaveToContacts = true
      case .alreadyExists: contactsMessage = "该联系人已在通讯录中" }
    } catch ContactsServiceError.denied { contactsNeedsSettings = true }
    catch { contactsMessage = error.localizedDescription }
  }
}
```

Since @MainActor class, Task inherits main actor. Fine.

Tests: DetailViewModelTests need contactsService param — default value? Provide default `contactsService: ContactsSaving = NoopContactsService()`? Simpler: make it optional with default nil and only saveToContacts guards. But tests for the 3 paths need injection. Use default parameter `contactsService: ContactsSaving? = nil`. Hmm protocol existential default nil creates optional since ContactsSaving is a protocol — `= nil` works with `ContactsSaving?`.

But cleaner: require it; update the 9 places constructing DetailViewModel in tests. That's churn but explicit. Compromise: default parameter `contactsService: ContactsSaving = UnavailableContactsService()`. I'd rather avoid a fake in production code.

Given tests construct DetailViewModel many times, a default of nil is pragmatic:
`init(cardID:repository:imageStore:contactsService: ContactsSaving? = nil)` and `saveToContacts` requires non-nil else sets error message.

Hmm, silently no-op is bad. Let me instead update tests to pass a fake. There are ~8 constructions in DetailViewModelTests. Use sed to add param? Constructions span multiple lines:
```
let viewModel = DetailViewModel(
    cardID: card.id,
    repository: repository,
    imageStore: InMemoryImageStore()
)
```
I can add `contactsService: FakeContactsService()` via sed replacing `imageStore: InMemoryImageStore()\n        )` → add line. Multi-line sed is tricky; use perl -0pi.

Do that after creating fake in tests.

Implementation of ViewModel requires non-optional ContactsSaving. Let's write.

Now DetailView: pass contactsService, footer enabled with 3 states, alerts.

Also existing Alert for errorMessage. Add:
- alert for contactsMessage
- alert for contactsNeedsSettings with 前往设置 (open settings) + cancel

Footer:
```swift
private var footer: some View {
  Button { viewModel?.saveToContacts() } label: {
    Text(footerTitle)
      .font(.system(size: 16, weight: .semibold))
      .foregroundStyle(Theme.textPrimaryDetail)
      .frame(maxWidth:.infinity).frame(height:47)
      .background(RoundedRectangle(cornerRadius:12).fill(Theme.green.opacity(footerEnabled ? 1 : 0.4)))
  }
  .disabled(!footerEnabled)
  ...
}
private var footerTitle: String { if didSave -> saved; if saving -> saving; else 存入通讯录 }
private var footerEnabled: Bool { !(saving || saved) }
```
footer needs viewModel; make it a func footer(_ viewModel: DetailViewModel).

Need openURL for settings: use `@Environment(\.openURL)` with URL(string: UIApplication.openSettingsURLString).

Let me edit DetailView.

Now update all DetailViewModel constructions in tests (9) to include contactsService. Create `FakeContactsService` in TestSupport.

Fake:
```swift
@MainActor
final class FakeContactsService: ContactsSaving {
    var result: ContactsSaveResult = .saved
    var error: Error?
    private(set) var savedCards: [BusinessCard] = []
    func save(_ card: BusinessCard) async throws -> ContactsSaveResult {
        if let error { throw error }
        savedCards.append(card)
        return result
    }
}
```
Where to put? TestSupport.swift (test target). TestSupport imports BizScanCore + @testable BizScan.

Then in DetailViewModelTests add `contactsService: FakeContactsService()` to each init. Use perl multi-line replace on pattern:
`imageStore: InMemoryImageStore()\n        )` → `imageStore: InMemoryImageStore(),\n            contactsService: FakeContactsService()\n        )`
Careful: DetailViewModelTests uses that exact form? Let me check some lines: yes `imageStore: InMemoryImageStore()\n        )` appears. But indentation may vary. Let me grep.

Also DetailViewModel constructed elsewhere: SearchView? no. Only DetailView (updated) and tests.

Add tests for three paths.

Also UI test T26 asserts SaveToContacts exists; now enabled. Add assertion enabled in T26. And a UI test where tapping triggers permission dialog — could hang. Avoid tapping in UI. Keep L2.

Let me implement.

Oops, the TestSupport doc comment got merged: line 88 "/// 在临时目录下建一个真实落盘的 SwiftData 容器。    /// 「重建同一 URL 的容器」..." — my first edit removed a newline. Fix that.

Also DetailViewModelTests now has 12 injections but DetailViewModel constructions — 12 means all good (there were 12? previously 9 tests + 3 new = 12). Fine.

Fix TestSupport comment.

Default parameter `SystemContactsService()` is evaluated in nonisolated default-argument context. Fix: make default nil and construct inside init body (AppEnvironment is @MainActor).

```swift
init(repository:imageStore:contactsService: ContactsSaving? = nil) {
    self.contactsService = contactsService ?? SystemContactsService()
}
```

---

**User**

继续

**Assistant**

The error is that default parameter `SystemContactsService()` is main-actor isolated but called in a synchronous nonisolated default-argument context. Actually AppEnvironment is @MainActor, but default arguments are evaluated in nonisolated context in Swift 5.9? Let me fix by making it optional default nil.

Change init signature to:

```swift
init(repository:imageStore:contactsService: ContactsSaving? = nil) {
    ...
    self.contactsService = contactsService ?? SystemContactsService()
}
```

But `SystemContactsService()` inside init body of @MainActor class is fine.

Let me apply.

---

**User**

继续

**Assistant**

Now let's capture a screenshot of the detail page with enabled green button, then finish docs.

Let me check the manual-device-checklist and add a contacts section, then write verify report, update traceability, README, tasks, and commit.

Also worth verifying the app launches with enabled green button — take a screenshot.

Let me first add checklist section.

Now capture a screenshot of the detail page to confirm green button enabled. Let's create temp snapshot test again? Simpler: install app and launch, then use simctl + navigate? Can't tap via simctl. Use the temporary snapshot UI test approach.

Actually let me just run a temp UI test to screenshot the detail. I'll recreate SnapshotUITests, run, extract, read, then delete.

Screenshot shows: 待核对 badge on phone with hint, and the green enabled "存入通讯录" button. 

Now delete the temp snapshot test, regenerate project, write verify docs, update traceability, README, verification-debt, tasks, commit.

Note: address quick action is disabled in screenshot — because David's card has address? Wait the address quick button is greyed. In the earlier detail screenshot (0020) it was also greyed. David seeded card has no address field! Looking at seed: David has name, company, jobTitle, mobiles, officePhones, emails, website, tags, group — no address, no notes. So address and notes disabled. That's consistent.

Now finalize.

Error: {"code":4028,"message":"Upstream request failed: [overloaded] the server is overloaded; retry shortly (HTTP Status: 429)"}

---

**User**

继续

**Assistant**

Continue with docs: write verify report, update traceability (T31-T33), README, verification-debt, tasks; run final verify maybe (already did full verify before snapshot test addition; snapshot test removed so code unchanged except docs). Then commit.

Let me get log filename.

0022 已完成并提交（`3a12a79`）。**P8 全部 6 个增量收官。**

## 本轮交付

**服务层**
- [ContactsService.swift](file:///Users/admin/Desktop/BizScan/BizScan/Services/ContactsService.swift)：`ContactsSaving` 协议 + `SystemContactsService`
  - 权限：`authorizationStatus` 分支处理，`notDetermined` 走 `requestAccess`
  - 去重：`predicateForContacts(matchingName:)` + 号码/邮箱归一后比对，命中返回 `.alreadyExists`
  - 写入：`CNSaveRequest`，手机→Mobile、办公电话/传真→Work、邮箱/网址/地址→Work
- `ContactsMapper`：纯映射函数，不写 `note`（需额外 entitlement）

**UI**
底部按钮从禁用占位改为实心绿可点，三态：存入通讯录 → 存入中…（60% 透明）→ 已存入；未授权弹「需要通讯录权限」带「前往设置」。

**验证**
- core 69 + L2 89 + UI 26 全绿，`openspec validate --all --strict` 17 项通过
- 修了一个编译问题：`@MainActor` 的 `SystemContactsService()` 不能作默认参数，改为 `ContactsSaving? = nil` 后在 init 体内构造
- 真机清单补了第 8b 节（T31/T32/T33 + T26 外部跳转），并加入回填表

**截图确认**：详情页同屏可见橙色「待核对」胶囊 + 提示文案 + 实心绿「存入通讯录」。

## P8 整体回顾

| 增量 | 内容 | 验证 |
|---|---|---|
| 0017 | 分组模型、分组管理、主页/详情接入 | core 62 + L2 67 + UI 17 |
| 0018 | `originalImagePath` 可空、手动新建 | core 62 + L2 71 + UI 19 |
| 0019 | 主页 1:1（深色、日期分组、居中 FAB） | core 62 + L2 73 + UI 21 |
| 0020 | 详情 1:1（蓝顶栏、头像卡、快捷操作、收藏） | core 62 + L2 77 + UI 25 |
| 0021 | 待核对标签（置信度 < 0.7 / 歧义） | core 69 + L2 81 + UI 26 |
| 0022 | 存入系统通讯录 | core 69 + L2 89 + UI 26 |

## 仍未闭环的验证债

- **T30**：编辑修正后待核对消失，只有 L2（多行 `TextField` 焦点问题）
- **T31–T33**：真实通讯录写入/权限/去重，需真机
- **T26 外部跳转**：拨号、地图、邮件、浏览器需真机
- 既有：T03–T05 相机权限与拍摄、T18 真机 kill、T19 分享面板

这些都在 [verification-debt.md](file:///Users/admin/Desktop/BizScan/docs/verification-debt.md) 和 [manual-device-checklist.md](file:///Users/admin/Desktop/BizScan/docs/verify/manual-device-checklist.md) 里登记，需要一台真机跑一遍才能关闭。

另外，6 个 change 都还未归档（`openspec archive`），按仓库规则需你批准后执行。要现在归档吗？

---

**User**

点击电话不能跳转到拨号？在我点击地址，会跳转到导航，这是正常的，但是点击电话却不行。调查

**Assistant**

Let's investigate. The phone URL: `tel://+8613800000000`. In iOS simulator there's no phone app so it won't work — but on device it should. But maybe the issue is URL construction with `tel://+86...` — the `+` might need encoding. Actually `tel://+86138...` — URL(string:) with `//` creates host `+86138...`, and `+` in host is technically allowed? Hmm, `tel://` makes empty host then path. Apple recommends `tel:+86138...` or `telprompt:`. Using `tel://` with `+` may result in nil URL. Let's verify: `URL(string: "tel://+8613800000000")` → probably valid, host "+8613800000000". Hmm, "+" is allowed in host? RFC 3986 reg-name allows sub-delims, `+` is a sub-delim, so valid.

But on real device `tel://123` works. Actually the standard is `tel:123`. With `tel://`, iOS historically works too but there are known issues where `tel://` + `+` fails because the URL is interpreted as host and the leading `+` gets stripped? Let me think about what actual user reports: "点击地址，会跳转到导航，这是正常的，但是点击电话却不行" — so address works (maps://) but phone doesn't. Probably user tested on a real device or simulator? If simulator, no phone app — mailto also wouldn't work. Let's check whether the phone button is disabled maybe? The phone value "+86 138 0000 0000" filters to "+8613800000000" digits non-empty → URL exists. Hmm.

Wait — maybe the issue is `openURL` from SwiftUI environment when both `tel:` and something... Actually another likely bug: in DetailView, the quick action button is wrapped: `.disabled(!enabled)` fine. But the value button `.disabled(viewModel.actionURL(for: entry) == nil)`.

Let me actually test URL creation quickly with swift on macOS.

Also possible: `tel://` scheme requires the URL to not have `//`. Known iOS behavior: `tel://` works, `tel://` with `+` may fail silently. Many StackOverflow answers: use `tel://` and it works. But some say `tel://+` doesn't work while `tel:+` works.

Let me investigate empirically-ish: check code, then decide to change to `tel:` + allowed characters, and percent-encoding issues.

Let me use swift to check `URL(string: "tel://+8613800000000")` and `URL(string: "tel:+8613800000000")`.

Also let me check the simulator: does the phone button appear enabled? From screenshot, "电话" circle is green (enabled) and label black-ish? Actually label "电话" appears dark gray, others grey. Hmm in screenshot the phone label "电话" is dark (#... it's grey). Colors: enabled label uses textSecondaryDetail (#B5B8BD). Looking at screenshot: 电话 label appears grey-white-ish; 地址/备注 grey. Fine.

So URL exists. Then tapping does openURL. On simulator, tel: fails → nothing happens. But user says address works, jumping to navigation. In simulator, maps works (Maps app exists). Phone doesn't exist. So this could be purely simulator limitation! But the user may be testing on device.

We should investigate: check whether it's simulator-only. Let me verify SDK behavior. Best: add a fallback? Actually `tel:` on iOS uses `tel:` scheme; `tel://` is also accepted. Let me test URL validity in Swift.

Let me run swift snippet.

URL parses fine. So the problem is likely that iOS treats `tel://+8613800000000` as `tel` with host `+8613800000000`; when opening, the system may not handle the `//` form correctly on modern iOS. Known: `tel://` works on iOS in many cases, but `tel:` is canonical. Also `+` in host might be dropped/encoded → number becomes "8613800000000"? Or worse, `openURL` fails.

Second possibility: `openURL` in SwiftUI environment — for `tel:` it's fine.

Another possibility: SwiftUI `Menu`/`Button` — no.

Third possibility: On the simulator, there is no Phone app, so `openURL` does nothing. Address works because Maps exists. If the user tested in simulator, this is expected. But the user says "点击地址，会跳转到导航" — in the simulator Maps app opens, yes. So it's very plausible they tested in the simulator.

But we should still fix real-device correctness: use canonical `tel:` form and sanitize the number (remove spaces/dashes, keep leading +). Apple's docs recommend `tel:` scheme. Many reports: `tel://` works but the `+` gets percent-encoded? Let's test in simulator whether openURL of tel: does anything — nothing to see since no Phone app.

Best approach: 
1. Change to `tel:+8613800000000` (no `//`).
2. Add `UIApplication.shared.canOpenURL` check? In SwiftUI, `@Environment(\.openURL)` returns OpenURLAction; can't check canOpen. Could use `UIApplication.shared.canOpenURL` before calling, and if false show a fallback (copy number to clipboard + toast). That's beyond scope maybe, but a useful robust fix.

Actually there's a subtle real bug: `tel://+8613800000000` — on device iOS will attempt to call but the `//` form makes "+86..." the host, and iOS may treat host case-insensitively but also may strip. Historically, using `tel://` works; but some sources say on iOS 10+ `tel://` works.

Let me look for a more concrete issue: In `quickAction` I used `Button(action: action)` with `.disabled(!enabled)` — fine.

Wait — maybe the real issue: in the contact row, the value button is inside a `Button` wrapper? No.

Hmm, another candidate: `openURL` with a `tel:` URL from a SwiftUI view inside a ScrollView — works.

I think the most likely explanation: simulator has no Phone app → tapping does nothing; address works because Maps exists. The right action: (a) fix to canonical `tel:` scheme, (b) add `canOpenURL` guard + feedback so users on iPad/simulator get a clear message instead of silent no-op, (c) verify

---

**User**

你说的对，模拟器没有拨号。现在还缺什么

**Assistant**

User acknowledges simulator has no phone. Now asks: "现在还缺什么" — what else is missing.

I should report on the gap list: verification debts (real device items), plus remaining functional gaps relative to design, plus archival of changes, plus light-mode, etc. Also possibly the plan doc mentioned items: R5 favorites list, etc. Let me be concise and structured.

Let me quickly verify current state: are there unresolved deltas like 0019's icon difference, tags hidden but editable, etc. Also check git status clean, changes unarchived.

Let me check git status and openspec list to be accurate.

## 现状：功能已经齐了，缺口分三类

### 1. 必须在真机上验证（模拟器无法解决）

| 项 | 现状 | 怎么办 |
|---|---|---|
| 电话拨号 / 邮件 / 地图 / 浏览器 | 只验证了生成的 URL 正确（`tel:` / `mailto:` / `maps://` / `https://`） | 模拟器没有电话 App，只能真机点击一次 |
| T31–T33 存入通讯录 | 逻辑与字段映射有单元测试，但真实写入、权限弹窗、去重比对没有实测 | 真机上跑 [manual-device-checklist.md](file:///Users/admin/Desktop/BizScan/docs/verify/manual-device-checklist.md) 第 8b 节 |
| T03–T05 相机权限与拍摄 | 一直没有执行 | 真机清单第 1–4 节 |
| T18 杀进程 | 已在模拟器用 terminate/relaunch 验证，真机 kill 尚未做 | 清单第 7 节 |
| T19 分享面板 | 只验证了 vCard 内容 | 清单第 8 节 |

### 2. 设计稿上还有差异（不改不影响使用）

- **空状态图标**：用系统 `person.text.rectangle` 线稿，不是稿子的定制图标；要 1:1 需从 Figma 导出 `7:348` 的「空名片图示」矢量节点
- **分组行是下拉菜单**：稿子没标注交互，我保留了下拉；如果稿子是静态文本，需要改
- **「已存入」不持久化**：退出详情再进来会复位成「存入通讯录」，设计没定义这个状态
- **姓名整串写入 `givenName`**：中英文都不拆姓/名
- **写入通讯录不包含备注**：iOS 写 `note` 需要额外 entitlement

### 3. 明确排除在本次范围外（需要新需求再开 change）

- 浅色主题（设计只给了深色）
- 收藏列表页（只有星标状态，主页没有「收藏」筛选）
- 标签彻底下线（现在数据保留、仅编辑页可见）
- 通讯录分组（`CNGroup`）、双向同步
- 按 `updatedAt` 排序（现在按 `createdAt` 日期分组）

### 4. 流程上还差一步：归档

`openspec/changes/` 下 6 个 change（0017–0022）都还在待归档状态，代码和验证报告都已提交。按仓库规则，归档需要你批准，执行 `openspec archive <id>` 会把增量规范合并进 `openspec/specs/`。

## 建议顺序

1. **先归档 6 个 change**（纯文档操作，风险低，能让 specs 与实现一致）
2. 把真机清单跑一遍，回填 [docs/verify/manual-device-checklist.md](file:///Users/admin/Desktop/BizScan/docs/verify/manual-device-checklist.md) 第 9 节，关闭对应验证债
3. 需要 1:1 的话，最后补空状态矢量图标和分组行样式

要现在归档吗？

---

**User**

前三个都不需要继续进行可以停止。归档

**Assistant**

Archive the 6 changes. Use openspec archive <id> — but note archive typically requires interactive prompt? Use --yes if supported. Let's check help.

All archived. Now validate all specs and check the merged specs for sanity (e.g. card-list spec should have new requirements, card-model sorted, etc.).

Also need to check whether archived tasks all completed — yes all checked.

Then commit. Also update README? README P8 says completed. Maybe mention archived. Let me validate.

Merged specs look sane. But card-model's "数据模型" table (lines 7-31) still may not include new fields (group, isFavorite, unverifiedValues) since the change didn't include the table modification. Let me check the table — it's a table not a requirement, and OpenSpec merge only handles requirements. The table says fields... Since archived 0018 noted "originalImagePath 由必填改为有图必填、无图可空" in requirement text but table row may still say 是. Let me read it and fix the table to stay coherent (specs should match implementation per AGENTS §8/README Gate G7). This is a small doc consistency fix, allowed post-archive? AGENTS says spec table changes must go via change's MODIFIED Requirements... "字段增删、类型变化必须通过 change 的 `## MODIFIED Requirements` 表达，禁止直接修改本节。" Hmm, the table itself says don't modify directly. But since changes are archived and table now inconsistent, strictly we should open a new change. But that's heavy for doc-only. The repo convention: "若 change 只是实现既有基线规范、不改变行为合同，必须在 .openspec.yaml 写 skip_specs: true". 

Options: report the inconsistency, and ask whether to open a small doc-only change to sync the table. Better: do a minimal new change? That adds 6 more changes... The user said "前三个都不需要继续进行可以停止。归档" meaning stop after archiving.

I'll verify the table state and report honestly, offering to fix in a follow-up change. Let me read the table.

As suspected: the data-model table is stale (missing `group`, `isFavorite`, `unverifiedValues`; `originalImagePath` still marked 必填). It explicitly forbids direct edits — changes to it must go through a change's MODIFIED Requirements. However, the requirement for T34 does describe it, and the table is narrative. To keep specs consistent with implementation (README G7 gate), I should open a small doc-only change, e.g. `0023-sync-card-model-table`, with `skip_specs`? No — it needs spec delta to update the table. Hmm, OpenSpec deltas operate on requirements only, not arbitrary tables. The table lives under "## 数据模型" not a requirement, so a delta can't update it... The rule says field changes must be expressed via `## MODIFIED Requirements` — meaning the table itself is descriptive and the authoritative contract is the requirement section? Yet the table explicitly is "字段契约".

Practical approach: since the table cannot be updated by delta mechanism, and the requirement "名片记录结构" already carries the authoritative statement, I should note the inconsistency to the user and propose directly updating the table as a doc sync (with a rationale in commit message), or ask. User said stop after archiving, so I'll report and ask.

Actually, it's probably better to just fix the table now — it's a documentation inconsistency that misrepresents the contract, and the repo gate G7 requires specs match implementation. But AGENTS.md §1 forbids the agent from "直接修改基线规范" (modifying baseline specs directly) — only archive merges. Hmm, this is a bundled constraint: agent may not directly modify baseline specs. Archive was done via command, that's fine.

So: report, propose a follow-up. Since user wants to stop, I'll report the leftover and ask whether to sync.

Let me commit the archival first.

归档完成并已提交（`85c7771`）。

## 结果

| 项 | 状态 |
|---|---|
| 6 个 change 移入 archive | `2026-11-06-0017` ～ `2026-11-06-0022` |
| 增量规范合并进基线 | `card-list` +4、`card-detail` +6、`card-model` +3 / 改 2、`search-tags` 标签管理→编辑保留、`card-model` 排序改 `createdAt` |
| `openspec/changes/` | 只剩 `archive/`，无待归档增量 |
| `openspec validate --all --strict` | 11 项通过，无残留 `## ADDED/MODIFIED` 头 |
| 工作区 | 干净 |

## 需要记一笔的遗留

合并后我发现 [card-model/spec.md](file:///Users/admin/Desktop/BizScan/openspec/specs/card-model/spec.md#L11-L30) 开头的「数据模型」表格**没跟着变**：

- 缺 `group`、`isFavorite`、`unverifiedValues` 三个字段
- `originalImagePath` 仍标为「必填」

原因是该表不是 Requirement 块，OpenSpec 的 delta 机制只能改 Requirement，改不到表格。而 AGENTS.md 禁止 AI 直接改基线规范，所以我没有动手。

**影响**：只是文档与实现不一致，代码行为正确，`card-model` 的 Requirement 正文已经准确描述了新契约。

**修复方式**：需要开一个 doc-only 的 change（写 `MODIFIED Requirements` 并在其中重述字段契约，或按仓库约定用 `skip_specs` 说明），由你批准后执行。要现在补吗？还是先搁置？

---

