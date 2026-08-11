# AGENTS.md

本文件是 iOSTG 仓库级 AI/Codex 操作合同，适用于整个仓库。以后如果子目录增加更具体的 `AGENTS.md`，子目录规则
可以补充本文件，但不得改变这里已经确认的项目边界和历史真实性要求。

## 1. 项目事实与长期边界

- 项目名称是 `iOSTG`。
- 产品范围仅为 iOS。
- 最低支持版本是 iOS 26.5。
- 项目是“可运行应用 + 演进式教程 + 架构史 + 实验库”，不是只追求最终代码状态的普通 App 仓库。
- 教程正文以中文为主；代码标识符、API 名称和技术专有名词保留英文。
- 维护者拥有产品、架构和代码收口的最终决定权。
- 未经明确请求，不替维护者实现架构收口、选择最终模式或扩大产品范围。

## 2. 当前仓库基线不是永久架构

初始回顾性状态由 [README.md](README.md#当前起点) 绑定到完整 commit SHA。该段只解释文档体系建立时的起点，不是
“当前架构”接口。

每次任务必须先读取当前 checkout；如果已经存在正式 Checkpoint，也要读取最新一个。随后重新检查源码、target、
configuration、scheme、Git 状态、真实 `@main` 路径、测试和依赖。不得把 README、旧 Lesson 或本文件中的历史快照
直接当作今天的事实。

## 3. 开始任何任务前

按顺序完成：

1. 阅读用户本轮目标，区分“分析、审查、记录、实现、封存、提交、推送、发布”。
2. 运行 `git status --short --branch`，确认分支、跟踪关系和未提交文件。
3. 查找并阅读任务范围内更深层的 `AGENTS.md`、规则文件和相关教程页面。
4. 阅读受影响文件的完整上下文，不只读取 diff 中新增的行。
5. 涉及启动、状态或导航时，先追踪 `@main` 和实际可达路径。
6. 涉及工程配置时，区分 Target、Scheme、Build Configuration 和运行环境。
7. 明确哪些内容是当前代码事实，哪些是计划或尚未决定的方向。

如果用户说“只是分析”“只看一下”或“检查当前变更”，不得修改文件、Git 配置、分支、tag 或远端状态。

## 4. 授权边界

默认允许的只读动作：

- 检查源码、工程配置、Git 历史和工作区。
- 阅读公开参考资料和用户明确提供的仓库。
- 在确认 destination、临时输出位置、非生产环境和数据副作用后，运行与任务相关的 lint、build、test 和诊断命令。
- 形成审查结论、教程草稿、问题列表和验证记录。

必须得到明确请求后才能：

- 修改正式 App 代码或工程配置。
- 增加、升级或移除第三方依赖。
- 创建或改变 target、scheme、configuration、entitlement 或服务环境。
- 暂存、提交、创建/移动 tag、推送、创建 PR 或发布。
- 运行会修改外部服务、Firebase 数据、生产 API、账号或发布状态的操作。

“提交”不自动包含“推送”；“构建成功”不表示测试、运行、发布或外部服务验证成功。

## 5. 最小、可解释的修改

- 只修改完成任务所需的范围。
- 保留用户已有但与本任务无关的修改。
- 不重写整个文件来完成局部调整。
- 不顺手进行无关格式化、重命名、目录整理或架构升级。
- 不因为某个模式流行就引入 ViewModel、Repository、Use Case、DI Container、VIPER、RIB 或模块化。
- 引入任何新边界前，说明它解决的当前问题、新增成本和退出条件。
- 新实现应遵循当前被确认的架构；如果当前存在两套竞争路径，先报告并等待维护者决定，不擅自选边收口。
- Xcode 当前使用 filesystem-synchronized group。不要照搬旧式工程教程，机械编辑 `PBXBuildFile`；先核验目标 Xcode
  工程的实际文件归属。

## 6. 教程真实性

Git diff 能证明代码变化，不能自动证明作者动机。重要结论必须使用以下标签：

| 标签 | 使用条件 |
| --- | --- |
| `DECIDED` | 维护者明确批准或确认 |
| `OBSERVED` | 从指定代码、配置、Git 或工具输出直接观察 |
| `VERIFIED` | 由记录的命令、测试或运行行为证明 |
| `INFERRED` | 有证据支持，但维护者尚未确认的解释 |
| `HYPOTHESIS` | 等待实验验证 |
| `EXPERIMENTAL` | 只在记录的实验条件下成立 |
| `OPEN` | 尚未决定或证据不足 |
| `SUPERSEDED` | 曾经有效，后来被新决定替代 |

禁止：

- 根据最终代码倒推“作者当时就是这样想的”。
- 把当前验证写成过去已经完成的验证。
- 把 Preview 可用、build 成功或文件存在描述成生产启动路径已经生效。
- 静默改写历史页面，让旧架构看起来从未存在。
- 手工复制整套历史源码到章节目录。

旧提交补录必须标记：

```yaml
recording_mode: retrospective
```

体系启用后同步形成的记录使用：

```yaml
recording_mode: contemporaneous
```

## 7. 教学内容合同

[CONTRIBUTING.md](CONTRIBUTING.md#7-教程页面要求) 是页面 ID、元数据、正文、Checkpoint/Tag 和发布流程的唯一规范来源。
Agent 不得在其他文件重新发明一套 schema。

执行文档任务时仍必须保证：

- 稳定 ID 不复用。
- Checkpoint 唯一表示可恢复代码状态；Lesson 通过 base/result checkpoint 解释状态变化。
- 完整 commit SHA、toolchain、验证环境和证据引用进入结构化元数据。
- Why、候选方案、代价和未验证项没有被 diff 或推断替代。
- 历史路径、symbol、ADR、Experiment、Example 和 supersedes 关系可追踪。
- Markdown 是第一阶段的单一正文来源；除用户明确要求，不维护第二套独立 DocC 正文。

## 8. 架构和课程演化规则

- Mock、Firebase、自建 API 和移动端独立服务是数据/系统提供方式，不应直接泄漏为 View 的业务模型。
- Firebase 是确定的第一版后端阶段，但采用哪些 Firebase 产品仍需逐项由需求决定。
- 自建 API 的服务端框架、数据库、认证、部署方式尚未决定，不得提前写成既定方案。
- “App 直接调用 RemoteService”和“App → Mobile Backend/BFF → 总后台”都属于待实验和 ADR 决定的候选方案。
- MV、MVVM、VIPER、RIB、RIB + VIPER + DI 是可比较的模式，不是从低级到高级的固定升级链。
- 正式采用架构前，优先在同一小功能上比较状态所有权、文件/代码量、测试、导航、编译、修改成本和理解成本。
- 失败、否定或无结论实验同样需要保存；不要只保留成功方案。
- 故意无法编译的实验不能进入 canonical App target。它应留在隔离分支/tag，正文只保存必要片段和错误证据。

## 9. 验证规则

验证应与风险成比例，并明确区分：

- 静态检查：格式、lint、配置和 diff。
- Build：编译与链接完成。
- Unit test：局部业务或状态行为。
- UI test：可观察的用户流程。
- Runtime：真实入口和实际设备/Simulator 行为。
- Integration：Firebase/API/数据库/第三方系统边界。
- Publication：tag、索引和干净 checkout 可复现。

常用基础命令：

```bash
git diff --check
git diff --cached --check
swiftlint lint --config .swiftlint.yml
xcodebuild -project iOSTG.xcodeproj -list
xcodebuild -project iOSTG.xcodeproj -scheme iOSTG -showdestinations
xcodebuild \
  -project iOSTG.xcodeproj \
  -scheme iOSTG \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

规则：

- 不把本机 simulator UUID 写入共享文件或教程规范。
- 使用临时 DerivedData/result bundle 时放在经验证的 `/tmp` 子目录，避免污染工作区。
- 测试命令需要具体 simulator 时，先读取 `-showdestinations`，再记录选择依据。
- 中断、跳过、仅编译测试或模板空测试不能报告为“测试全部通过”。
- 仅修改 Markdown 时，不必机械执行 Xcode build；但如果文档声称某个代码状态已构建或运行，必须有对应证据。
- 当前仓库没有 CI，不能声称 push 后会自动验证。
- `git diff --check` 不覆盖未跟踪文件；新文件显式暂存后使用 `git diff --cached --check`。

## 10. Git 和提交

开始前检查：

```bash
git status --short --branch
git diff --stat
git diff
```

在混合工作区中：

- 不使用 `git add -A` 或 `git add .`。
- 只暂存用户明确授权的路径。
- 暂存后检查 `git diff --cached --stat` 和 `git diff --cached`。
- 不覆盖、恢复或删除无法确认归属的用户修改。

每个 clone 需要启用 hook：

```bash
git config core.hooksPath .githooks
```

提交标题必须符合：

```text
[Type] Short description
```

默认使用中文简短描述。当前 hook 只能验证结构，不能验证描述语言。

允许的类型：

```text
[Base] [Feature] [Fix] [Refactor] [Docs] [Test] [Chore]
```

Git 自动生成的 merge/revert 以及临时 `fixup!`/`squash!` 消息按现有 hook 处理。ChatGPT/Codex desktop 的一键提交
可能绕过仓库 hook，因此必须主动生成合规标题，不能依赖 hook 自动修复。

发布历史规则：

- 不为修正旧标题而重写已经推送的 `main`。
- 不 force-push 已发布教程历史。
- 不移动、删除或复用已经发布的 checkpoint/lesson/chapter/tutorial tag。
- 历史错误使用 Errata、新 commit 或新教程修订版修复。
- 教程索引引用完整 40 位 SHA 或不可变 tag，不把移动中的 `main` 当作永久页码。
- branch 是写作或实验工作台，不是永久历史入口。

不得自行创建 commit、tag、push 或 PR；只有用户明确要求相应动作后才能执行，而且每种动作分别报告结果。

## 11. 本地文件和敏感信息

不得提交：

- 整个 `buildServer.json`；它由每台机器本地生成，并已在 `.gitignore` 中忽略。
- DerivedData、build 产物、xcuserdata、`*.xcuserstate`、模拟器 UUID。
- API key、私钥、生产 token、服务账号、签名材料或真实用户数据。
- 未脱敏的 Firebase/API/Analytics/Crash 日志。

引入 Firebase 或自建 API 时：

- 明确区分可公开的客户端配置和真正的访问控制/secret。
- 日常测试不得读写生产数据。
- 安全规则、服务端授权和最小权限必须独立验证；配置文件存在不代表数据安全。
- 不在输出、教程、截图或 Git 历史中泄露凭据。

## 12. 任务交付说明

最终回复必须简洁、可核验，并包含：

1. 实际完成了什么。
2. 修改的文件。
3. 执行了哪些检查，各自结果是什么。
4. 没有验证或被阻塞的内容。
5. 是否存在用户原有、未处理的修改。

如果使用历史或参考项目，只说明它提供了哪些观察，不把参考项目的现状当作 iOSTG 已采用的方案。
