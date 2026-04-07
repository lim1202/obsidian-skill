# Obsidian Skill

Claude Code skill for interacting with Obsidian vault via slash commands.

## Installation

1. Clone this repository
2. Add to Claude Code `settings.json`:

```json
{
  "enabledPlugins": {
    "obsidian-skill": true
  }
}
```

3. Run `/reload-plugins`

## Commands

| Command | Description |
|---------|-------------|
| `/obsidian ask <question>` | Search vault and answer questions using AI |
| `/obsidian new <title>` | Create a new note |
| `/obsidian append <path> <content>` | Append content to an existing note |
| `/obsidian list [folder]` | List notes in a folder |

## Prerequisites

- [Obsidian CLI](https://github.com/obsidianmd/obsidian-cli) installed and in PATH
- Vault path: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`

## Testing

```bash
bash tests/orchestrator.test.sh
bash tests/obsidian-new.test.sh
bash tests/obsidian-append.test.sh
bash tests/obsidian-list.test.sh
```
