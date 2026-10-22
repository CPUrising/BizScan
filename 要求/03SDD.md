# **智能体编码（Agentic Coding****）与规格驱动开发（SDD****）范式研究及其在 Trae/OpenSpec** **中的 iOS** **工程落地实践**

## **智能体编码（Agentic Coding****）的新一代软件工程范式**

软件工程范式正经历自高级语言发明与自动化测试普及以来最深刻的变革1。生成式人工智能在代码编写领域的应用，经历了从“代码补全助手（Copilot）”到“氛围编程（Vibe Coding）”，再到“智能体编码（Agentic Coding）”的演进路线1。

氛围编程（Vibe Coding）依靠开发者向大语言模型提供模糊、提示词驱动的自然语言描述，由模型通过单轮或多轮对话直接生成代码原型1。这种模式在从零到一的新项目快速原型验证中表现出极高的吞吐效率，但在应对企业级大系统、长周期演进以及复杂业务逻辑时，迅速遭遇了工程瓶颈2。由于对话上下文窗口的限制以及大语言模型的概率生成特性，随着对话轮次的增加，系统面临严重的“上下文漂移（Context Drift）”与意图衰减问题2。散落于聊天记录中的需求无法被有效版本化，导致模型生成的代码产生非预期侧效应，测试失败率与返工率大幅攀升2。

智能体编码（Agentic Coding）作为新一代软件工程范式应运而生2。智能体编码不再将大语言模型仅仅视为文本生成器，而是将其作为具备感知、规划、工具调用、状态观测与自我修正能力的自主智能体核心2。在此范式下，开发者的核心职责从编写具体代码语法，转变为设计系统语义与设定工程约束2。

智能体编码通过闭环循环的方式执行复杂工程任务2。在感知阶段，智能体主动读取代码库上下文、配置文件、抽象语法树及历史变更文档5。在规划阶段，智能体将高层级需求拆解为结构化的细粒度任务链2。在执行阶段，智能体调用编译器、重构工具、版本控制系统或外部接口执行修改2。在观测与反思阶段，智能体运行单元测试或构建脚本，并在遇到错误时抓取堆栈日志自动重构代码，完成闭环自愈2。

为了更清晰地对比演进过程，下表对三种开发范式的核心要素进行了系统性梳理：



| **维度**          | **传统开发范式**                 | **氛围编程 (Vibe Coding)**      | **智能体编码 (Agentic   Coding)**         |
| ----------------- | -------------------------------- | ------------------------------- | ----------------------------------------- |
| **人类角色**      | 代码实现者与架构设计者           | 自然语言提示词编写者            | 系统语义设计者与约束审查者2               |
| **AI** **参与度** | 无或仅作单点语法补全             | 主导代码草稿生成（被动响应）    | 闭环执行工程任务（主动智能体）2           |
| **上下文管理**    | 人类大脑记忆与静态文档           | 易受污染的扁平对话上下文5       | 结构化、分层的动态上下文栈2               |
| **输出确定性**    | 高度确定，依赖人工测试与代码审查 | 低确定性，随机性强且易幻觉2     | 高确定性，由显性规范与自动化测试围栏约束2 |
| **应用场景**      | 全场景演进与维护                 | 简单小项目或原型验证4           | 复杂大系统、增量演进与企业级重构2         |
| **工程瓶颈**      | 人力吞吐极限与人工沟通成本       | 上下文漂移、无法应对长链路系统2 | 规范定义的精确度与智能体治理协议2         |



## **规格驱动开发（SDD****）的理论体系与大系统工程解法**

### **规格驱动开发（SDD****）的定义与本质**

为了解决智能体编码在缺乏约束时产生的自由发挥与非预期破坏问题，“规格驱动开发（Specification-Driven Development, SDD）”被确立为 AI 原生软件工程的核心方法论1。SDD 的核心哲学在于坚持规范先行，要求在编写任何代码之前，人类开发者与 AI 必须就构建目标达成结构化的契约2。在传统软件工程中，规格说明书往往表现为 Word 文档或 Wiki 页面，在代码编写完成后即沦为静态且快速腐化的文档2。而在 SDD 体系中，规范被提升为一种机器可读、可版本化、自动可验证的活文档（Living Documentation）与第一公民资产2。

SDD 的确定性建立在系统确定性之上，而非盲目依赖于大语言模型本身参数规模的提升2。该体系由三个核心支撑柱协同驱动：通过结构化的 Markdown 或 DSL 明确系统行为与验收标准的规范层、为智能体提供精准领域语义与环境拓扑的上下文层，以及将工程最佳实践固化为规划与验证编排闭环的工作流层2。

在整体架构运转中，人类架构师首先定义系统意图、边界与不可变约束2。这些意图被编译为可执行且可验证的增量规范8。智能体编码引擎结合工具与协议层（如 MCP 服务、语法解析器与构建工具）读取规范并执行代码重构7。最后，系统通过自动化测试与规范审计构建验证闭环，将验证通过的增量规范合并入主规范库，形成持续演进的系统资产5。



### **SDD** **如何解决大型系统的工程挑战**

大型企业级系统在引入 AI 编码时，通常面临上下文超载、遗留业务逻辑破损风险以及团队协作意图偏差三大工程挑战2。大语言模型通常具备固定大小的上下文窗口（如 130,000 至 200,000 Token），随意的聊天对话会迅速充斥无效噪声并导致生成质量下降5。SDD 通过引入“增量规范（Delta Specs）”模式建立了严格的上下文卫生机制，智能体在每次变更时仅加载与该变更相关的局部增量 Spec 以及全局项目基线，大幅降低 Token 开销并消除上下文漂移4。

针对已有系统（1→n）的演进安全问题，氛围编程极易在缺乏全局视角的状况下破坏隐藏的业务规则4。SDD 强制在改动代码前进行意图锁定，将对原系统的修改显式声明为新增、修改或废弃规范8。智能体在编码过程中将 Spec 作为不可违背的指令执行，保证了对既有代码库的非破坏性演进7。此外，SDD 实现了审查前置的工程设计4。在任何代码被编写前，人类架构师首先审查并批准 AI 生成的变更提案、技术方案与任务清单，使得代码审查的重心从后置的代码语法检查转移为前置的逻辑契约确认，显著降低了返工成本4。



### **SDD** **的 3** **层 AI** **协议架构体系**

为将 AI 智能体从单点编码助手提升为可信的系统成员，SDD 体系构建了三层协议架构模型2：

第一层是模型上下文协议（MCP），它定义了 AI 模型与外部环境（如 IDE、文件系统、数据库、语法解析器及构建工具）之间的标准化交互接口，使智能体能够安全、结构化地获取上下文与调用本地工具2。

第二层是智能体间协作协议（A2A），它确立了多智能体协同工作的通讯规范，明确专职规划智能体、代码编写智能体与测试审查智能体之间的契约与状态传递方式2。

第三层是智能体与用户交互协议（AG-UI），它提供实时、可视化的交互界面，允许人类开发者在智能体规划、任务分解与代码生成阶段进行实时干预、打断与确认，确保人机协同过程透明可控2。



### **SDD** **的全生命周期闭环与能力模型**

在 SDD 范式下，软件开发生命周期被重构成五阶段的自动化闭环：规范制定（Specify）、架构规划（Plan）、任务拆解（Tasks）、实现与自愈测试（Implement & Test）以及部署归档（Deploy）2。

在规范制定阶段，人类与 AI 共同完成结构化需求分析并输出精确的场景文档2。在架构规划阶段，AI 评估改动影响范围并生成符合项目架构的技术方案2。在任务拆解阶段，方案被细化为无歧义、按顺序排列的原子化任务清单2。在实现与测试阶段，智能体逐项执行任务，调用本地测试套件，并在捕获失败时自我纠错修复，直至通过所有断言2。最后在部署与归档阶段，验证通过的增量规范被自动合并回主规范库，完成系统状态更新7。支撑该闭环的核心能力模型包括结构化任务拆解能力、智能上下文工程能力、标准化交付体系能力、测试驱动自愈能力以及质量驱动的持续优化能力2。



## **OpenSpec** **框架原理与 Trae AI IDE** **的融合机制**

### **OpenSpec** **的设计哲学与目录规范**

OpenSpec 是由 Fission AI 推出的轻量级规范驱动开发开源框架4。OpenSpec 不依赖复杂数据库或云端服务，完全基于本地文件系统与 Markdown 文本格式，天然适配 Git 版本控制系统，其本质是对软件变更意图进行版本控制7。

在一个启用 OpenSpec 的工程中，根目录下会自动维护一个 openspec/ 架构体系8。其中，openspec/project.md 保存全局项目上下文、技术栈约束与编码规范8；openspec/AGENTS.md 保存智能体通用的交互指南与操作规程8；openspec/specs/ 目录存放系统当前的单一真实源规范库，按功能模块划分为不同的子目录7；而 openspec/changes/ 目录则作为活性变更沙箱，存放所有未完成的 Feature 或 Bugfix 变更目录4。每个独立变更目录下均包含变更意图文档 proposal.md、技术设计文档 design.md、原子化任务清单 tasks.md 以及记录规格增量的 specs/ 目录4。



### **OpenSpec** **的增量规范语法规范**

为了让大语言模型与命令行工具能够无歧义地解析变更，OpenSpec 严格规定了增量规范的语法结构8。需求标识符统一使用三级标题 ### Requirement: [名称] 作为全局唯一匹配键8。在增量规范文件中，通过二级标题明确标记变更类型：## ADDED Requirements 用于新增独立功能，## MODIFIED Requirements 用于修改现有需求（必须提供更新后的完整需求文本以保证覆盖），## REMOVED Requirements 用于标记废弃需求，而 ## RENAMED Requirements 则用于需求重命名8。每个需求下必须包含至少一个使用四级标题标记的测试场景 #### Scenario: [场景名称]，内部采用标准的 BDD 谓词语法（包含 GIVEN 前置条件、WHEN 触发动作、THEN 预期结果及 AND 补充断言）8。



### **Trae AI IDE** **与 OpenSpec** **的深层融合路径**

Trae 是新一代 AI 原生 IDE，具备强劲的系统文件读写、Agent 独立思考与命令行交互能力。Trae 与 OpenSpec 的结合落地可以通过两种机制实现：

一种是基于 Trae Skills 与 Commands 的原生斜杠命令配置14。OpenSpec CLI 在初始化时会自动在项目中生成针对 Trae 的专用技能描述与命令映射文件9。对于不支持动态技能加载的 Trae 版本，可以将 OpenSpec 的全局指导原则复制填入 Trae 的项目规则（Project Rules）配置面板中，使 Trae 在启动对话时自动加载 OpenSpec 上下文16。

另一种是基于 MCP 工具套件的图形化集成10。通过引入 trae-openspec-mcp 服务，Trae 可以直接以 MCP 工具调用的方式暴露 OpenSpec 核心能力，开发人员无需在终端输入命令，即可在 UI 界面中通过自然语言直接触发项目生成、规范编译、代码优化与验证10。

下表列出了上层调用的四个核心工作流斜杠命令（Slash Commands）及其底层机制：



| **命令 (Slash Command)** | **阶段 (Phase)**         | **CLI** **底层行为与智能体动作**                          | **产出物/****状态变更**                         |
| ------------------------ | ------------------------ | --------------------------------------------------------- | ----------------------------------------------- |
| /opsx:propose [id]       | **Plan (****规划阶段)**  | 读取基线文档与主规范，分析需求，生成变更沙箱5。           | 创建 changes/[id]/ 目录及相关草稿文件4。        |
| /opsx:apply [id]         | **Build (****构建阶段)** | 智能体逐行读取任务清单，参照增量规范编写代码并更新状态4。 | 更改本地工程代码文件，更新 tasks.md 完成标记4。 |
| /opsx:verify [id]        | **Check (****验证阶段)** | 对照 Spec 场景审查生成代码，执行单元测试并报告偏离项5。   | 输出包含偏离等级的验证报告5。                   |
| /opsx:archive [id]       | **Merge (****合并阶段)** | 调用归档命令，合并增量规范至主规范库，清理变更沙箱7。     | 更新 openspec/specs/，保持主规范库最新7。       |



## **iOS** **移动应用开发实战：在 Trae** **中使用 OpenSpec** **遵循 SDD** **的完整案例**

下文以一个真实的 iOS 原生应用开发为例，演示如何在 Trae IDE 环境中，基于 OpenSpec 框架与 Swift / SwiftUI 技术栈，使用 SDD 方法论完成一个功能的增量开发。

### **业务场景定义**

案例项目名称为 FocusCraft（一款基于 SwiftUI 的 iOS 专注计时器应用）。当前的演进需求为：在现有的 25 分钟固定专注模式基础上，新增自定义专注时长设置功能，允许用户选择 15 分钟、45 分钟、90 分钟预设或滑动自定义分钟数，并实现持久化存储与倒计时逻辑更新6。



### **第一阶段：项目基线与上下文初始化**

在 Trae 中打开 iOS 项目后，首先在终端安装并初始化 OpenSpec 环境：

Bash

npm install -g @fission-ai/openspec@latest
 openspec init

 

在提示选择 AI 工具时选择 Trae，系统自动生成工程基线文档 openspec/project.md，明确 iOS 团队的技术架构约束：



# **FocusCraft iOS Project Context**

## **Tech Stack**

- Platform: iOS 17.0+
- Language: Swift 5.9
- UI Framework: SwiftUI
- Architecture: MVVM + Observation Framework (@Observable)
- Persistence: UserDefaults / SwiftData



## **Engineering Standards**

- All UI components must support Dark Mode and Dynamic Type.
- Business state MUST be isolated within @Observable ViewModels.
- Views MUST rely on state, no direct imperative modifications     allowed.
- Thread management: Async operations use Swift Concurrency     (async/await, MainActor).

同时，主规范文件 openspec/specs/timer/spec.md 中保存着系统的既有基线规范：



# **Timer Capability Spec**

### **Requirement: Fixed Duration Countdown**

The system SHALL support a fixed 25-minute countdown for focus sessions.

#### **Scenario: Start standard session**

- GIVEN     the timer is in idle state
- WHEN     the user taps "Start Focus"
- THEN     the countdown SHALL begin from 1500 seconds
- AND     the display SHALL update every second.



### **第二阶段：发起变更提案与规范设计**

开发者在 Trae AI Chat 窗口中输入斜杠命令或自然语言发起提案：/opsx:propose add-custom-duration。Trae 结合 OpenSpec 自动创建变更沙箱目录 openspec/changes/add-custom-duration/，并生成相关文档草稿。

变更提案文件 openspec/changes/add-custom-duration/proposal.md 内容如下：



# **Proposal: Custom Duration Selection for Focus Timer**

## **Intent**

Allow users to select custom focus session lengths (15m, 45m, 90m or custom input) to support dynamic work habits beyond the rigid 25-minute Pomodoro limit.



## **Scope**

- In Scope:
- Add DurationPicker view component in SwiftUI.
- Update TimerViewModel to handle dynamically configured     durations.
- Persist chosen duration in UserDefaults     (selected_duration_minutes).
- Out of Scope:
- Multiple timer concurrent sequences.
- iCloud sync for duration presets.

技术设计文件 openspec/changes/add-custom-duration/design.md 内容如下：



# **Technical Design: Custom Duration Selection**

## **Architecture Changes**

- Introduce FocusDuration enum with cases .fifteen, .fortyFive,     .ninety, .custom(Int).
- Refactor TimerViewModel to store selectedDuration:     FocusDuration.
- Store raw minutes integer into UserDefaults under key     "user_focus_duration".



## **Performance & State Impact**

- Low impact. Thread safety ensured via @MainActor on     TimerViewModel.

增量规范文件 openspec/changes/add-custom-duration/specs/timer/spec.md 精确标注了对原有规范的修改与新增：



# **Timer Capability Spec Deltas**

## **MODIFIED Requirements**

### **Requirement: Fixed Duration Countdown**

The system SHALL support dynamic target durations instead of a rigid 25-minute limit.

#### **Scenario: Start custom session**

- GIVEN     the user has selected a custom duration of 45 minutes
- WHEN     the user taps "Start Focus"
- THEN     the countdown SHALL begin from 2700 seconds
- AND     the timer display SHALL reflect "45:00".



## **ADDED Requirements**

### **Requirement: Duration Preference Persistence**

The system SHALL persist the user's selected duration across app launches.

#### **Scenario: Save user selected preset**

- WHEN     the user selects 90 minutes in the DurationPicker
- THEN     the system SHALL write 90 to UserDefaults
- AND     on next app launch, the initial duration SHALL be automatically     initialized to 90 minutes.

任务清单文件 openspec/changes/add-custom-duration/tasks.md 列出了原子化步骤：



# **Implementation Checklist**

☐   Task 1: Create FocusDuration model in Models/FocusDuration.swift

☐   Task 2: Update TimerViewModel.swift to support dynamic durations and UserDefaults read/write

☐   Task 3: Build DurationPickerView.swift using SwiftUI Segmented Picker

☐   Task 4: Integrate DurationPickerView into main FocusView.swift

☐   Task 5: Write Unit Tests in FocusCraftTests/TimerViewModelTests.swift validating countdown math and state persistence

人类架构师在终端运行 openspec validate add-custom-duration --strict，校验通过后进入下一步9。

### **第三阶段：智能体受控代码生成**

开发者在 Trae 中输入命令 /opsx:apply add-custom-duration。Trae 作为自主智能体，读取 tasks.md 并按顺序分步修改代码7。

Trae 修改后的 ViewModels/TimerViewModel.swift 文件内容如下：

Swift

import Foundation
 import SwiftUI
 import Observation

@Observable
 @MainActor
 final class TimerViewModel {
 private static let userDefaultsKey = "user_focus_duration"

 var remainingSeconds: Int
 var isRunning: Bool = false
 var selectedMinutes: Int {
 didSet {
 UserDefaults.standard.set(selectedMinutes, forKey: Self.userDefaultsKey)
 if !isRunning {
 remainingSeconds = selectedMinutes * 60
 }
 }
 }

 init() {
 let savedMinutes = UserDefaults.standard.integer(forKey: Self.userDefaultsKey)
 let initialMinutes = savedMinutes > 0 ? savedMinutes : 25
 self.selectedMinutes = initialMinutes
 self.remainingSeconds = initialMinutes * 60
 }

 func startTimer() {
 isRunning = true
 }

 func selectPreset(_ minutes: Int) {
 guard !isRunning else { return }
 self.selectedMinutes = minutes
 }
 }

 

Trae 按照 project.md 约定的 SwiftUI 标准生成了视图组件 Views/DurationPickerView.swift：

Swift

import SwiftUI

struct DurationPickerView: View {
 @Bindable var viewModel: TimerViewModel
 let presets = [15, 25, 45, 90]

 var body: some View {
 HStack(spacing: 12) {
 ForEach(presets, id: .self) { minutes in
 Button(action: {
 viewModel.selectPreset(minutes)
 }) {
 Text("(minutes)m")
 .font(.subheadline)
 .fontWeight(viewModel.selectedMinutes == minutes ? .bold : .regular)
 .padding(.vertical, 8)
 .padding(.horizontal, 16)
 .background(viewModel.selectedMinutes == minutes ? Color.blue : Color(.secondarySystemBackground))
 .foregroundColor(viewModel.selectedMinutes == minutes ? .white : .primary)
 .cornerRadius(8)
 }
 .disabled(viewModel.isRunning)
 }
 }
 }
 }

 

每完成一个任务，Trae 均会在 tasks.md 中自动勾选对应完成项4。



### **第四阶段：代码验证与自愈**

开发者输入命令 /opsx:verify add-custom-duration 触发审计5。Trae 自动启动后台编译器并执行 xcodebuild test 套件2。若测试抓取到边界条件逻辑异常（例如 UserDefaults 未初始化时返回 0 导致倒计时异常），Trae 会捕获测试堆栈信息，触发智能体自愈循环，对照 Spec 规约修改 TimerViewModel.swift 中的兜底逻辑，并重新运行测试直至全部通过2。测试通过后输出审计报告：



# **Verification Results for change: add-custom-duration**

- [PASS]     Requirement: Dynamic Duration Countdown
- Scenario: Start     custom session -> Verified via TimerViewModelTests.testCountdownMath()
- [PASS]     Requirement: Duration Preference Persistence
- Scenario: Save     user selected preset -> Verified via     TimerViewModelTests.testPersistence()

Status: ALL CRITERIA SATISFIED. Ready for archive.

### **第五阶段：变更合并与主规范库归档**

在测试通过后，开发者输入 /opsx:archive add-custom-duration 批准归档4。Trae 调用底层归档命令，提取增量规范内容，原位替换主规范 openspec/specs/timer/spec.md 中的对应章节，追加新增需求，并自动清理删除变更沙箱目录7。归档后的主规范文件被自动更新为：



# **Timer Capability Spec (Updated Base Spec)**

### **Requirement: Fixed Duration Countdown**

The system SHALL support dynamic target durations instead of a rigid 25-minute limit.

#### **Scenario: Start custom session**

- GIVEN     the user has selected a custom duration of 45 minutes
- WHEN     the user taps "Start Focus"
- THEN     the countdown SHALL begin from 2700 seconds
- AND     the timer display SHALL reflect "45:00".



### **Requirement: Duration Preference Persistence**

The system SHALL persist the user's selected duration across app launches.

#### **Scenario: Save user selected preset**

- WHEN the user selects 90 minutes in the DurationPicker
- THEN the system SHALL write 90 to UserDefaults
- AND on next app launch, the initial duration SHALL be     automatically initialized to 90 minutes.



## **结论与战略展望**

智能体编码与规格驱动开发的结合，代表了软件工程走向工业化与自动化的关键跨越2。通过将不可控的提示词随机性转化为可审查、机器可读的 Markdown 规范资产，SDD 系统性解决了大语言模型在大规模工程项目中面临的意图衰减、上下文污染与既有代码库破坏问题2。

在以 Trae IDE 和 OpenSpec 为代表的新一代开发环境中，代码不再是研发交付流程中唯一的绝对核心，“规范即代码”的时代正加速到来2。软件工程师的角色正在从编写语法细节的机械劳动者，演变为定义系统语义、编写结构化约束并审查智能体行为的工程架构师2。率先建立符合 SDD 范式的规范资产库与基础设施，将是企业构建下一代高吞吐、高可靠软件研发生产力的核心竞争要素2。

#### **引用的著作**

1. AI 大模型编程的软件开发范式：SDD（Specification-Driven,     https://blog.csdn.net/Autumn_horse/article/details/159169095
2. 规范驱动开发（SDD）简介：从氛围编程到SDD     | Jimmy Song, https://jimmysong.io/zh/book/ai-handbook/sdd/overview/
3. Agentic Coding: GSD vs Spec     Kit vs OpenSpec vs Taskmaster AI, https://medium.com/@richardhightower/agentic-coding-gsd-vs-spec-kit-vs-openspec-vs-taskmaster-ai-where-sdd-tools-diverge-0414dcb97e46
4. OpenSpec/README_OLD.md at main     · Fission-AI ... - GitHub, https://github.com/Fission-AI/OpenSpec/blob/main/README_OLD.md
5. Stop Vibe Coding. Start     Building with OpenSpec. | by Abhinav Dobhal, https://medium.com/@abhinav.dobhal/stop-vibe-coding-start-building-with-openspec-b713cc6bb475
6. TRAE使用openspec     (20251023,openspec暂不支持TRAE情况下) 原创, https://blog.csdn.net/qq_30632605/article/details/153780412
7. OpenSpec Deep Dive:     Spec-Driven Development Architecture, https://redreamality.com/garden/notes/openspec-guide/
8. OpenSpec/openspec/specs/openspec-conventions/spec.md     at main, https://github.com/Fission-AI/OpenSpec/blob/main/openspec/specs/openspec-conventions/spec.md
9. OpenSpec Cheatsheet - Rushi's,     https://www.rushis.com/openspec-cheatsheet/
10. trae-openspec-mcp规范编程工具 -     GitHub, https://github.com/leon30083/trae-openspec-mcp
11. openspec/AGENTS.md · main ·     coopmaths / apps / comptoir · GitLab, https://forge.apps.education.fr/coopmaths/apps/comptoir/-/blob/main/openspec/AGENTS.md
12. OpenSpec Directory Layout and     Workflow | comol/ai_rules_1c, https://deepwiki.com/comol/ai_rules_1c/7.1-openspec-directory-layout-and-workflow
13. Master OpenSpec in the AI Era:     A Practical Guide to SDD (Spec, https://rexai.top/en/tutorials/openspec-sdd-intro/
14. OpenSpec使用说明 - 腾讯云开发者社区, https://developer.cloud.tencent.com/article/2647250
15. OpenSpec/docs/supported-tools.md     at main - GitHub, https://github.com/Fission-AI/OpenSpec/blob/main/docs/supported-tools.md
16. OpenSpec 功能详解：5 分钟搞懂AI 编程的"规范驱动"核心 - 博客园, https://www.cnblogs.com/zh94/p/19503921