# Contributing to iOSTG

iOSTG 的贡献目标不只是得到“能运行的最终代码”，还要保留一条可学习、可验证、可回到任意重要状态的演进路径。
一次可接受的贡献通常同时回答：改了什么、为什么现在要改、为什么这样改、怎样证明结果、这次变化在课程中处于
哪里。

请先阅读 [README.md](README.md) 了解项目定位，并阅读 [AGENTS.md](AGENTS.md) 了解 AI/Codex 的仓库级操作边界。

## 1. 当前贡献边界

- 正式名称：iOSTG。
- 平台：仅 iOS。
- 最低系统版本：iOS 26.5。
- 易变的当前代码状态以 [README 的精确基线](README.md#当前起点)、当前 checkout，以及存在时的最新正式 Checkpoint
  为准。
- `DECIDED`：Firebase 是第一版真实后端；具体采用哪些 Firebase 产品仍按需求逐项决定。
- 自建 API、移动端独立服务、数据库和最终架构模式仍需后续实验与 ADR。
- 维护者拥有正式代码收口、架构晋升和 checkpoint 发布的最终决定权。

## 2. 可以贡献什么

| 类型 | 例子 | 通常需要的记录 |
| --- | --- | --- |
| Base | Xcode 工程、Assets、工具、环境基线 | Lesson 或 Reference；必要时 ADR |
| Feature | Onboarding、Chats、Explore、Profile、服务能力 | Lesson、验证证据、必要的测试 |
| Fix | 行为、配置、文档或历史索引错误 | 复现、根因、验证；已发布内容需要 Errata |
| Refactor | 状态、导航、服务、DI 或模块边界演化 | Evolution；重要取舍需要 ADR |
| Docs | Book、Reference、Checkpoint、索引、勘误 | 精确 commit/tag/源码引用 |
| Test | Unit/UI/contract/integration/performance 验证 | 测试目标、环境和结果 |
| Chore | hook、脚本、依赖维护和非功能性工程变更 | 影响范围和验证 |
| Experiment | MVVM/VIPER/RIB/DI、数据源或同步方案比较 | EXP 报告、baseline、变量、结论 |
| Example | 独立、最小、可运行的教学样例 | EX 页面和运行方式 |

`Experiment` 和 `Example` 是教学内容类型，不是当前 commit hook 允许的提交前缀。提交时仍根据实际变化使用
`[Base]`、`[Feature]`、`[Fix]`、`[Refactor]`、`[Docs]`、`[Test]` 或 `[Chore]`，并在正文或 trailer 中引用对应 ID。

## 3. 开始贡献前

### 3.1 检查工作区

```bash
git status --short --branch
git diff --stat
git diff
```

确认：

- 当前分支和远端跟踪关系符合预期。
- 工作区中的已有修改属于谁、是否在本次范围内。
- 本次变化对应的起始 commit/checkpoint 已记录。
- 相关源码、测试、Book 页面、ADR 或 Experiment 已阅读。

不要为了得到干净工作区而恢复、覆盖或删除无法确认归属的修改。

### 3.2 启用提交 hook

每个 clone 都需要执行一次：

```bash
git config core.hooksPath .githooks
```

确认：

```bash
git config --get core.hooksPath
```

预期输出：

```text
.githooks
```

`.githooks/` 被版本控制，但 Git 不会因为目录存在就自动启用它。某些客户端，包括当前 ChatGPT/Codex desktop 的一键
提交路径，可能主动禁用仓库 hook；这种情况下仍必须通过 Commit instructions 或显式输入生成合规标题。

### 3.3 定义本次 Learning Unit

开始写代码前，用简短文字记录：

- 学习目标。
- 当前问题。
- 起始 commit/checkpoint。
- 涉及的功能、文件和 symbol。
- 已知约束与非目标。
- 候选方案。
- 预计验证方式。
- 哪些问题必须由维护者决定。

如果无法在一句话中说明本次学习目标，变化很可能需要拆分。

## 4. 分支和提交粒度

分支是正在写作或实验的工作台，不是出版后的页码。推荐名称：

```text
feature/<short-slug>
fix/<short-slug>
docs/<short-slug>
experiment/<exp-id>-<short-slug>
```

由 Codex 自动创建的分支使用 `codex/` 前缀。仓库当前没有声明 branch protection 或强制 PR 流程，因此不要在文档或
交付说明中虚构这些保护已经存在。

Commit 应当：

- 只完成一个可解释的变化。
- 尽量保持 App 可构建；故意失败只允许出现在隔离实验中。
- 保留读者理解前后差异所需的中间步骤。
- 不把整章 squash 成一个巨大提交。
- 不混入无关重命名、格式化或清理。

正式 Lesson 推荐使用两个提交：

1. 代码/测试提交：保存该步骤的可运行实现。
2. `[Docs]` 提交：引用前一个完整 SHA，记录解释、验证和演变关系。

这样 lesson tag 可以指向文档提交，同时得到完全相同的源码和对应说明，也避免页面在自己的 commit 中引用自身 SHA
的循环问题。这是正式 Lesson 的推荐发布模型，不要求每个开发中的临时提交都配一份完整页面。

## 5. Commit message

标题格式：

```text
[Type] Short description
```

项目默认使用中文简短描述；当前 hook 只能验证前缀、空格和非空描述，不能验证语言。

允许类型：

```text
[Base]
[Feature]
[Fix]
[Refactor]
[Docs]
[Test]
[Chore]
```

示例：

```text
[Feature] 添加 Onboarding 完成状态
[Refactor] 收口应用根视图状态所有权
[Test] 覆盖首次启动和重启流程
[Docs] 记录 Root 状态演化
```

需要更多上下文时，在 body 中说明：

```text
教学目标:
当前问题:
本次决定:
替代方案:
验证方式:
已知限制:
```

正式教学内容可以增加 trailer：

```text
Book-Page: L007
Decision: ADR-0003
Experiment: EXP-0002
```

不要为了统一格式而 rebase、amend 或 force-push 已经发布到 `main` 的旧历史。旧的不合规消息是项目治理演化的一部分。

## 6. 代码贡献要求

### 6.1 App 入口、状态和导航

- 涉及启动行为时，从 `@main` 追踪真实可达路径。
- 不把只存在于 Preview 或未接入的 View 描述为已上线流程。
- Root、Onboarding、Tab 和 feature NavigationStack 的所有权必须明确。
- 状态名称优先表达业务语义，而不是具体 UI 结果。
- 新增持久状态时记录默认值、迁移、重置和测试策略。

### 6.2 Mock 和数据边界

- Mock 必须确定性、可配置，并能表达成功、空、加载、错误和必要的延迟。
- Preview fixture、测试 fixture 和 App runtime mock 的生命周期要明确。
- 时间、UUID、随机数和网络延迟需要能够控制。
- Mock/Firebase/API 的业务语义应通过 contract tests 对齐，而不是只让类型签名相同。
- 不为了未来可能出现的后端过度抽象；只有真实替换或测试压力出现时才晋升边界。

### 6.3 Target、Scheme、Configuration 和 Environment

不要把这些概念混用：

- Target：构建什么产品。
- Scheme：怎样 build、run、test、profile、archive。
- Build Configuration：某次构建使用哪些设置。
- Runtime Environment：运行中的 App 连接哪个服务环境。

创建 Mock/Dev/Release 结构前应比较：

- 单 App target + 多 configuration/scheme。
- 多个可同时安装的 App target。
- `.xcconfig`、bundle ID、显示名、图标、entitlement 和编译条件。
- Preview、UI Test、Firebase Emulator 和生产隔离需求。

修改上述拓扑必须有明确任务；不能因为参考项目使用某种方案就直接照搬。

### 6.4 第三方依赖

引入依赖必须说明：

- 当前问题为什么不能由系统 API 或已有代码合理解决。
- 依赖的具体能力和使用边界。
- 支持的 iOS/Swift 版本。
- 许可证、维护状态、供应链和隐私影响。
- binary size、启动、编译和运行成本。
- Mock、测试、替换和移除方案。

更新依赖时提交 lock/resolution 文件，并记录兼容性验证。不得无任务地批量升级所有依赖。

### 6.5 安全和隐私

- 不提交 secret、私钥、服务账号、生产 token、签名材料或真实用户数据。
- 不把 simulator UUID、本机绝对路径、DerivedData 或 xcuserdata 提交到共享仓库。
- 日常自动化测试不得连接生产数据库或生产 Firebase Project。
- 日志、Analytics 和 Crash 事件不得包含未脱敏 PII、token 或请求正文。
- Firebase 客户端配置不能代替 Firestore/Storage Rules、App Check 和服务端授权。
- 自建 API 必须考虑 token 生命周期、重放、幂等、限流、最小权限和删除请求。

## 7. 教程页面要求

### 7.1 稳定 ID

| 内容 | 格式 |
| --- | --- |
| Chapter | `CHxx` |
| Lesson | `Lxxx` |
| Checkpoint | `CPxxx` |
| Architecture Evolution | `EV-xxxx` |
| ADR | `ADR-xxxx` |
| Experiment | `EXP-xxxx` |
| Example | `EX-xxxx` |
| Errata | `ERR-xxxx` |

ID 分配后不复用，即使页面标题、路径或章节归属后来改变。

### 7.2 元数据

正式页面至少包含：

```yaml
id:
title:
type:
status: draft | reviewed | published | superseded
recording_mode: retrospective | contemporaneous
created:
updated:
topics:
platform: iOS 26.5+
prerequisites:
base_checkpoint:
result_checkpoint:
base_commit:
result_commit:
source_paths:
symbols:
related:
supersedes:
verified_at:
toolchain:
validation_environment:
evidence_refs:
decision_refs:
```

历史路径改变时，同时记录 `path@checkpoint` 和当前路径；不要只修改旧页面路径而丢掉历史语境。

### 7.3 正文

一页 Lesson 至少包含：

- 学习目标。
- 怎样恢复和运行起始状态。
- 当前问题、约束和非目标。
- 候选方案、最终决定和未采用原因。
- 逐步骤实现。
- 逐文件/符号的 before、after、reason、行为影响和验证。
- 架构前后对比。
- build/lint/test/runtime 的独立证据。
- 已知限制、失败和开放问题。
- 练习以及上一页/下一页。
- 起始/结果 checkpoint、完整 SHA、相关 ADR/Experiment/Example。
- 这项内容目前仍有效还是已经 `SUPERSEDED`。

禁止把大段源码手工复制到页面中。优先引用不可变 tag/SHA 中的文件或从 tagged source 生成片段，降低文档漂移。

## 8. 什么时候需要 ADR

出现以下任一情况，应提出或更新 ADR：

- 改变 App root、状态所有权、导航所有权或模块边界。
- 选择 Target/Scheme/Configuration 环境拓扑。
- 引入或替换 Firebase、自建 API、数据库、持久化方案或第三方 SDK。
- 定义认证、同步、缓存、离线、迁移或数据所有权。
- 正式采用 MVVM、Repository、Use Case、DI Container、VIPER、RIB 或模块化。
- 方案带来长期兼容、安全、隐私、成本或运维后果。

ADR 至少记录背景、决策驱动、候选方案、决定、正负后果、重新评估条件和取代关系。新决定通过 `supersedes` 指向
旧 ADR，不静默覆盖旧决定。

## 9. 实验流程

当方案存在明显不确定性或会给主线增加大量结构时，先做 Experiment：

1. 从明确的 baseline commit/tag 创建 `experiment/<id>-<slug>` 分支。
2. 写下问题、假设、变量、固定条件和成功/失败标准。
3. 保存真实步骤和关键 commit。
4. 记录环境、命令、输出和可复现限制。
5. 将结果分类为：`Supported`、`Rejected`、`Inconclusive` 或 `Infrastructure Failure`。
6. 由维护者通过 ADR 决定是否进入 canonical App。

负面结果是有价值的课程内容。只有条件不明、证据丢失或无法复现才是实验记录失败。

VIPER、RIB、RIB + VIPER + DI、不同 DI 方案等实验应尽量使用同一个小功能，并比较：

- 文件和有效代码量。
- 状态所有权和数据流。
- Unit/UI 测试难度。
- 导航和生命周期复杂度。
- 修改同一需求涉及的文件。
- 编译、启动和运行成本。
- 新读者理解成本。

实验胜出不等于自动成为正式架构。

## 10. 本地验证

仓库当前没有 CI。提交者需要运行与变更风险相称的本地检查，并诚实记录未运行项。

### 10.1 通用检查

```bash
git diff --check
git diff --cached --check
swiftlint lint --config .swiftlint.yml
xcodebuild -project iOSTG.xcodeproj -list
```

`git diff --check` 不检查未跟踪文件；新文件显式暂存后，使用 `git diff --cached --check` 检查 staged 内容。

### 10.2 基础构建

```bash
xcodebuild \
  -project iOSTG.xcodeproj \
  -scheme iOSTG \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### 10.3 测试

先查看可用 destination：

```bash
xcodebuild \
  -project iOSTG.xcodeproj \
  -scheme iOSTG \
  -showdestinations
```

再选择当前机器存在的 simulator 运行 test。不要把 UDID 写入共享设置或文档规范。涉及 UI、首次启动、Onboarding、
导航、Firebase/API 或生命周期的变化，除了 unit test 之外通常还需要 UI、runtime 或 integration 证据。

测试命令模板如下，其中占位符必须来自 `-showdestinations`：

```bash
xcodebuild \
  -project iOSTG.xcodeproj \
  -scheme iOSTG \
  -destination 'platform=iOS Simulator,name=<available-device>,OS=<available-runtime>' \
  test
```

### 10.4 证据矩阵

| 变化 | 最低建议验证 |
| --- | --- |
| 仅 Markdown | tracked/staged diff check、链接/代码块人工检查 |
| Swift 逻辑 | SwiftLint、build、相关 unit test |
| SwiftUI 页面 | SwiftLint、build、Preview 或 Simulator 行为；必要时 UI test |
| Root/导航/持久状态 | fresh state、完成动作、重启、重置、相关 unit/UI test |
| Xcode 配置 | `xcodebuild -list`、涉及的每个 scheme/configuration build |
| Firebase/API adapter | contract test、非生产 integration、错误/取消/重连 |
| 安全规则 | Rules/授权自动化测试和负向用例 |
| 性能声明 | 可重复测量、baseline、环境和结果数据 |

如果命令被中断、只完成编译或测试为空模板，不能报告为“全部通过”。

## 11. 暂存和交付

混合工作区中禁止：

```bash
git add -A
git add .
```

应显式暂存目标：

```bash
git add <explicit-path-1> <explicit-path-2>
git diff --cached --stat
git diff --cached
git diff --cached --check
```

只有用户明确要求提交或推送后才执行对应操作。提交、推送、创建 tag、完成 checkpoint 和发布教程版本是不同动作，
不互相隐含。

交付说明至少包含：

- 目标和实际结果。
- 变更文件。
- 关键设计理由和仍开放的问题。
- 运行过的检查及结果。
- 没有运行的检查及原因。
- 风险、兼容性、迁移和回滚影响。
- 对 Book、ADR、Experiment、Example、Checkpoint 或 Errata 的影响。

## 12. 发布 Lesson、Chapter 和 Checkpoint

只有维护者确认后才能发布正式 tag。

Tag 语义：

- Checkpoint tag 唯一表示一个可恢复的代码状态。
- Lesson 页面通过 `base_checkpoint` 和 `result_checkpoint` 引用零个、一个或多个 Checkpoint。
- 纯概念 Lesson 可以没有结果 Checkpoint。
- Lesson tag 表示页面出版，不承担代码状态语义；当一页结束于一个新状态时，它可以与结果 Checkpoint tag 指向
  同一文档 commit。
- Chapter/tutorial tag 表示一组页面已经出版。

Lesson/Checkpoint 出版需要通过三个独立门：

### 代码门

- 目标行为完成。
- 相关 build/lint/test/runtime 证据明确。
- 没有意外生产依赖或未处理 secret。

### 解释门

- Why 已由维护者确认，或明确标记为 `INFERRED`/`OPEN`。
- 候选方案、代价、限制和失败被记录。
- 页面引用真实存在的文件、symbol、commit 和 tag。

### 发布门

- 页面状态经过 review。
- 起始和结果状态可从干净 checkout 恢复。
- 章节索引和 Previous/Next 链路一致。
- annotated tag 的消息包含 ID、标题和验证摘要。
- tag 已推送后视为不可变。

规范 tag pattern：

```text
lesson/l001-onboarding-root
chapter/ch13-onboarding
checkpoint/cp001-mock-root
experiment/exp0001-storage-boundary/result
tutorial/v0.1.0
app/v0.1.0
```

教程版本和 App 版本不能混用。发现已发布页面错误时增加 Errata 或新修订版，不移动旧 tag。

## 13. Review checklist

提交审查前确认：

- [ ] 变化只有一个清晰目标。
- [ ] 当前问题、非目标和 Why 已说明。
- [ ] 没有把计划写成已实现事实。
- [ ] 没有把推断写成维护者决定。
- [ ] 真实 `@main`/runtime 路径已在需要时核验。
- [ ] Target/Scheme/Configuration/Environment 没有混用。
- [ ] 没有无理由增加架构层或第三方依赖。
- [ ] Mock、Firebase/API 和生产数据边界安全。
- [ ] 相关测试和验证已运行，未运行项已披露。
- [ ] tracked/staged diff check 通过。
- [ ] Commit 标题符合 `[Type] Short description`。
- [ ] 只暂存本次授权文件。
- [ ] 对应 Lesson/ADR/Experiment/Checkpoint 影响已记录。
- [ ] 没有改写已发布历史或移动不可变 tag。
