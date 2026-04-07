# Obsidian Skill v2 — 纯知识型设计

## Overview

将 obsidian-skill 从脚本型重构为纯知识型，参考 pablo-mano/Obsidian-CLI-skill 的架构。

**核心变化**：
- 删除所有 shell scripts
- SKILL.md 教 Claude 如何使用官方 Obsidian CLI
- Claude 自身处理 AI 推理（不再调用外部 `claude -p`）
- 利用 Obsidian CLI v1.12+ 的完整能力

**Why:**
- 脚本是不必要的中间层 — Obsidian CLI 已提供完整功能
- 知识型 skill 更简洁、可维护
- 覆盖范围更广（130+ 命令 vs 4 个自定义命令）
- 减少依赖（无需外部 `claude` CLI）

---

## 新架构

```
plugin/skills/obsidian/
├── SKILL.md              # 纯知识型 skill（核心文件，约 150 行）
└── references/
    └── command-reference.md  # 完整命令参考（可选，从 pablo-mano 复制）
```

**删除的文件**：
- `scripts/orchestrator.sh`
- `scripts/obsidian-ask.sh`
- `scripts/obsidian-new.sh`
- `scripts/obsidian-append.sh`
- `scripts/obsidian-list.sh`
- `scripts/obsidian-vault.sh`
- `tests/*.sh`

---

## SKILL.md 内容结构

### Frontmatter
```yaml
---
name: obsidian
description: Interact with Obsidian vault via official CLI. Search, read, create notes, manage daily notes, tasks, and properties.
triggers:
  - obsidian
  - vault
  - daily note
  - search my vault
  - create a note
  - read note
---
```

### Sections

| Section | 内容 | 长度 |
|---------|------|------|
| Prerequisites | Obsidian v1.12+, CLI enabled, app running | ~20 行 |
| Syntax | `obsidian <command> [key=value]` 基础格式 | ~10 行 |
| 常用命令速查表 | 15 个高频命令 | ~30 行 |
| Agent 工作流 | Claude 如何搜索、回答问题、创建笔记 | ~40 行 |
| Tips | 路径规则、管道技巧、常见问题 | ~30 行 |
| Troubleshooting | 常见错误和解决方案 | ~20 行 |

---

## 覆盖的常用命令

| 类别 | 命令 | 用途 |
|------|------|------|
| **读取** | `read`, `search`, `search:context`, `daily:read` | 查看笔记内容 |
| **写入** | `create`, `append`, `prepend`, `daily:append` | 创建和修改笔记 |
| **属性** | `properties`, `property:set`, `property:read` | Frontmatter 管理 |
| **发现** | `files`, `folders`, `tags`, `tasks` | 列出和统计 |
| **链接** | `backlinks`, `orphans`, `unresolved` | 图分析 |
| **管理** | `move`, `rename`, `delete` | 文件操作 |

**不覆盖的命令**（放入 references 文件）：
- sync（Obsidian Sync 管理）
- themes/snippets（主题管理）
- plugins（插件管理）
- dev（开发者工具）
- bases（Obsidian Bases）
- history（文件历史）

---

## Agent 工作流

### 回答 vault 问题

当用户问 vault 相关问题时：

1. **搜索相关笔记**：
   ```bash
   obsidian search query="<关键词>" format=json
   ```
2. **读取 top 结果**：
   ```bash
   obsidian read path="<path>"
   ```
3. **Claude 综合推理**：用自己的能力处理笔记内容
4. **输出答案**：用 `[[Note Title]]` 格式标注来源

### 创建笔记

```bash
obsidian create path="<title>" content="# <title>\n\n"
obsidian property:set path="<title>.md" name="created" value="$(date -I)"
```

### 添加到 daily note

```bash
obsidian daily:append content="- [ ] New task from Claude"
```

---

## 与旧版对比

| 方面 | v1 (脚本型) | v2 (知识型) |
|------|-------------|-------------|
| 文件数 | 6 scripts + SKILL.md | 1 SKILL.md |
| 依赖 | Obsidian CLI + `claude` CLI | Obsidian CLI only |
| 命令覆盖 | 4 个自定义命令 | 130+ 官方命令 |
| AI推理 | 调用外部 `claude -p` | Claude 自身处理 |
| vault路径 | 自定义检测脚本 | CLI 自动处理 |
| 维护成本 | 高（多脚本） | 低（单文件） |

---

## 实现步骤

1. 删除 `plugin/skills/obsidian/scripts/` 目录
2. 删除 `tests/` 目录
3. 重写 `plugin/skills/obsidian/SKILL.md`
4. 可选：复制 pablo-mano 的 command-reference.md 到 references/
5. 更新 `plugin/manifest.json`
6. 测试：验证 Claude 能正确调用 Obsidian CLI

---

## Success Criteria

- Claude 能用 `obsidian search` 搜索 vault
- Claude 能用 `obsidian read` 读取笔记
- Claude 能用 `obsidian create` 创建笔记
- Claude 能用 `obsidian daily:append` 添加内容
- Claude 能综合笔记内容回答用户问题
- 无脚本文件残留
- SKILL.md 文件少于 200 行