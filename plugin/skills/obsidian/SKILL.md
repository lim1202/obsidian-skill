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
  - append to
---

# Obsidian CLI Skill

Control your Obsidian vault from Claude Code using the official Obsidian CLI (v1.12+).

## Prerequisites

| Requirement | Details |
|-------------|---------|
| Obsidian Desktop | v1.12.0+ (CLI released Feb 2026) |
| CLI enabled | Settings → Command line interface → Toggle ON |
| Obsidian running | Desktop app must be running (IPC communication) |

**Enable CLI:** Open Obsidian Settings → Core settings → Command line interface → Toggle ON. This registers the `obsidian` binary in PATH.

## Syntax

```bash
obsidian <command> [subcommand] [key=value ...] [flags]
```

All parameters use `key=value` syntax. Quote values with spaces.

## Common Commands

### Reading & Searching

```bash
obsidian read path="folder/note.md"           # Read a note
obsidian search query="keyword"               # Full-text search
obsidian search query="term" format=json      # JSON output
obsidian daily:read                           # Read today's daily note
```

### Creating & Editing

```bash
obsidian create path="new-note" content="# Title\n\nBody"
obsidian append path="note.md" content="New paragraph"
obsidian prepend path="note.md" content="Top content"
obsidian daily:append content="- [ ] Task"
```

### Properties & Metadata

```bash
obsidian properties path="note.md"            # List all properties
obsidian property:set path="note.md" name="status" value="active"
obsidian property:read path="note.md" name="status"
obsidian tags counts sort=count               # Most-used tags
```

### Discovery & Analysis

```bash
obsidian files                                # List all files
obsidian folders                              # List folders
obsidian tasks                                # All tasks
obsidian backlinks path="note.md"             # Notes linking to this
obsidian orphans                              # Notes with no links
obsidian unresolved                           # Broken wikilinks
```

### File Management

```bash
obsidian move path="old.md" to="new.md"
obsidian rename path="note.md" to="new-name"
obsidian delete path="note.md"
```

## Agent Workflows

### Answering Vault Questions

When user asks about vault content:

1. Search relevant notes:
   ```bash
   obsidian search query="<keyword>" format=json
   ```

2. Read top results:
   ```bash
   obsidian read path="<path>"
   ```

3. Synthesize answer with Claude's reasoning

4. Cite sources using `[[Note Title]]` format

### Creating Notes with Metadata

```bash
obsidian create path="project/new-feature" content="# New Feature\n\n"
obsidian property:set path="project/new-feature.md" name="created" value="$(date -I)"
obsidian property:set path="project/new-feature.md" name="status" value="planning"
```

### Daily Note Automation

```bash
obsidian daily:append content="## $(date '+%H:%M') Update
- Completed: task
- Next: action"
```

## Tips

1. **Paths are vault-relative** — use `folder/note.md`, not absolute paths
2. **`create` omits `.md`** — extension added automatically
3. **`move` requires `.md`** — include extension in target path
4. **Pipe-friendly** — output works with `grep`, `jq`, `awk`
5. **JSON search** — `format=json` returns array for scripting
6. **Sandbox mode** — CLI needs filesystem access; use `dangerouslyDisableSandbox: true` when calling via Bash tool

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Empty output | Start Obsidian app (CLI needs IPC) |
| Command not found | Re-enable CLI in Settings, restart terminal |
| Wrong vault | Pass vault name as first arg: `obsidian "Vault Name" command` |
| Windows Git Bash failures | Create wrapper for `Obsidian.com` |
| Sandbox blocks access | Set `dangerouslyDisableSandbox: true` in Bash tool |

## Full Reference

See `references/command-reference.md` for complete documentation of all 130+ commands including sync, plugins, themes, developer tools, and more.