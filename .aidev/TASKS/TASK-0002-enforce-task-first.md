# TASK-0002：确立 Task-first 执行顺序

```yaml
id: TASK-0002
status: awaiting_acceptance
mode: Standard
recording_mode: contemporaneous
created_at: 2026-08-13
accepted_at: 2026-08-13
accepted_by: maintainer
```

## 接受依据

维护者纠正当前实施顺序：“task文件 应该是先生成。然后按照task文件执行”。维护者同时指出，即使任务看起来很小，实际执行也可能持续数小时；先持久化 Task 才能保护已经收敛的信息和跨 Agent 连续性。

## 目标

把“Task 必须先于实施修改独立生成”确立为 AIDEV 的基础执行不变量，并修正 TASK-0001 演练中没有真正体现该顺序的问题。

## 本次范围

- 记录一项维护者 Decision，明确 Task-first 不变量。
- 更新 AIDEV 入口、任务规则、当前工作包和看板。
- 如实记录 TASK-0001 的过程偏差，不改写历史使其看起来从未发生。
- 明确紧急修复或执行中发现新范围时的处理方法。
- 执行文档链接、空白、diff 和项目独立性验证。

## 不在本次范围

- 实现 CLI、Reducer、数据库或自动生成器。
- 修改 iOSTG App 源码、教程或 Xcode 工程。
- stage、commit、push、tag、发布或外部系统修改。

## 执行顺序

1. 本 Task 文件必须首先独立写入磁盘。
2. 重新读取本 Task，确认目标、范围、权限和完成条件。
3. 将状态推进为 `in_progress`，才开始修改其他文件。
4. 执行范围内修改和验证。
5. 填写 Evidence，并推进为 `awaiting_acceptance`。
6. 只有维护者验收后才能进入 `completed`。

## Agent 工作包

```yaml
goal: 让 Task 成为所有实施修改之前的持久化执行检查点
mode: Standard
current: TASK-0002 已按顺序完成实施和验证，正在等待维护者验收
next: 维护者决定接受结果或提出明确修正
may:
  - 修改本 Task 明确列出的 .aidev Markdown 治理文件
  - 执行只读结构、链接、diff 和耦合检查
ask_before:
  - 扩大到自动化、代码、工程配置或第三方集成
  - stage、commit、push、tag 或发布
done_when:
  - 文档明确规定 accepted Task 必须先于实施修改落盘
  - TASK-0001 的顺序偏差被如实记录
  - 执行中扩大范围时必须暂停并修订或新建 Task
  - 验证通过并留下可交接 Evidence
sources:
  - ../../AGENTS.md
  - ../README.md
  - README.md
  - TASK-0001-minimum-human-workbench.md
```

## 实施清单

- [x] TASK-0002 在其他实施修改之前独立生成。
- [x] 重新读取 TASK-0002 并进入实施。
- [x] 创建 Task-first Decision。
- [x] 更新入口、任务规则、NOW 和 Board。
- [x] 如实记录 TASK-0001 的过程偏差。
- [x] 执行验证并记录 Evidence。

## 完成条件

1. 新任务在任何代码或项目文档实施修改之前，必须有已接受 Task 文件落盘。
2. Task 至少保存目标、范围、非目标、权限边界、完成条件和必要来源。
3. 执行持续时间不影响该规则；“看起来很小”不能成为跳过 Task 的理由。
4. 执行中发现范围扩大时，Agent 必须先暂停并更新 Task revision，或先创建新的 Task。
5. Quick 模式仍可用于纯问答和只读分析；一旦开始修改项目文件，必须先进入已接受 Task。

## Evidence

```yaml
verified_at: 2026-08-13
verification_scope: documentation_and_repository_structure
result: passed
```

- 顺序证据：`TASK-0002` 首先以 `accepted` 状态独立写入磁盘并重新读取；此后才推进为 `in_progress` 并修改其他文件。
- `git diff --check`：通过。
- 本地 Markdown 检查：扫描 `.aidev/**/*.md` 的相对链接、尾随空白和文件结尾，10 个文件通过。
- 项目耦合检查：Swift、Xcode project 和 xcconfig 中没有 `.aidev` 引用。
- 状态检查：NOW 和 Board 指向 TASK-0002；TASK-0001 保留 `Process deviation` 并链接 DEC-0002/TASK-0002。

未执行 Xcode build 或测试。本任务只修改治理 Markdown，不声明 App 代码或运行行为改变。

## Handoff

如果当前 Agent 在执行中断开，下一位 Agent 应先读取本文件。看到 `accepted` 表示尚未开始其他实施修改；看到 `in_progress` 时，应根据实施清单和 Git diff 判断停在何处，不能重新发散或跳过未完成验证。
