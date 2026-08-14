# TASK-0003：重构 Onboarding 导航归属

- status: awaiting_acceptance
- type: Standard
- created_at: 2026-08-14
- accepted_at: 2026-08-14
- accepted_by: maintainer
- acceptance_basis: 维护者明确要求按已确认的 Welcome → Onboarding → Completed → TabBar 逻辑继续修改
- started_at: 2026-08-14
- implementation_completed_at: 2026-08-14
- revision_started_at: 2026-08-14
- revision_completed_at: 2026-08-14

## 目标

让 Onboarding 流程持有唯一的 `NavigationStack` 和导航路径，由根状态只负责在 onboarding 与主 TabBar 两个 App 阶段之间切换，避免根级位移动画干扰 Tab 内 `navigationTitle` 的首次布局。

## 范围

- 新增 `iOSTG/Core/Onboarding/OnboardingView.swift`，集中持有 Onboarding 导航栈与路径。
- 将 `WelcomeView` 改为只通过回调请求进入下一页。
- 将 `CompletedView` 改为只通过回调报告完成。
- 将 `AppState` 明确为 onboarding/main 阶段状态，并继续兼容现有持久化键。
- 调整 `AppView` 与 `AppViewFactory`，移除根级 `.move` transition 和整棵视图树动画。
- 在不移动 TabBar 导航树的前提下，让 Onboarding 页面层以左右方向滑入/滑出，恢复阶段切换动画。
- 调整 `SettingsView` 的退出入口，使其回到 onboarding 阶段。
- 保留 Explore、Chats、Profile 各自独立的 `NavigationStack`。

## 非目标

- 本任务不新增教程、引导等具体 Onboarding 页面，只为后续页面提供稳定路由所有权。
- 不调整 TabBar 的视觉样式、页面内容或各 Tab 内部导航结构。
- 不新增第三方依赖，不修改项目构建设置。
- 不提交、不暂存、不推送任何 Git 变更。
- 不改变现有 UserDefaults 持久化键，避免已安装用户状态失效。

## Agent 工作包

### 可以执行

- 在本任务范围内最小修改上述 Swift 文件。
- 使用 `/tmp` 下的 DerivedData 运行 Simulator 构建。
- 使用本地模拟器验证完整用户路径与标题首次布局。
- 将验证证据和最终状态回写本 Task 及 AIDEV 投影文件。

### 执行前需再次询问

- 删除现有页面或改变产品流程。
- 修改本任务范围外的业务逻辑、依赖或项目设置。
- 执行 Git 暂存、提交或推送。

## 执行顺序

1. 独立写入并重读本 Task。
2. 将本 Task 状态更新为 `in_progress`，同步当前工作投影。
3. 实现 Onboarding 路由所有权和根 App 阶段切换。
4. 运行静态检查与 Simulator 构建。
5. 在模拟器验证首次流程、持久化流程与标题布局。
6. 回写证据；满足完成条件后更新为 `completed`。

## 完成条件

- `WelcomeView` 和 `CompletedView` 不再持有或直接操作全局导航状态。
- Onboarding 流程只有一个明确所有者管理 `NavigationStack` 和路径。
- 根视图只在 onboarding/main 阶段间切换，且没有根级位移动画。
- Onboarding → TabBar 与退出返回 Onboarding 均有方向明确的页面切换动画。
- Welcome → Completed → TabBar 首次进入后，Explore 标题无需切换 Tab 即处于正确位置。
- 退出后可重新进入 Onboarding；完成状态可持久化并在重新启动后进入 TabBar。
- iOS Simulator 构建通过，且未覆盖用户现有未提交改动。

## 来源

- `AGENTS.md`
- `.aidev/DECISIONS/DEC-0002-task-first.md`
- `iOSTG/Core/AppView/AppView.swift`
- `iOSTG/Core/AppView/AppState.swift`
- `iOSTG/Core/AppView/AppViewFactory.swift`
- `iOSTG/Core/Welcome/WelcomeView.swift`
- `iOSTG/Core/Onboarding/Completed/CompletedView.swift`
- `iOSTG/Core/Settings/SettingsView.swift`

## 证据

- `swiftlint lint --quiet`：通过，17 个 Swift 文件共 0 violations。
- `xcodebuild -project iOSTG.xcodeproj -scheme iOSTG -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/iostg-task-0003-derived build CODE_SIGNING_ALLOWED=NO`：`BUILD SUCCEEDED`。
- iPhone 17 Pro Max Simulator（iOS 26.5，UDID `BD5B5722-FE89-4C5E-9F47-E58DA10E4820`）运行验证：Welcome → Completed → Finished → Explore 完整通过。
- 点击 Finished 后等待 2.5 秒且未切换 Tab，Explore 大标题首次布局处于正确安全区位置。
- 强制终止并重新启动 App 后仍直接进入 TabBar，完成状态持久化通过。
- Profile → Settings → Sign Out 后返回 Welcome，重启 Onboarding 路径通过。
- `git diff --check`：通过。

## 验收反馈与修订

- 2026-08-14：维护者确认标题问题已修复，但指出 Onboarding 与 TabBar 之间原有的左右切换动画丢失。
- 修订策略：只对 Onboarding 页面层应用方向 transition；TabBar 及其各自 `NavigationStack` 保持在最终布局位置，避免重新引入首次标题错位。
- 本轮修订完成后需重新执行 SwiftLint、Simulator 构建、正向切换、反向切换和首次标题布局验证。
- 修订后 `swiftlint lint --quiet`：通过，17 个 Swift 文件共 0 violations。
- 修订后 Simulator Debug 构建：`BUILD SUCCEEDED`。
- 正向动画中间帧确认 Completed 页面层向左滑出并露出 TabBar；动画结束后 Explore 标题首次布局正确。
- 反向动画中间帧确认 Welcome 从左侧滑入并覆盖主界面；动画结束后停留在 Welcome。
- 修订后 `git diff --check`：通过。

## 交接

- 本轮动画修订和重新验证已完成，等待维护者检查模拟器效果后验收；维护者验收前保持 `awaiting_acceptance`。
