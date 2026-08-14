# DISC-0001：收敛 Agent-native AIDEV

```yaml
id: DISC-0001
status: converged
recording_mode: contemporaneous
opened_at: 2026-08-12
converged_at: 2026-08-13
decision: ../DECISIONS/DEC-0001-agent-native-aidev.md
```

## 原始问题

Omnia 的大型 `ai_dev` 已经暴露出任务数量膨胀、状态复制、索引漂移、规则过长和跨 Agent 接手困难等问题。iOSTG 需要作为新 AIDEV 的真实孵化项目，未来再评估是否抽离为独立库。

## 发散过的方向

- 用更完整的 WorkUnit、Grant、Gate、Event、Evidence 和 Reducer 精确表达全部过程。
- 建立人类看板、讨论、决定和任务登记后，再逐步自动化。
- 直接依赖 Codex Skills、MCP 或项目管理产品。
- 把所有项目规则写进 Agent 每次必须读取的说明。
- 根据任务风险选择不同治理精度。

## 发现的关键矛盾

精密协议可以描述理想状态，但 Agent 不会每次加载全部规则，也不能保证稳定记忆和完全遵从。如果系统可靠性依赖 Agent 阅读并记住大量文字，规则越多，实际可靠性不一定越高。

## 收敛结论

1. AIDEV 首先是项目连续性控制层和最小上下文编译器，不是超级规则手册。
2. 人类入口先于底层协议：必须先能看到想法、讨论、决定、任务和当前焦点。
3. AI 生成的 Task 默认只是提案；维护者接受后才能实施。
4. Agent 每次只接收一页当前任务包，专业知识按需从 Skills、MCP 和项目文件加载。
5. 必须可靠的约束最终由确定性工具检查，不能依赖 Agent 自觉。
6. Quick、Standard、Controlled 三种模式按风险增加治理精度。
7. 现有复杂 YAML 保留为实验 fixture，不再作为日常入口。

## 未在本次决定中收口

- Reducer 的具体实现语言和存储格式。
- 是否提供 CLI、Web UI 或第三方项目管理集成。
- 独立库的包结构和发布方式。
- 各 Agent/供应商适配器的最终接口。

这些内容继续留在 Inbox，不能从本次讨论推导为已接受任务。
