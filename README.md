# iOSTG

> 目标是建设一套以真实 iOS 应用为载体、能够回到任意重要历史状态的演进式教程。

iOSTG 不只是一个示例 App，也不把 Git 提交列表当作教程。仓库当前已经保存早期代码和 Git 历史；接下来会随代码
同步建立架构演变、设计取舍、实验、反例、验证证据和历史 Checkpoint，让读者能够像翻书一样理解重要阶段发生了
什么、为什么发生，以及如何重新运行当时的代码。

任意 commit 都可以被 Git 查看，但只有完成验证并正式发布的 Checkpoint，才承诺可构建、可运行或可复现。

## 已确认的项目边界

- 项目名称：`iOSTG`。
- 支持平台：仅 iOS。
- 最低系统版本：iOS 26.5。
- App target 使用 Swift 6 language mode 和 SwiftUI；测试 target 的语言模式按 Checkpoint 记录。
- 教程正文以中文为主；代码标识符、API 名称和技术专有名词保留英文。
- 项目维护者负责编写代码收口并作出最终产品与架构决定。
- Codex/AI 的角色是检查、验证、追问缺失的原因、整理演变记录；除非得到明确授权，不替维护者决定或实现正式
  收口方案。

## 这本“代码书”怎样工作

| 层级 | 职责 | 是否会移动 |
| --- | --- | --- |
| Commit | 保存一个原子、精确的代码变化 | 已发布历史不改写 |
| Checkpoint | 绑定一个值得重新打开的完整状态 | 已发布 annotated tag 不移动 |
| Lesson | 解释问题、实现、取舍、验证和结果 | 发布后只通过勘误或后续页面修正 |
| Chapter | 把多个 Lesson 组成完整学习闭环 | 可以有后续修订版 |
| Tutorial release | 冻结一套可连续阅读和复现的教程版本 | 与 App 版本分开管理 |

Git 保存“当时究竟有哪些文件”；教程页面回答“为什么从上一状态走到这里”。仓库不会为每一章复制一套 Xcode
工程。需要并排阅读两个状态时，可以从 tag 或 commit 创建两个 worktree。

Checkpoint tag 唯一负责标识“可恢复的代码状态”；Lesson 是解释页面，通过 `base_checkpoint` 和
`result_checkpoint` 引用零个、一个或多个状态。纯概念 Lesson 可以没有结果 Checkpoint。Lesson tag 只表示页面已经出版；
当一页恰好以一个新代码状态结束时，Lesson tag 和结果 Checkpoint tag 可以指向同一文档 commit，但两者语义不同。
Chapter/tutorial tag 则表示一组内容已经出版。

```bash
git worktree add --detach ../iOSTG-before <before-tag>
git worktree add --detach ../iOSTG-after <after-tag>
```

### 事实和解释的标签

教程中的重要结论必须区分证据等级：

- `DECIDED`：维护者明确批准的决定。
- `OBSERVED`：直接从指定代码、配置或 Git 状态看到的事实。
- `VERIFIED`：由记录下来的构建、测试或运行行为证明。
- `INFERRED`：基于证据的解释，但尚未得到维护者确认。
- `HYPOTHESIS`：等待实验验证的假设。
- `EXPERIMENTAL`：只在明确实验条件下成立的结论。
- `OPEN`：尚未决定或证据不足。
- `SUPERSEDED`：曾经有效，后来被新决定替代。

旧历史的补写使用 `recording_mode: retrospective`；新体系启用后的同步记录使用
`recording_mode: contemporaneous`。今天运行成功的验证只能写成“今天已验证”，不能倒写成过去已经验证。

## 当前起点

教程治理体系建立前，仓库已经存在一条线性的早期历史：Xcode 初始化、图标和 Launch Screen、SwiftLint/VS Code
配置、AppView 尝试、Tab 页面骨架、Onboarding 页面以及 commit message hook。

这些提交将作为第一批回顾性材料保留，不重写旧提交。尤其是没有遵守 `[Type]` 规则的历史提交，会作为“客户端提示
为什么不能替代仓库约束”的真实治理案例，而不是被擦除。

当前源码仍属于基础探索阶段，不应被描述为已经完成的 App：正式启动路径、Onboarding 完成动作、Root 状态所有权、
导航边界以及有效测试仍需要在后续 Lesson 中逐项收口和验证。正式 tutorial checkpoint 尚未发布。

文档体系建立时的基线绑定如下。它不是正式 checkpoint，也不代表未来的当前状态：

```yaml
recording_mode: retrospective
as_of_commit: 31068d462342e62736ec35a6277eea9ba09fc1cc
observed_on: 2026-08-11
```

该 commit 的 `OBSERVED` 事实如下；阅读时仍应以当前 checkout，以及存在时的最新正式 Checkpoint 为准：

- Xcode 工程当前有 `iOSTG`、`iOSTGTests`、`iOSTGUITests` 三个 target，以及 Debug/Release configuration。
- App target 当前使用 Swift 6；两个测试 target 仍配置为 Swift 5，迁移必须作为单独 Lesson 验证。
- 当前观察环境是 Xcode 26.6；最低开发工具版本尚未冻结，但必须能够提供 iOS 26.5 SDK。
- 实际 `@main` 路径是 `NavigationStack → ContentView`；AppView/Onboarding/TabBar 仍是另一条尚未接入的实验路径。
- `AppView` 中同时保留 `AppState` 和直接 `@AppStorage` 两种状态思路，`CompletedView` 的完成按钮尚无行为。
- Explore、Chats、Profile 和 Settings 是 UI 骨架；仓库当前没有聊天、AI、网络、数据库、账号或第三方 SDK 实现。
- Unit Test/UI Test 仍接近 Xcode 模板，不能称为已经建立业务测试覆盖。
- 产品范围已经确定为 iOS-only，但工程仍保留待收口的 Xcode 多平台生成设置。
- App Icon、Launch Screen 和部分资源仍有旧名称/品牌残留；它们不是 iOSTG 的正式品牌决定。
- 目录当前确实拼作 `iOSTG/Core/TabbBar`；历史页面应记录真实路径，重命名要作为单独演变保留。

## 课程总图

最初提出的三条主线仍然成立：

1. 完成一个由 Mock 驱动的基础 App。
2. 接入 Firebase，并逐步演化到自建 API 或独立移动端服务。
3. 对架构进行有证据的持续演化和对比。

但架构并不是第三部分才突然出现。App 入口、状态所有权、Mock 边界、Target/Scheme/Configuration 和 Firebase 隔离
本身都是架构决定。因此课程采用“纵向产品阶段 + 横向工程主题”的结构。

### P00：前言、项目基线与阅读方法

| 章节 | 核心问题 |
| --- | --- |
| CH00 项目宪章 | iOSTG 教什么、不教什么，谁负责决定，怎样区分事实与推断 |
| CH01 Xcode 初始化 | App/Test/UI Test target、Swift 6 迁移、actor/Sendable 诊断、iOS 26.5、目录与工程文件 |
| CH02 工程工具 | Asset Catalog、Launch Screen、SwiftLint、swift-format、VS Code/Xcode 协作 |
| CH03 Git 治理 | commit message hook、原子提交、选择性暂存、为什么不改写已发布历史 |
| CH04 阅读历史 | Commit、Checkpoint、Lesson、Chapter、worktree、完整 SHA 和 annotated tag |
| CH05 教程证据 | 构建、测试、运行、截图、性能数据分别能够证明什么；生成索引怎样校验 freshness |

### P01：Mock 驱动的完整基础应用

目标是在不依赖远端服务的情况下完成一条可运行、可测试、可替换数据源的产品主链路。

| 章节 | 核心内容与阶段出口 |
| --- | --- |
| CH10 App 入口与 Root | 从 `@main` 追踪真实启动路径；确定唯一 Root 和生命周期边界 |
| CH11 应用状态 | 首次启动、Onboarding、主界面切换、重启恢复、测试重置入口 |
| CH12 导航与 Tab | Tab 根结构、各 Tab 的 NavigationStack 所有权、push/sheet/full-screen cover |
| CH13 Onboarding | Welcome、分步引导、完成动作、持久化以及重复进入策略 |
| CH14 Explore | 分类、卡片、列表、详情、加载/空/错误/正常状态 |
| CH15 Chats | 会话列表、消息模型、聊天详情、输入、流式或模拟回复、删除和举报 |
| CH16 Profile 与 Settings | 用户资料、设置、账号入口、开发设置以及呈现边界 |
| CH17 组件和设计基础 | Assets、颜色、排版、图片、Modal、Alert；CTA modifier → async CTA → config-driven button |
| CH18 领域模型与 Fixture | Domain/UI/DTO 的区别、确定性 Mock、时间/UUID/随机数可测试化 |
| CH19 本地状态与存储 | UserDefaults、文件、SwiftData 等方案在真实需求出现时的比较与演化 |
| CH20 Mock 服务边界 | Protocol、延迟、错误注入、离线状态、Preview/Test/App 的数据隔离 |
| CH21 基础测试 | Swift Testing、UI smoke test、launch argument、accessibility identifier、Test Plan |
| CH22 Mock 里程碑 | 无网络完成核心演示，同一 composition root 可切换确定性数据提供者 |

### P02：环境、配置与 Composition Root

这部分是 Mock 与真实后端之间的工程化桥梁，不会预先把所有环境都实现成多个 target。

| 章节 | 核心问题 |
| --- | --- |
| CH23 Target / Scheme / Configuration | 分清“构建什么”“怎样运行”“使用什么设置”“连接哪个运行环境” |
| CH24 环境拓扑实验 | 比较单 App target + 多 configuration、多 App target、独立示例 target/package |
| CH25 `.xcconfig` 与配置注入 | Bundle ID、显示名、图标、编译条件、服务地址、本地覆盖和 CI 注入 |
| CH26 Secrets 与生产隔离 | 什么可以提交、什么必须外部注入、缺失配置如何快速失败 |
| CH27 Composition Root | Mock/Preview/Test/App/Dev/Production 的对象图、生命周期、TestingApp 和手动 DI |
| CH28 第三方依赖 | 从真实问题出发评估 SDK，记录引入、替换和移除成本 |
| CH29 工程验证矩阵 | 每个 scheme/configuration 的 build、test、launch 和服务隔离证据 |

这里会专门回答“Mock、Dev、Release 到底应该是 target、scheme、configuration 还是组合”，而不是把这些名词混用后
直接复制配置。

### P03：Firebase v1

Firebase 是已经确认的第一个真实后端阶段，但各项 Firebase 产品仍需按功能需求逐项引入。

| 章节 | 状态 | 核心内容 |
| --- | --- | --- |
| CH30 Firebase 决策与边界 | Core | v1 解决什么、锁定风险、成本、隐私、未来退出边界 |
| CH31 项目与 Emulator | Core | Dev/Test/Production Firebase Project、Emulator、测试数据隔离 |
| CH32 Authentication | Conditional | 只有身份需求确认后才进入登录状态、Apple 登录和账号删除 |
| CH33 User 数据 | Conditional | 采用 Firestore 后再讲 schema、DTO、监听、离线、本地缓存与一致性 |
| CH34 媒体和 AI Gateway | Conditional | Storage/Functions、Mock AI、流式/取消/限流/费用/隐私和 server gateway |
| CH35 实时聊天 | Conditional | 产品需要实时聊天后再讲查询、分页、消息流、已读、举报、删除和重连 |
| CH36 Remote Config 与 A/B Test | Conditional | 实验需求确认后再讲分组稳定性、指标和回滚 |
| CH37 日志和可观测性 | Conditional | 选定事件与故障需求后再选择 Console/Analytics/Crashlytics adapter |
| CH38 Push 与深链 | Conditional | 只有产品入口需求确认后才实现权限、通知路由和冷启动恢复 |
| CH39 Firebase 安全 | Core | 对实际采用的 Firebase 产品验证 Rules/App Check、最小权限和数据删除 |
| CH40 Contract 与集成测试 | Core | Mock/Firebase 共用业务契约，Emulator、Rules、离线和重连测试 |
| CH41 Firebase v1 里程碑 | Core | 完成至少一条真实纵向链路，并保留可切回 Mock 的装配能力 |

`Conditional` 不等于已经承诺实现；只有对应产品需求被维护者确认后，才创建正式 Lesson 或 Chapter。

约束方向是让 Firebase SDK 类型尽量停留在 infrastructure adapter；是否、何时引入更深的抽象，需要由替换需求和
测试压力证明。

### P04：自建 API、移动端服务与渐进迁移

这一部分不会预选服务端语言、框架、数据库或部署平台。先定义客户端需要的契约，再通过 ADR 决定技术实现。

| 章节 | 核心内容 |
| --- | --- |
| CH42 为什么补充或替换 Firebase | 成本、查询、区域、治理、服务端规则、性能与运维证据 |
| CH43 API Contract | REST/GraphQL/WebSocket、OpenAPI、错误、分页、版本、幂等、兼容策略 |
| CH44 Transport | URLSession、DTO、流式响应、取消、回压、超时、retry/backoff、token、限流和脱敏日志 |
| CH45 直接 RemoteService | App 中的 API adapter 直接对接总后台，保持业务层不认识传输细节 |
| CH46 独立移动端服务 | App → Mobile Backend/BFF → 总后台；AI Gateway 可作为首个安全、配额与费用用例 |
| CH47 同步系统 | 本地数据库、outbox、增量同步、冲突、幂等、后台任务和最终一致性 |
| CH48 认证桥接 | Firebase ID token 验证、双认证、账号映射、吊销和完整迁移 |
| CH49 数据迁移 | schema 对照、ID、时间精度、backfill、dual read/write、shadow read、对账 |
| CH50 渐进切换 | feature flag、canary、指标、错误预算、回滚和避免“大爆炸”迁移 |
| CH51 自建后端里程碑 | 行为契约、数据对账、权限、性能和回滚演练共同通过 |

### P05：贯穿 P01–P04 的架构演化实验室

它不是完成后端之后才开始的最后阶段，也不是“把所有著名架构都装进项目”。它在 P01–P04 每次出现真实压力时，
用同一个小功能和统一指标比较不同边界。模式只有在实验结果、ADR 和维护者决定支持后才进入主线。

| 核心章节 | 触发条件或实验问题 |
| --- | --- |
| CH52 MV 基线 | 最简单 SwiftUI 状态和副作用放在哪里，何时仍然足够 |
| CH53 MVVM | View 状态转换、异步编排或测试困难是否已构成引入理由 |
| CH54 Manager / Service | 业务协调与 SDK/存储怎样分离，Manager/CoreInteractor façade 是否变成过大接口 |
| CH55 Repository / Use Case | 多数据源和跨页面规则是否值得新增层次 |
| CH56 DI 演化 | initializer、Environment、手动容器和第三方 DI 的对象图与生命周期成本 |
| CH57 Navigation 演化 | 局部 NavigationStack、Router、Coordinator、深链和状态恢复的比较 |
| CH58 模块化与决策 | 模块是否由编译/团队边界驱动；用数据决定架构，而不是按名称升级 |

候选 Experiment 题库不预分配 Chapter，也不承诺全部实施：

- Builder/Interactor/Router 与 VIPER 的职责、文件量和修改成本。
- RIB/RIBs 的状态树、生命周期和大型团队收益。
- RIB + VIPER + DI 混合方案是否产生重复职责。
- generic/`@ViewBuilder` 与 `AnyView`/type erasure 的编译、可读性和性能取舍。
- initializer DI、Environment、手动 container 与第三方 DI。

只有先存在 `HYPOTHESIS`、统一比较指标和维护者批准，候选题目才获得 `EXP-xxxx`，并在有教学闭环时晋升为 Chapter。

架构不是升级阶梯。`MV → MVVM → VIPER → RIB` 不代表从差到好；每种方案都必须写明适用规模、代价、退出条件和
被拒绝原因。

### P06：贯穿全书的生产工程

这些主题从 Mock 阶段就开始建立基线，在真实后端和架构演化中逐步加深：

- 测试：unit、UI、contract、integration、security rules、migration、关键 E2E。
- Swift Concurrency：actor isolation、取消、任务生命周期、Sendable、竞态与回压。
- 性能：启动、SwiftUI 更新、滚动、图片、网络、内存、泄漏、后台和能耗。
- 安全与隐私：threat model、Keychain、token、最小权限、PII、ATS/TLS、供应链、PrivacyInfo。
- AI 安全与成本：客户端不携带服务端 secret、Prompt/响应隐私、内容安全、配额、限流、provider DTO 隔离和替换。
- 可访问性与本地化：Dynamic Type、VoiceOver、对比度、Reduce Motion、字符串和布局。
- 可选产品实验：StoreKit/付费墙/权益恢复、Push、deep link、A/B test、评分和反馈；按需求激活。
- 工程交付：CI、依赖锁定、静态检查、测试矩阵、签名、版本、发布和回滚。
- 长期迁移：Swift/iOS SDK、持久化 schema、依赖、配置、API 和架构迁移。
- 文档治理：索引校验、失效链接、生成内容 freshness gate、源码/符号索引漂移、Errata 和教程修订版。

## AIChats 参考项目

`OBSERVED`：课程地图参考了 [sinduke/AIChats][aichats-repository] 固定 commit 的公开代码快照，以及截至该 commit
可观察的 113 条 Git 提交历史。分析日期为 2026-08-11，基线为
[`54f9da66ad263b908e7b35ec8f57ae9b02c86eab`][aichats-baseline]。

从该基线可以观察到：

- Explore、Chats、Profile、Settings、多步 Onboarding、账号、头像、Paywall 等产品切片。
- App/Unit Test/UI Test target，Debug/Release/Mock configuration，以及 Dev/Production/Mock shared scheme。
- Mock 与 Firebase service、Manager、local/remote service、SwiftData、StoreKit。
- Firebase Auth、Firestore、Storage、Functions、Remote Config、Analytics 和 Crashlytics。
- 日志、Push、deep link、A/B test、设计组件和开发设置。
- 提交记录中的 View → ViewModel、DependencyContainer、CoreInteractor、CoreBuilder、Router 和 VIPER 实验轨迹。

这些都是 iOSTG 的问题库、实验素材和反例来源，不是需要照搬的最终目录。AIChats 中的方案仍要在 iOSTG 中重新说明
目标、重现实验并验证；源码存在不等于设计动机已被证明。

该 commit 本轮只完成静态只读分析，build/test 状态为 `UNVERIFIED`。当前还能观察到生产源码、测试初始化接口和生成的
项目索引之间存在漂移风险，因此它尤其适合作为“为什么 checkpoint 必须绑定验证证据和 freshness gate”的案例。

## 计划中的知识结构

当前只建立顶层治理文件。后续 Lesson 开始封存时，再按需要逐步创建目录，避免一次生成大量空文档：

```text
Documentation/
├── Book/                  # 唯一线性主阅读路径
├── Architecture/
│   ├── Current/           # 当前真实架构
│   └── Evolution/         # 从 A 到 B 以及为什么
├── Decisions/             # ADR
├── DeepDives/
│   ├── Deconstruction/    # 拆解
│   └── Encapsulation/     # 封装
├── Experiments/           # 实验报告
├── Examples/              # 示例说明
├── Checkpoints/           # 状态清单，不复制整份源码
├── Reference/
├── Errata/
└── Indexes/               # 时间、主题、源码、决策、实验、checkpoint 索引

Experiments/               # 隔离的可运行实验代码
Examples/                  # 小而完整的示例代码
```

Markdown 是第一阶段的单一内容源。未来可以由同一内容生成 DocC 或网站，但不维护两套相互漂移的正文。

## 稳定编号和引用

本仓库采用全局稳定 ID；标题和目录以后可以重命名，ID 不复用：

| 类型 | 示例 |
| --- | --- |
| Chapter | `CH13` |
| Lesson | `L001` |
| Checkpoint | `CP001` |
| Architecture Evolution | `EV-0001` |
| Decision | `ADR-0001` |
| Experiment | `EXP-0001` |
| Example | `EX-0001` |
| Errata | `ERR-0001` |

对应 tag 的规范形式：

```text
lesson/l001-onboarding-root
chapter/ch13-onboarding
checkpoint/cp001-mock-root
experiment/exp0001-storage-boundary/result
tutorial/v0.1.0
app/v0.1.0
```

教程版本与 App 版本永远分开。发布后的 tag 不移动、不删除、不复用；发现问题时创建 Errata、新 commit 或新教程修订版。

## 构建与检查

打开工程：

```bash
open iOSTG.xcodeproj
```

列出 scheme 和可用 destination：

```bash
xcodebuild -project iOSTG.xcodeproj -list
xcodebuild -project iOSTG.xcodeproj -scheme iOSTG -showdestinations
```

执行不依赖固定模拟器 UUID 的基础构建：

```bash
xcodebuild \
  -project iOSTG.xcodeproj \
  -scheme iOSTG \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

静态检查：

```bash
swiftlint lint --config .swiftlint.yml
git diff --check
git diff --cached --check
```

`git diff --check` 只检查已跟踪工作区差异；新文件显式暂存后，再由 `git diff --cached --check` 检查 staged 内容。

测试、运行验证和构建是不同证据。具体 simulator、测试计划和验证结果应记录在对应 Lesson 或 Checkpoint 中，不在
README 中硬编码机器专属 UUID。

## 提交规范

每个 clone 需要启用版本控制中的 hook：

```bash
git config core.hooksPath .githooks
```

hook 强制的提交标题结构：

```text
[Type] Short description
```

允许的类型为 `[Base]`、`[Feature]`、`[Fix]`、`[Refactor]`、`[Docs]`、`[Test]`、`[Chore]`。项目正文和人工提交说明
默认使用中文简短描述；当前 hook 只验证前缀、空格和非空描述，不能验证语言。某些 Git 客户端会主动绕过 hook，
因此 hook、客户端 Commit instructions 和提交者检查共同构成防线。

完整贡献流程、实验规则和发布门请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。AI/Codex 在仓库中的操作边界请阅读
[AGENTS.md](AGENTS.md)。

## 当前非目标

- 不为展示“复杂”而一次性引入所有架构模式。
- 不把 AIChats 当前实现直接复制为 iOSTG 的答案。
- 不在需求和契约尚未明确时预选自建后端技术栈。
- 不用复制工程目录的方式保存历史状态。
- 不把构建成功描述成完整功能或实际运行已经验证。
- 不把推断出的设计动机写成维护者当时的真实决定。

## License

仓库当前尚未定义开源许可证。在许可证明确之前，不应推定获得复制、分发或再许可代码的权利。

[aichats-repository]: https://github.com/sinduke/AIChats
[aichats-baseline]: https://github.com/sinduke/AIChats/tree/54f9da66ad263b908e7b35ec8f57ae9b02c86eab
