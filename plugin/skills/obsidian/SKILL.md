---
name: obsidian
description: Interact with your Obsidian vault via conversational AI. Use when working with Obsidian notes, creating notes, searching vault content, or managing knowledge base. Commands: /obsidian ask (search and answer questions), /obsidian new (create notes), /obsidian append (add content), /obsidian list (browse notes).
---

# obsidian

Interact with your Obsidian vault via conversational AI.

## Commands

### ask <question>

Searches your vault and answers questions using relevant notes.

**Usage:** `/obsidian ask <question>`

**Example:** `/obsidian ask what projects am I working on`

### new <title>

Creates a new note with the given title.

**Usage:** `/obsidian new <title>`

**Example:** `/obsidian new Meeting Notes 2024-04-07`

### append <path> <content>

Appends content to a specific note.

**Usage:** `/obsidian append <path> <content>`

**Example:** `/obsidian append Work/project-x.md Added action items from today's meeting`

### list [folder]

Lists notes in a folder (default: root).

**Usage:** `/obsidian list [folder]`

**Example:** `/obsidian list Work`

---

**Notes:**
- Commands operate on the vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`
- `<path>` is relative to the vault root (e.g., `Work/project-x.md`)
- The ask command uses AI to synthesize answers from your notes
- Obsidian CLI (`obsidian`) must be installed and in PATH
