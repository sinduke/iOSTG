# Button Design：可运行的 Interaction System 示例

```yaml
status: EXPERIMENTAL
recording_mode: contemporaneous
minimum_os: iOS 26.5
app_entry: TabBar > Lab > Button Design
business_integration: none
```

## 介绍

这个示例不是为了用 `AppButton` 替换项目里的每一个 SwiftUI `Button`。它提供一套完整、可运行、但与现有业务隔离的参考实现，用于观察一个 Button 如何连接以下概念：

```text
InteractionIntent
    ↓
InteractionEvent

ExecutionRequest
    ↓
OperationExecutor
    ↓
ExecutionEvent

DemoService
    ↓
DomainEvent

三类 Event
    ↓ explicit projector
ObservationRecord
    ↓
ObservationReporter
    ├── In-memory sink
    └── No-op sink
```

三类事件共享运输与展示基础设施，但保持不同业务语义：

- `InteractionEvent`：用户实际触发、选择或改变了什么。
- `ExecutionEvent`：操作被接受、拒绝、开始、完成、失败或取消。
- `DomainEvent`：只有拥有业务真相的层才能确认的事实。

## 如何运行

1. 启动 iOSTG 并完成 Onboarding。
2. 在 TabBar 选择 `Lab`。
3. 从 List 进入 `Button Design`。
4. 操作 Live demo，并观察下方 `Observation timeline`。
5. 点击 Navigation toolbar 中位于 `Clear` 左侧的 `Guide`，或页面底部的 `Full Chinese Guide`，使用 App 内 WebKit 阅读本文件。

## Full Chinese Guide 阅读器

`Full Chinese Guide` 仍然读取这一份 Markdown 正文，没有维护第二份 HTML 文档。构建时，Xcode 将本文件作为单独资源复制进 App Bundle；Lab 阅读器在本地读取文本、转换成受控 HTML，再交给 iOS 26 原生 `WebPage` 与 SwiftUI `WebView` 展示。

这个路径完全离线：

- 不使用 CDN 或远程 JavaScript；
- 不引入 Markdown 第三方依赖；
- HTML 转换时转义原始标签；
- WebKit NavigationDecider 只允许内部 `about` 页面，不允许教程正文发起外部导航；
- 阅读页面提供 loading、error、retry、滚动和文本选择。
- WebView 使用 `.ignoresSafeArea(.container, edges: .top)` 延伸到导航栏下方；HTML 将 `env(safe-area-inset-top)` 与独立的导航栏净空相加，避免误把设备 safe area 当作 toolbar 高度。

## Live demo

### Report interaction only

只产生 Interaction 记录，不创建 ExecutionRequest。它说明并非每次用户交互都需要 Executor。

### Run async operation

使用 `.asyncExclusive` 执行 1.5 秒的空转服务。正常顺序为：

```text
interaction
execution.accepted
execution.started
domain.demo.operation_finished
execution.completed
```

DomainEvent 由 `DemoService` 产生；Executor 只知道 operation closure 是否正常返回。

### Competing trigger

它与 `Run async operation` 共享同一个 `ExecutionKey`。先启动其中一个，再快速点击另一个，第二次执行会产生 `rejected`，而不是 `failed`。

### Run failing operation

空转服务主动抛出错误，Executor 记录 `failed`。示例只输出经过白名单处理的 `reason_code`，不会自动上传原始 Error。

## 文件结构

```text
iOSTG/Core/Lab/
├── LabView.swift
├── ButtonDesign/
    ├── ButtonDesignView.swift
    ├── ButtonDesignLiveDemo.swift
    ├── ButtonDesignControls.swift
    ├── ButtonDesignModels.swift
    ├── ButtonDesignProjection.swift
    ├── ButtonDesignObservation.swift
    └── ButtonDesignExecutor.swift
└── Documentation/
    ├── LabDocumentationResource.swift
    ├── LabMarkdownHTMLRenderer.swift
    └── LabDocumentationView.swift
```

所有基础设施类型都位于 `ButtonDesignExample` 命名空间或示例专用类型中，现有 Onboarding、Explore、Chats、Profile 与 Settings 不依赖它们。

## 设计规则

1. Intent 表达用户意图，不冒充已经发生的事实。
2. Execution completed 只代表 operation closure 正常返回。
3. Domain success 必须由拥有真实结果的 service/domain 层确认。
4. typed Context 保持到显式 Observation Projection 边界。
5. Projector 通过白名单选择字段，不使用反射或自动编码整个 Context。
6. ObservationSink 不抛出错误影响示例 operation 的业务结果。
7. UI 的 async-exclusive 只是交互保护，不等于服务端业务幂等。

## 当前限制

这个示例是完整的教学参考，但不是生产 SDK：

- ObservationReporter 当前并行调用内存和 No-op Sink，没有实现磁盘队列、背压、批处理或离线重试。
- `.viewBound` Task 在 View 消失时请求取消；取消仍是 Swift 并发的协作式语义。
- 没有接入真实 Analytics、认证、支付、订单或网络 API。
- 没有提供服务器幂等、Transactional Outbox 或强制合规审计。
- 示例事件只存在于当前页面生命周期的内存中。
- Lab Markdown renderer 只实现当前教程需要的受控语法子集，不宣称完整支持 CommonMark 或 GFM。

## 本次验证

2026-08-14 已完成以下验证：

- SwiftLint 无告警；
- iOS Simulator Debug build 通过；
- 六个定向测试通过：三个 Button Design execution/事实隔离测试，以及三个文档资源/区块/安全转义测试；
- iPhone 17 Pro Max（iOS 26.5）真实启动；
- 在模拟器浏览器中走通 `Onboarding → TabBar → Lab → Button Design`；
- 现场观察到正常执行的 `Execution completed` 与竞争执行的 `Rejected by async-exclusive policy`。
- 在模拟器浏览器中点击 `Full Chinese Guide`，确认 WebKit 格式化标题、代码块、列表和行内代码，并验证滚动与返回。

## 什么时候迁移到业务代码

只有真实功能出现以下重复需求后，才应把被证明的最小部分迁移到正式架构：

- 多个异步提交都需要相同的执行状态与重复保护；
- 多个功能都需要稳定的 Interaction/Execution 观测；
- 已经确定 Analytics 字段、隐私审查和可靠性要求；
- 现有业务拥有明确的 DomainEvent 产生者。

迁移时重新建立正式 Task/ADR；不要直接把整个 Example 目录改名为 Production Infrastructure。
