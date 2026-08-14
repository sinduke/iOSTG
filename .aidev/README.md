# AIDEV incubation

这里是 AIDEV 在 iOSTG 中的实验工作台。它帮助维护者和不同 Agent 保存已经确认的决定、已接受的任务、必要权限、验证证据和交接信息；它不是 iOSTG App 或教程的运行时依赖。

```yaml
schema_status: draft
applicability: experimental
canonical_project_state: false
operational_authorization: false
```

## 从这里开始

1. 打开 [NOW.md](NOW.md)，了解此刻唯一需要关注的事项。
2. 打开 [BOARD.md](BOARD.md)，查看讨论、决定和任务导航。
3. 新想法先进入 [INBOX.md](INBOX.md)，不要直接变成正式任务。
4. AI 可以提出任务；只有维护者接受后，任务才允许进入实施。
5. Task 必须作为独立步骤先落盘；确认可读取后，才能开始实施修改。

## 日常路径

```text
Idea
  -> Discussion (发散与收敛)
  -> Decision (维护者确认)
  -> Proposed Task (AI 可以生成)
  -> Accepted Task (维护者接受并先独立落盘)
  -> Implementation
  -> Run + Evidence
  -> Acceptance
  -> Handoff
```

当前第一条完整演练是：

- [DISC-0001：收敛 Agent-native AIDEV](DISCUSSIONS/DISC-0001-agent-native-aidev.md)
- [DEC-0001：采用 Agent-native AIDEV](DECISIONS/DEC-0001-agent-native-aidev.md)
- [TASK-0001：建立最小人类工作台](TASKS/TASK-0001-minimum-human-workbench.md)

第一条流程纠正是：

- [DEC-0002：Task 必须先于实施独立落盘](DECISIONS/DEC-0002-task-first.md)
- [TASK-0002：确立 Task-first 执行顺序](TASKS/TASK-0002-enforce-task-first.md)

## Task-first 不变量

讨论和 Decision 负责保存收敛结果；一旦维护者要求进入实施，必须先独立生成已接受 Task，再开始任何范围内的项目修改。

- Task 文件必须先落盘、能够被重新读取，并保存目标、范围、权限和完成条件。
- 生成 Task 和执行 Task 不能合并成同一个修改步骤。
- 任务看起来很小、预计只需几分钟，不构成跳过 Task 的理由。
- 执行可能持续数小时或跨 Agent；下一位 Agent 必须能只依靠 Task 和当前 diff 接续。
- 如果执行中发现需要扩大范围，先暂停执行，修订 Task 或创建新的已接受 Task，然后继续。
- `Quick` 模式只适用于不修改项目状态的问答和只读分析。

## AIDEV 的职责边界

AIDEV 必须帮助项目完成：

- 从发散讨论形成维护者决定。
- 从决定形成候选任务，并等待维护者接受。
- 为当前 Agent 编译最小任务上下文。
- 按风险管理权限、证据和验收。
- 让更换 Agent 后仍能继续工作。

AIDEV 永远不负责：

- 替维护者做最终产品、架构或发布决定。
- 取代 Git、CI、测试系统、Skills、MCP 或专业工具。
- 保存所有聊天、完整推理过程或无关搜索过程。
- 强迫所有小操作进入复杂审批。
- 让 iOSTG 代码、构建或运行依赖 `.aidev/`。

## 事实归属

| 事实 | 权威记录 |
| --- | --- |
| 为什么这样做 | `DECISIONS/` 中维护者确认的 Decision |
| 正式需要完成什么 | `TASKS/` 中维护者接受的 Task revision |
| 允许执行什么高风险动作 | 独立 Grant 或维护者的明确授权 |
| 实际执行和验证了什么 | Run / Event / Evidence |
| 是否接受结果 | Acceptance |
| 当前状态 | 将来由事件和验收记录计算 |
| 人看到的概览 | `NOW.md` 和 `BOARD.md` 投影，不是独立事实源 |

同一事实只能有一个权威归属。看板可以引用它，但不能成为第二个可独立修改的状态来源。

## 风险模式

| 模式 | 用途 | 最小要求 |
| --- | --- | --- |
| `Quick` | 提问、解释、只读调查 | 不要求正式 Task；不得修改项目状态 |
| `Standard` | 可恢复的本地修改、构建、测试 | 实施前独立落盘的已接受 Task、完成条件、验证证据 |
| `Controlled` | commit、push、tag、发布、生产或外部修改、不可逆操作、多 Agent 并发写入 | 实施前独立落盘的已接受 Task、精确授权、Gate、证据和恢复边界 |

模式不会自动授予权限。仓库 `AGENTS.md` 和用户本轮授权仍然优先。

## 目录

```text
.aidev/
├── README.md
├── NOW.md
├── BOARD.md
├── INBOX.md
├── DISCUSSIONS/
├── DECISIONS/
├── TASKS/
├── templates/
└── examples/
```

`templates/` 和 `examples/` 是早期精密协议实验，当前相当于 lab/spec fixture。它们不是日常入口、真实授权、当前项目状态或已接受的全局 schema。

## 安全边界

- 复制或修改 `.aidev/` 文件不会授予能力。
- `read`、`analyze`、`propose` 不隐含 `edit`、`commit`、`push` 或发布权限。
- Agent 提案不能自动创造维护者 Decision、Task Acceptance 或结果 Acceptance。
- 不在这里保存凭据、私有推理、完整聊天、模拟器标识或未脱敏用户数据。
- `.aidev/` 缺失或损坏时，iOSTG 仍必须能够独立构建、运行和阅读。
