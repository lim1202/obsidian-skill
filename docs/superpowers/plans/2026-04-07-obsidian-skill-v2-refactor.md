# Obsidian Skill v2 Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor obsidian-skill from script-based to pure knowledge-type architecture, removing all shell scripts and rewriting SKILL.md.

**Architecture:** Single SKILL.md file teaches Claude how to use official Obsidian CLI v1.12+ commands. No intermediate scripts. Claude handles AI reasoning directly.

**Tech Stack:** Markdown skill definition, Obsidian CLI v1.12+, Claude Code plugin system

---

## File Structure

| Action | File | Purpose |
|--------|------|---------|
| Delete | `plugin/skills/obsidian/scripts/orchestrator.sh` | Remove routing script |
| Delete | `plugin/skills/obsidian/scripts/obsidian-ask.sh` | Remove ask handler |
| Delete | `plugin/skills/obsidian/scripts/obsidian-new.sh` | Remove new handler |
| Delete | `plugin/skills/obsidian/scripts/obsidian-append.sh` | Remove append handler |
| Delete | `plugin/skills/obsidian/scripts/obsidian-list.sh` | Remove list handler |
| Delete | `plugin/skills/obsidian/scripts/obsidian-vault.sh` | Remove vault detection |
| Delete | `tests/orchestrator.test.sh` | Remove test |
| Delete | `tests/obsidian-ask.test.sh` | Remove test |
| Delete | `tests/obsidian-new.test.sh` | Remove test |
| Delete | `tests/obsidian-append.test.sh` | Remove test |
| Delete | `tests/obsidian-list.test.sh` | Remove test |
| Delete | `tests/integration.test.sh` | Remove test |
| Rewrite | `plugin/skills/obsidian/SKILL.md` | New knowledge-type skill |
| Modify | `plugin/manifest.json` | Update version to 2.0.0 |
| Create | `plugin/skills/obsidian/references/command-reference.md` | Full CLI reference |

---

### Task 1: Delete Script Files

**Files:**
- Delete: `plugin/skills/obsidian/scripts/` (entire directory)

- [ ] **Step 1: Remove scripts directory**

```bash
rm -rf plugin/skills/obsidian/scripts/
```

- [ ] **Step 2: Verify deletion**

```bash
ls plugin/skills/obsidian/
```
Expected output: `SKILL.md` only (or `SKILL.md` + empty directory)

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "refactor: remove all shell scripts for v2 knowledge-type architecture"
```

---

### Task 2: Delete Test Files

**Files:**
- Delete: `tests/` (entire directory)

- [ ] **Step 1: Remove tests directory**

```bash
rm -rf tests/
```

- [ ] **Step 2: Verify deletion**

```bash
ls -la
```
Expected: no `tests/` directory listed

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "refactor: remove test scripts for v2 knowledge-type architecture"
```

---

### Task 3: Create References Directory and Command Reference

**Files:**
- Create: `plugin/skills/obsidian/references/command-reference.md`

- [ ] **Step 1: Create references directory**

```bash
mkdir -p plugin/skills/obsidian/references
```

- [ ] **Step 2: Fetch command reference from pablo-mano**

```bash
gh api repos/pablo-mano/Obsidian-CLI-skill/contents/skills/obsidian-cli/references/command-reference.md --jq '.content' | base64 -d > plugin/skills/obsidian/references/command-reference.md
```

- [ ] **Step 3: Verify file created**

```bash
wc -l plugin/skills/obsidian/references/command-reference.md
```
Expected: ~500+ lines (comprehensive reference)

- [ ] **Step 4: Commit**

```bash
git add plugin/skills/obsidian/references/command-reference.md
git commit -m "feat: add complete Obsidian CLI command reference"
```

---

### Task 4: Rewrite SKILL.md (Knowledge-Type)

**Files:**
- Rewrite: `plugin/skills/obsidian/SKILL.md`

- [ ] **Step 1: Write new SKILL.md**

```markdown
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

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Empty output | Start Obsidian app (CLI needs IPC) |
| Command not found | Re-enable CLI in Settings, restart terminal |
| Wrong vault | Pass vault name as first arg: `obsidian "Vault Name" command` |
| Windows Git Bash failures | Create wrapper for `Obsidian.com` |

## Full Reference

See `references/command-reference.md` for complete documentation of all 130+ commands including sync, plugins, themes, developer tools, and more.
```

Write to file:
```bash
cat > plugin/skills/obsidian/SKILL.md << 'EOF'
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

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Empty output | Start Obsidian app (CLI needs IPC) |
| Command not found | Re-enable CLI in Settings, restart terminal |
| Wrong vault | Pass vault name as first arg: `obsidian "Vault Name" command` |
| Windows Git Bash failures | Create wrapper for `Obsidian.com` |

## Full Reference

See `references/command-reference.md` for complete documentation of all 130+ commands including sync, plugins, themes, developer tools, and more.
EOF
```

- [ ] **Step 2: Verify file**

```bash
wc -l plugin/skills/obsidian/SKILL.md
```
Expected: ~100-120 lines

- [ ] **Step 3: Commit**

```bash
git add plugin/skills/obsidian/SKILL.md
git commit -m "refactor: rewrite SKILL.md as pure knowledge-type skill"
```

---

### Task 5: Update Manifest

**Files:**
- Modify: `plugin/manifest.json`

- [ ] **Step 1: Update manifest.json**

```bash
cat > plugin/manifest.json << 'EOF'
{
  "name": "obsidian-skill",
  "version": "2.0.0",
  "description": "Claude Code skill for Obsidian vault interaction via official CLI (v1.12+)"
}
EOF
```

- [ ] **Step 2: Verify change**

```bash
cat plugin/manifest.json
```
Expected: version 2.0.0

- [ ] **Step 3: Commit**

```bash
git add plugin/manifest.json
git commit -m "feat: bump version to 2.0.0 for knowledge-type refactor"
```

---

### Task 6: Update Marketplace JSON

**Files:**
- Modify: `marketplace.json`

- [ ] **Step 1: Check current marketplace.json**

```bash
cat marketplace.json
```

- [ ] **Step 2: Update marketplace.json with new description**

```bash
cat > marketplace.json << 'EOF'
{
  "name": "obsidian-skill",
  "version": "2.0.0",
  "description": "Claude Code skill for Obsidian vault interaction via official CLI (v1.12+)",
  "skills": [
    {
      "name": "obsidian",
      "path": "plugin/skills/obsidian/SKILL.md"
    }
  ]
}
EOF
```

- [ ] **Step 3: Commit**

```bash
git add marketplace.json
git commit -m "feat: update marketplace.json for v2.0.0"
```

---

### Task 7: Update README.md

**Files:**
- Modify: `README.md` (if exists)

- [ ] **Step 1: Check if README exists**

```bash
ls README.md 2>/dev/null || echo "No README.md"
```

- [ ] **Step 2: If README exists, update it to reflect v2 architecture**

```bash
cat > README.md << 'EOF'
# Obsidian Skill

A Claude Code skill for interacting with Obsidian vaults via the official Obsidian CLI (v1.12+).

## Installation

### Claude Code Marketplace

```bash
/plugin marketplace add https://github.com/<your-username>/obsidian-skill
/plugin install obsidian-skill
```

### Direct Plugin Load

```bash
git clone https://github.com/<your-username>/obsidian-skill
claude --plugin-dir ./obsidian-skill
```

## Prerequisites

- Obsidian Desktop v1.12.0+ (CLI released February 2026)
- CLI enabled in Obsidian Settings → Command line interface
- Obsidian app running (CLI communicates via IPC)

## Usage

The skill activates automatically when you mention Obsidian or vault operations. Examples:

- "Search my vault for meeting notes"
- "Create a note called Project Alpha"
- "Append to today's daily note: completed review"
- "What tasks are in my vault?"

Claude will use the Obsidian CLI to execute these operations.

## Commands Covered

See `plugin/skills/obsidian/references/command-reference.md` for the complete list of 130+ commands.

## License

MIT
EOF
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: update README for v2 knowledge-type architecture"
```

---

### Task 8: Manual Verification Test

**Files:**
- None (manual test)

- [ ] **Step 1: Verify Obsidian CLI is available**

```bash
obsidian version
```
Expected: version output if Obsidian is running and CLI enabled

- [ ] **Step 2: Test search command**

```bash
obsidian search query="test" limit=5
```
Expected: list of matching notes or "no results"

- [ ] **Step 3: Test files command**

```bash
obsidian files limit=5
```
Expected: list of files in vault

- [ ] **Step 4: Verify SKILL.md structure**

```bash
head -20 plugin/skills/obsidian/SKILL.md
```
Expected: YAML frontmatter with name, description, triggers

---

## Self-Review Checklist

- [x] Spec coverage: All requirements from spec have corresponding tasks
- [x] No placeholders: Every step has exact commands or code
- [x] Type consistency: N/A (no code types, only documentation)
- [x] File paths: All paths are exact and correct
- [x] Task granularity: Each step is 2-5 minute action
- [x] Commits: Each task ends with a commit

---

## Success Criteria

- All script files deleted
- SKILL.md rewritten (~100 lines)
- manifest.json updated to v2.0.0
- Command reference added
- Manual tests pass (Obsidian CLI commands work)