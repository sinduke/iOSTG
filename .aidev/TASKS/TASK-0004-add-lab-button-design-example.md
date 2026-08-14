# TASK-0004：新增 Lab 与 Button Design 完整示例

- status: awaiting_acceptance
- type: Standard
- created_at: 2026-08-14
- accepted_at: 2026-08-14
- accepted_by: maintainer
- acceptance_basis: 维护者明确要求即使基础设施暂时空转，也提供完整可运行的示例、介绍和使用说明，并通过新增 TabBar 页面与 List 展示 Button Design
- started_at: 2026-08-14
- awaiting_acceptance_at: 2026-08-14
- resumed_at: 2026-08-14
- child_task: TASK-0004A1

## 目标

在不接入现有 Onboarding、Explore、Chats、Profile 业务逻辑的前提下，为 iOSTG 新增独立的 `Lab` Tab。Lab 使用 List 组织可运行的架构示例，第一项为 `Button Design`，用于完整展示从 SwiftUI `Button` 到 Interaction、Execution、Domain Event 与 Observation 的边界、现场行为和使用方式。

## 范围

- 在现有 `TabBarView` 中新增 `Lab` Tab，不改变原有三个 Tab 的页面和导航所有权。
- 新增独立 `LabView`，由该 Tab 自己持有 `NavigationStack`，并通过 List 进入示例详情。
- 新增 `Button Design` 示例页面，包含介绍、可操作按钮、执行状态、事件时间线、架构原则和使用代码。
- 在隔离的 Example 命名空间/目录中提供完整但不连接真实 Analytics、API 或业务服务的参考实现：
  - typed `InteractionIntent` / Context；
  - `InteractionEvent`、`ExecutionEvent`、`DomainEvent` 三类独立事实；
  - `ExecutionRequest`、Policy 与 `OperationExecutor`；
  - 白名单 Observation Projection；
  - `ObservationRecord`、Reporter、No-op 与内存 Sink；
  - SwiftUI `AppButton` adapter 与 async-exclusive 演示。
- 新增仓库级中文使用文档，说明设计目标、文件结构、运行方式、演进边界和非生产限制。
- 为关键事件顺序和互斥策略补充局部测试（在当前测试环境允许的范围内）。

## 非目标

- 不把示例基础设施注入现有业务页面，也不替换当前 Welcome、Completed、Settings 等原生 Button。
- 不接入 Firebase、Amplitude、真实日志服务、网络 API、支付、认证或生产数据。
- 不宣称示例已经具备生产级持久队列、离线重试、合规审计或服务器幂等能力。
- 不新增第三方依赖，不修改 Target、Scheme、Build Configuration 或部署版本。
- 不重构现有业务目录、Tab 视觉风格或已完成的 Onboarding 导航逻辑。
- 不执行 Git stage、commit、push、tag 或发布。

## Agent 工作包

### 可以执行

- 新增 `iOSTG/Core/Lab/` 下的示例 UI 与隔离实现。
- 最小修改 `iOSTG/Core/TabbBar/TabBarView.swift` 增加 Lab Tab。
- 新增 `Documentation/Examples/ButtonDesign.md`。
- 新增只覆盖该示例的测试文件。
- 使用 `/tmp` DerivedData 运行 SwiftLint、build、test 和 Simulator 验证。
- 在 Codex 模拟器浏览器中验证 Lab → Button Design 的可达性和现场事件变化。

### 执行前需再次询问

- 将示例类型移动到现有业务基础设施或让业务页面依赖它。
- 增加真实 Analytics/API SDK、权限、持久化数据库或外部服务。
- 修改任务范围外的业务行为、工程配置或教程发布体系。
- 执行任何 Git 暂存、提交、推送、tag 或发布动作。

## 执行顺序

1. 独立写入并完整重读本 Task。
2. 将状态更新为 `in_progress`，同步 NOW、BOARD 与任务登记。
3. 实现 Lab Tab、示例列表和 Button Design 隔离代码。
4. 补充 App 内介绍/使用说明与仓库级文档。
5. 运行静态检查、构建和局部测试。
6. 在 Simulator 与浏览器镜像中验证真实入口、导航、按钮状态和事件时间线。
7. 回写证据并推进到 `awaiting_acceptance`。

## 完成条件

- TabBar 显示第四个 `Lab` Tab，且原有三个 Tab 行为不变。
- Lab List 至少包含可进入的 `Button Design` 示例项。
- 示例可以空转运行，不依赖真实业务或第三方 SDK，并能在页面内看到 Interaction/Execution/Domain 的观测记录。
- Async-exclusive 示例能够防止同 key 并发执行，并产生与 failed 不同的 rejected 记录。
- 示例明确区分 execution completed 与 domain success，不把二者混为同一事实。
- App 内与 Markdown 文档都能解释如何使用、为什么存在、当前限制及未来扩展点。
- SwiftLint 和 iOS Simulator build 通过；局部测试通过或准确记录无法运行的原因。
- Simulator 真实验证 Lab → Button Design 路径、按钮运行状态和事件时间线。
- 未覆盖或整理用户现有未提交改动。

## 来源

- `AGENTS.md`
- `.aidev/DECISIONS/DEC-0002-task-first.md`
- `iOSTG/Core/TabbBar/TabBarView.swift`
- `iOSTG/Core/Explore/ExploreView.swift`
- `iOSTG/Core/Chats/ChatsView.swift`
- `iOSTG/Core/Profile/ProfileView.swift`
- 维护者本轮关于完整空转示例、独立 Lab Tab、List 与 Button Design 的明确要求

## 证据

- `swiftlint lint --quiet`：通过，无 lint 输出。
- `xcodebuild -quiet -project iOSTG.xcodeproj -scheme iOSTG -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/iostg-task-0004-build CODE_SIGNING_ALLOWED=NO build`：通过。
- `xcodebuild -quiet ... -parallel-testing-enabled NO -only-testing:iOSTGTests/ButtonDesignExampleTests test`：通过，覆盖正常 execution 生命周期、async-exclusive 拒绝和三类事实的 kind 隔离。
- iPhone 17 Pro Max（iOS 26.5，`BD5B5722-FE89-4C5E-9F47-E58DA10E4820`）安装并启动成功。
- Codex 模拟器浏览器真实验证：完成 Onboarding 后第四个 `Lab` Tab 可见；`Lab → Button Design` 可达；正常按钮显示 `Execution completed`；竞争按钮显示 `Rejected by async-exclusive policy`；页面同时提供介绍、现场演示、Observation timeline、规则和用法。
- 子任务 TASK-0004A1 已完成：toolbar `Guide` 与底部 `Full Chinese Guide` 均可进入离线 WebKit 中文文档；6/6 定向测试和 Simulator 真实验证通过。
- 仅新增/修改 TASK-0004 范围内文件；用户原有未提交改动未被覆盖或整理，未执行 Git 暂存、提交或推送。

## 交接

- 主体和子任务 TASK-0004A1 均已完成实现与验证，等待维护者整体验收 `Lab → Button Design → Full Chinese Guide`。
- 示例明确保持 `EXPERIMENTAL` 且不连接现有业务；如果要迁入业务层，应新建 Task/ADR 并重新确定最小抽象范围。
