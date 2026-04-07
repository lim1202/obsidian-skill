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

## Configuration

The vault path is auto-detected in this order:

1. `OBSIDIAN_VAULT_DIR` environment variable
2. Saved path at `~/.obsidian-skill/config`
3. Common vault locations (iCloud Obsidian, ~/Obsidian, etc.)
4. **Prompt user** if no vault found, then save to `~/.obsidian-skill/config`

To set manually:
```bash
export OBSIDIAN_VAULT_DIR=~/obsidian/my-vault
```

## Prerequisites

- [Obsidian CLI](https://github.com/obsidianmd/obsidian-cli) installed and in PATH

## Testing

```bash
bash tests/orchestrator.test.sh
bash tests/obsidian-new.test.sh
bash tests/obsidian-append.test.sh
bash tests/obsidian-list.test.sh
```
