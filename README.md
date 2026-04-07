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
- CLI enabled in Obsidian Settings -> Command line interface
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