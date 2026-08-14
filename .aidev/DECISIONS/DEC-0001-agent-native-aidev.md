# DEC-0001：采用 Agent-native AIDEV

```yaml
id: DEC-0001
status: DECIDED
recording_mode: contemporaneous
decided_at: 2026-08-13
authority: maintainer
discussion: ../DISCUSSIONS/DISC-0001-agent-native-aidev.md
```

## 决定

iOSTG 中孵化的 AIDEV 采用“前台极简、后台精确”的 Agent-native 方向：先建立人类可读的控制面，再逐步实现最小上下文编译、风险分级、权限检查、证据和跨 Agent 交接。

## 必须成立

- 维护者保留最终产品、架构、任务接受和结果验收权。
- AI 可以发散、收敛和拆解，但生成内容默认是提案。
- 每个 Agent 只加载完成当前安全动作需要的最小上下文。
- 必须可靠的约束不能只存在于提示词或长篇规则中。
- 当前状态不能由多个文件各自手工维护为独立真相。
- iOSTG App、教程和 Git 工作流不能依赖 AIDEV 才能成立。

## 明确不采用

- 把一个超大 WorkUnit 或全部项目规则作为日常 Agent 输入。
- 把 Skill、MCP 或某个 Agent 产品直接等同于 AIDEV。
- 自动把讨论结论、AI 提案或“Agent 说完成”升级为维护者接受。
- 为了未来通用性，立即建设完整 CLI、数据库、Web 看板或插件系统。

## 影响

- 人类工作台成为第一实施任务。
- 现有精密 YAML 暂时保留为 lab/spec fixture。
- 后续自动化必须从真实使用中发现重复劳动，再逐步替换手工投影。
- 每个新增机制都需要说明它解决的当前问题、成本和退出条件。
