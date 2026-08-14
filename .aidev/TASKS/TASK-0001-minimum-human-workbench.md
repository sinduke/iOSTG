# TASK-0001：建立 AIDEV 最小人类工作台

```yaml
id: TASK-0001
status: awaiting_acceptance
mode: Standard
recording_mode: contemporaneous
created_at: 2026-08-13
accepted_at: 2026-08-13
accepted_by: maintainer
decision: ../DECISIONS/DEC-0001-agent-native-aidev.md
```

## 接受依据

维护者在完成目标、问题、作用和未来形态的收敛后，明确要求：“生成task文件 并进入实施阶段”。这授权本任务列出的 `.aidev` 文档修改和必要的只读验证；不授权 stage、commit、push、tag、发布或 iOSTG App 代码修改。

## 目标

建立第一版可直接阅读和交接的 AIDEV 工作台，并用 AIDEV 自身建设过程完成一条“讨论 → 决定 → 已接受任务 → 实施 → 证据 → 等待验收”的纵向演练。

## 本次范围

- 更新 `.aidev/README.md`，让它成为真正入口。
- 创建 `NOW.md`、`BOARD.md` 和 `INBOX.md`。
- 创建一份收敛讨论、一份维护者决定和正式 Task 登记。
- 在当前任务中提供一页 Agent 工作包、完成条件、验证证据和交接说明。
- 保留现有 YAML 协议实验文件，不修改其 schema。

## 不在本次范围

- iOSTG App 源码、教程或 Xcode 工程变更。
- CLI、Reducer、数据库、Web 看板和自动化脚本。
- Codex、MCP、Git、Xcode 或第三方项目管理适配器。
- stage、commit、push、tag、发布或外部系统修改。
- 将 Inbox 中的方向自动创建为更多正式 Task。

## Agent 工作包

```yaml
goal: 建立最小人类工作台并完成第一条纵向演练
mode: Standard
current: DEC-0001 已确认，TASK-0001 已完成实施和文档级验证
next: 等待维护者验收；收到修正意见后只修改明确范围
may:
  - 修改本任务列出的 .aidev Markdown 文件
  - 执行只读结构、引用、Git diff 和项目耦合检查
ask_before:
  - 扩大到代码、CLI、Reducer、自动化或第三方集成
  - stage、commit、push、tag 或发布
done_when:
  - NOW、BOARD、INBOX、Discussion、Decision、Task 均可导航
  - 人与 Agent 的权限边界和下一关清晰
  - 所有新增相对链接有效
  - iOSTG 工程没有引用 .aidev
sources:
  - ../../AGENTS.md
  - ../README.md
  - ../DISCUSSIONS/DISC-0001-agent-native-aidev.md
  - ../DECISIONS/DEC-0001-agent-native-aidev.md
```

## 实施清单

- [x] 建立人类入口和日常路径。
- [x] 建立发散/收敛记录。
- [x] 建立维护者 Decision。
- [x] 建立正式 Task 状态和登记规则。
- [x] 建立一页 Agent 工作包。
- [x] 把未来能力留在 Inbox，而不是自动升级为任务。
- [x] 执行结构、引用、diff 和项目独立性验证。
- [x] 记录验证结果并交给维护者验收。

## 完成条件

1. 新 Agent 从 `.aidev/README.md` 或 `NOW.md` 开始，可以找到当前目标、决定、任务、权限边界和下一步。
2. AI 提案与维护者已接受任务有明确区别。
3. 工作台不会把复杂协议 fixture 描述成当前授权或项目状态。
4. 文档内部引用有效，`git diff --check` 通过。
5. iOSTG 项目文件和源码不引用 `.aidev`。

## Evidence

```yaml
verified_at: 2026-08-13
verification_scope: documentation_and_repository_structure
result: passed
```

- `git diff --check`：跟踪文件的差异格式通过。
- 本地 Markdown 检查：扫描 `.aidev/**/*.md` 的相对链接和尾随空白，8 个文件通过。
- 项目耦合检查：在 Swift、Xcode project 和 xcconfig 范围内没有发现 `.aidev` 引用。
- `git status --short --branch`：确认本轮只修改或新增 `.aidev` 范围文件；工作区开始时为干净的 `main...origin/main`。

未执行 Xcode build 或测试。本任务只修改治理 Markdown，不声明 App 代码或运行行为发生变化。

## Process deviation

TASK-0001 文件与它所描述的工作台实施文件在同一次修改中生成，没有先作为独立检查点落盘。维护者于 2026-08-13 指出该顺序无法充分保护可能持续数小时的任务上下文。

此偏差不会被静默改写为正确流程。后续规则由 [DEC-0002](../DECISIONS/DEC-0002-task-first.md) 确认，修正工作由 [TASK-0002](TASK-0002-enforce-task-first.md) 执行。TASK-0001 的产物仍等待维护者验收，但不能再被称为完整证明了 Task-first 的正确演练。

## Handoff

下一位 Agent 应先读取 `.aidev/NOW.md`，再读取本 Task 和 DEC-0001。不要把 Inbox 条目当成已接受任务，也不要继续扩展底层协议；当前下一关是维护者验收工作台。
