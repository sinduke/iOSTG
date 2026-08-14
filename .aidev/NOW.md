# NOW

```yaml
updated_at: 2026-08-14
projection: manual
canonical_truth: false
```

## 当前焦点

[TASK-0004A1：为 Button Design 增加 WebKit 中文文档阅读器](TASKS/TASK-0004A1-add-webkit-documentation-reader.md)

本页只提供入口。任务范围、状态、完成条件和证据以 TASK 文件为准。

## 一页 Agent 工作包

```yaml
goal: 在 Button Design 中提供离线 WebKit Full Chinese Guide
mode: Standard
current: TASK-0004A1 已完成实现与验证，父任务 TASK-0004 恢复等待整体验收
next: 维护者在模拟器浏览器中验收 toolbar Guide、WebKit 排版、滚动、返回和顶部 safe-area 行为
may:
  - 读取 TASK-0004 与 TASK-0004A1 的实现、测试、文档和证据
  - 在当前模拟器浏览器中验收现场行为
ask_before:
  - 引入外部依赖或网络内容
  - 将阅读器接入 Lab 之外的业务页面
  - stage、commit、push、tag、发布或外部修改
done_when:
  - Full Chinese Guide 可点击并使用 WebKit 展示格式化 Markdown
  - 正文保持单一来源且完全离线
  - loading、error、retry、滚动和文本选择行为完整
  - lint、build、定向测试和 Simulator 真实路径完成验证
sources:
  - AGENTS.md
  - .aidev/DECISIONS/DEC-0002-task-first.md
  - .aidev/TASKS/TASK-0004A1-add-webkit-documentation-reader.md
```

## 维护者下一关

整体验收 TASK-0004 的 Lab、Button Design 与 TASK-0004A1 Full Chinese Guide。TASK-0003、TASK-0002 仍独立保持 `awaiting_acceptance`。
