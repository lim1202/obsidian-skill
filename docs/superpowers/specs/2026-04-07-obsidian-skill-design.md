# Obsidian Skill — Design Specification

## Overview

A Claude Code Skill that enables conversational interaction with the Obsidian vault via slash commands. Integrates Obsidian CLI with Claude's AI reasoning to activate knowledge buried in notes.

**Scope:** Single vault (the current Obsidian vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`). Multi-vault support is out of scope for v1.

---

## Core Commands

### `/obsidian ask <question>`

Searches the vault and answers a question using relevant notes.

**Flow:**
1. Receive `<question>`
2. Execute `obsidian search "<question>"`
3. Read top 5 matching note files (full text)
4. Construct a prompt: question + note contents + instruction to cite sources
5. Execute `claude -p --model opus-4.6` with the prompt
6. Return formatted answer with source references

**Output format:**
- Direct answer to the question
- Bullet points of key insights from notes
- Source: `[[Note Title]]` for each referenced note

**Error handling:**
- If no results from search: "I couldn't find anything in your vault matching that query."
- If note read fails: skip that note, proceed with remaining results
- If Claude API fails: return error with suggestion to retry

---

### `/obsidian new <title>`

Creates a new note with the given title.

**Flow:**
1. Receive `<title>`
2. Sanitize title (remove invalid filename characters)
3. Create file at `$VAULT_DIR/<title>.md`
4. If template folder exists (`Template/`), prepend template content
5. Open the note with `obsidian open`

**Note naming:**
- Whitespace replaced with `-`
- Special characters stripped
- Deduplication: if `<title>.md` exists, append `-1`, `-2`, etc.

---

### `/obsidian append <path> <content>`

Appends content to a specific note.

**Flow:**
1. Receive `<path>` (relative to vault root, e.g., `Work/project-x.md`) and `<content>`
2. Resolve full path: `$VAULT_DIR/<path>`
3. Append `\n<content>` to the file
4. Return confirmation

**Constraints:**
- `<path>` must be within vault (no `../` escape)
- If file doesn't exist: return error suggesting `/obsidian new` instead

---

### `/obsidian list [folder]`

Lists notes in a folder (default: root).

**Flow:**
1. Receive optional `<folder>`
2. Execute `ls $VAULT_DIR/<folder>/`
3. Return markdown list of filenames

---

## Technical Architecture

```
/obsidian (skill entry)
    │
    ├── orchestrator.sh           # Shell script that routes commands
    │       │
    │       ├── obsidian-ask.sh   # /obsidian ask flow
    │       ├── obsidian-new.sh   # /obsidian new flow
    │       └── obsidian-append.sh # /obsidian append flow
    │
    └── obsidian skill.md         # Skill definition (slash command handler)
```

**Prerequisites:**
- Obsidian CLI installed and registered in PATH (`obsidian` command available)
- `claude` CLI available (part of Claude Code)
- Vault path: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`

---

## Obsidian CLI Integration

| CLI Command | Used By | Purpose |
|-------------|---------|---------|
| `obsidian search "<query>"` | `obsidian-ask.sh` | Find relevant notes |
| `obsidian open "<path>"` | `obsidian-new.sh` | Open newly created note |
| `obsidian append "<path>" "<content>"` | `obsidian-append.sh` | Append to note (via obsidian) |

**Search result parsing:**
- `obsidian search` outputs note titles/paths
- Parse output to extract file paths for reading

**Fallback for unsupported operations:**
- Note creation: `echo "# <title>\n" > $VAULT_DIR/<title>.md` (no Obsidian CLI needed)
- Precise insertion: not supported, use append as workaround

---

## Implementation Phases

### Phase 1 — MVP (this spec)
- `/obsidian ask` — core value: knowledge Q&A
- `/obsidian new` — basic note creation
- `/obsidian append` — basic content append
- `/obsidian list` — utility

### Phase 2 — Enhancements (future)
- `/obsidian summarize` — summarize a specific note
- `/obsidian relate` — find connections between notes
- Add template support for `/obsidian new`

---

## Out of Scope for v1
- Multi-vault management
- Precise content insertion at arbitrary positions
- Background/daemon mode
- Real-time sync or watchers
- MCP Server layer (may be added in future)

---

## Success Criteria
- `/obsidian ask "keyword"` returns relevant notes and generates a coherent answer
- Answers cite specific note titles as sources
- All commands complete within 30 seconds
- No vault corruption or data loss (read-only operations preferred in v1)
