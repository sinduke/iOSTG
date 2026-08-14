# TASK-0004A1：为 Button Design 增加 WebKit 中文文档阅读器

- status: awaiting_acceptance
- type: Standard
- parent_task: TASK-0004
- created_at: 2026-08-14
- accepted_at: 2026-08-14
- accepted_by: maintainer
- acceptance_basis: 维护者确认 Full Chinese Guide 的 WebKit Markdown 阅读能力属于 TASK-0004 子任务，并指定命名为 TASK-0004A1
- started_at: 2026-08-14
- awaiting_acceptance_at: 2026-08-14

## 目标

在 TASK-0004 的独立 Lab 架构示例中，把 `Full Chinese Guide` 从静态路径提示升级为可点击入口。用户点击后，在 Lab 自己的 `NavigationStack` 内进入一个本地、离线、可阅读的 WebKit 文档页面，展示 `Documentation/Examples/ButtonDesign.md` 的完整中文内容。

## 范围

- 保留 `Documentation/Examples/ButtonDesign.md` 作为唯一 Markdown 正文来源。
- 将同一个 Markdown 文件显式加入 App Bundle，不维护第二份手工正文。
- 在 `Core/Lab/Documentation/` 中增加仅供 Lab 使用的文档加载、Markdown 转 HTML 和 WebKit 展示代码。
- 使用 iOS 26 原生 WebKit `WebPage` 与 SwiftUI `WebView`。
- 在 `ButtonDesignUsageGuide` 中增加 `Full Chinese Guide` NavigationLink。
- 提供 loading、loaded、failed 三种页面状态和 Retry。
- Markdown 转换完全离线，覆盖当前文档使用的标题、段落、无序/有序列表、围栏代码块、行内代码、强调和分隔线。
- 限制文档内导航，避免本地教程页面任意访问外部地址。
- 为资源查找和 Markdown HTML 转换补充定向测试。

## 非目标

- 不引入 CDN、JavaScript Markdown 库、Swift Package 或其他第三方依赖。
- 不建立全 App 文档中心，不让现有业务页面依赖 Lab 文档阅读器。
- 不修改现有 Interaction System 示例语义、按钮执行生命周期或业务路由。
- 不把仓库所有 Documentation 文件都打进 App Bundle。
- 不实现完整 CommonMark/GFM 规范、远程文档更新、搜索、书签、分享或持久缓存。
- 不执行 Git 暂存、提交、推送、tag 或发布。

## Agent 工作包

### 可以执行

- 新增 `iOSTG/Core/Lab/Documentation/` 下的隔离实现。
- 最小修改 `ButtonDesignView.swift` 接入 NavigationLink。
- 以单一物理 Markdown 文件为资源，进行最小必要的 Xcode target resource 配置。
- 新增只覆盖 TASK-0004A1 的测试。
- 使用 `/tmp` DerivedData 运行 lint、build、test 和 Simulator 验证。
- 在 Codex 模拟器浏览器中验证 `Full Chinese Guide` 的点击、渲染、滚动与返回。

### 执行前需再次询问

- 引入任何外部依赖或网络内容。
- 把阅读器迁出 Lab 或接入现有业务页面。
- 扩展为正式全 App 文档系统。
- 执行 Git 暂存、提交、推送、tag 或发布。

## 执行顺序

1. 独立写入并完整重读本子任务。
2. 将状态更新为 `in_progress`，同步 Parent Task、NOW、BOARD 与任务登记。
3. 实现单一 Markdown 资源、离线 HTML 转换和原生 WebKit 页面。
4. 将 Full Chinese Guide 接入现有 Button Design 页面。
5. 运行静态检查、构建和定向测试。
6. 在 Simulator 浏览器中验证真实可达性与渲染。
7. 回写证据并推进到 `awaiting_acceptance`。

## 完成条件

- `Full Chinese Guide` 是可点击 NavigationLink，且仍处于 Lab Tab 自己的 NavigationStack。
- 打开的页面使用 WebKit 展示格式化后的完整中文文档，而不是原始 Markdown 文本。
- 文档在无网络情况下可用，且 App Bundle 中只包含所需的 ButtonDesign Markdown。
- Markdown 正文保持单一物理来源，不出现需要人工同步的副本。
- 页面有明确 loading/error/retry 行为，正文支持滚动与文本选择。
- 当前文档中使用的标题、列表、代码块、行内代码和强调能够正确转换。
- SwiftLint、Simulator build、定向测试和真实运行验证通过，或准确记录未验证原因。
- 未覆盖或整理用户现有未提交改动。

## 来源

- `AGENTS.md`
- `.aidev/TASKS/TASK-0004-add-lab-button-design-example.md`
- `Documentation/Examples/ButtonDesign.md`
- `iOSTG/Core/Lab/ButtonDesign/ButtonDesignView.swift`
- iOS 26.5 SDK 中的 `WebPage` 与 SwiftUI `WebView`
- 维护者本轮关于 TASK-0004A1 归属和命名的明确确认

## 证据

- Apple WebKit for SwiftUI 文档与本机 iOS 26.5 SDK 均确认 `WebPage`、SwiftUI `WebView`、`NavigationDeciding` 和 `webViewTextSelection` 可用。
- `plutil -lint iOSTG.xcodeproj/project.pbxproj`：通过。
- `swiftlint lint --quiet`：通过，无 lint 输出。
- `git diff --check`：通过。
- Simulator Debug build：通过；构建产物存在且只复制目标 `iOSTG.app/ButtonDesign.md`。
- `cmp Documentation/Examples/ButtonDesign.md .../iOSTG.app/ButtonDesign.md`：通过，证明 Bundle 内容来自同一物理 Markdown 正文。
- 定向测试：6/6 通过、0 failed、0 skipped，覆盖 Button Design 既有三项行为和文档资源、区块转换、安全转义三项行为。
- iPhone 17 Pro Max（iOS 26.5）真实验证：`Guide` 显示在 `Clear` 左侧，toolbar 与底部 `Full Chinese Guide` 均可进入同一个 WebKit 页面。
- WebKit 页面确认格式化展示中文标题、段落、列表、围栏代码块和行内代码，而不是原始 Markdown；滚动和返回导航通过。
- `.ignoresSafeArea(.container, edges: .top)` 已启用；HTML 通过设备 safe-area inset 加独立 toolbar 净空保护 H1，最终首屏无遮挡。
- 未引入网络、CDN、JavaScript Markdown 库、Swift Package 或业务依赖；未执行 Git 暂存、提交或推送。

## 交接

- 实现与验证已完成，等待维护者在模拟器浏览器中验收 toolbar Guide、WebKit 排版与顶部 safe-area 行为。
- 阅读器仍是 Lab 内部受控 Markdown 子集；扩展为全 App 文档系统需要新的 Task/ADR。
