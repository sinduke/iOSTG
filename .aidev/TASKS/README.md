# AIDEV Tasks

这里登记正式 Task。AI 可以创建 `proposed` Task；只有维护者明确接受后，任务才允许进入实施。

## Task-first 执行不变量

一旦工作从讨论进入实施，必须遵循：

```text
完成收敛
  -> 生成 proposed Task
  -> 维护者接受
  -> accepted Task 独立落盘
  -> Agent 重新读取 Task
  -> 推进为 in_progress
  -> 开始其他实施修改
```

Task 必须是实施开始前的持久化检查点，不能和首次实施修改在同一个修改步骤中生成。任务看起来很小或预计很快完成，也不能跳过这个顺序。

Task 至少需要包含：

- 目标和接受依据。
- 本次范围与明确非目标。
- Agent 可以执行和必须先询问的动作。
- 完成条件和必要来源。
- Evidence 占位和中断后的 Handoff。

执行中如果发现范围扩大，先停止新范围的修改，再修订 Task 或创建新的已接受 Task。

## 状态

| 状态 | 含义 | 谁能推进 |
| --- | --- | --- |
| `proposed` | 候选任务，尚未授权实施 | AI 或维护者可提出 |
| `accepted` | 维护者已接受，尚未开始 | 维护者 |
| `in_progress` | 正在执行已接受范围 | 执行 Agent |
| `blocked` | 存在明确、可描述的阻塞 | 执行 Agent |
| `awaiting_acceptance` | 实施和验证已完成，等待维护者验收 | 执行 Agent |
| `completed` | 维护者已接受结果 | 维护者 |
| `cancelled` | 维护者终止任务 | 维护者 |

任务的 `status` 字段是该任务当前人工权威记录。`BOARD.md` 和 `NOW.md` 只是导航投影。在实现事件 Reducer 前，更新 Task 状态时必须同步刷新投影，并把这项人工同步限制明确保留。

## 登记

| Task | 模式 | 权威状态 |
| --- | --- | --- |
| [TASK-0001：建立最小人类工作台](TASK-0001-minimum-human-workbench.md) | Standard | 读取 Task 文件的 `status` |
| [TASK-0002：确立 Task-first 执行顺序](TASK-0002-enforce-task-first.md) | Standard | 读取 Task 文件的 `status` |
| [TASK-0003：重构 Onboarding 导航归属](TASK-0003-refactor-onboarding-navigation.md) | Standard | 读取 Task 文件的 `status` |
| [TASK-0004：新增 Lab 与 Button Design 完整示例](TASK-0004-add-lab-button-design-example.md) | Standard | 读取 Task 文件的 `status` |
| [TASK-0004A1：为 Button Design 增加 WebKit 中文文档阅读器](TASK-0004A1-add-webkit-documentation-reader.md) | Standard | 读取 Task 文件的 `status` |
