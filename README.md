# Obsidian Skill

[![version](https://img.shields.io/github/v/release/lim1202/obsidian-skill?include_prereleases&label=version)](https://github.com/lim1202/obsidian-skill/releases)
[![license](https://img.shields.io/github/license/lim1202/obsidian-skill)](LICENSE)
[![CI](https://github.com/lim1202/obsidian-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/lim1202/obsidian-skill/actions/workflows/ci.yml)

A Claude Code skill for interacting with Obsidian vaults via the official Obsidian CLI (v1.12+).

## Installation

### Claude Code Marketplace

```bash
/plugin marketplace add https://github.com/lim1202/obsidian-skill
/plugin install obsidian-skill
```

### Direct Plugin Load

```bash
git clone https://github.com/lim1202/obsidian-skill
claude --plugin-dir ./obsidian-skill
```

## Prerequisites

- Obsidian Desktop v1.12.0+ (CLI released February 2026)
- CLI enabled in Obsidian Settings → Command line interface → Toggle ON
- Obsidian app running (CLI communicates via IPC)

## ⚠️ Sandbox Mode (Critical)

The `obsidian` CLI requires direct filesystem access — **sandbox mode will block every command**. Always pass `dangerouslyDisableSandbox: true` to the Bash tool when running Obsidian CLI commands.

## Usage

The skill activates automatically when you mention Obsidian or vault operations. Examples:

- "Search my vault for meeting notes"
- "Create a note called Project Alpha"
- "Append to today's daily note: completed review"
- "What tasks are in my vault?"

Claude will use the Obsidian CLI to execute these operations.

## Workflows

Real-world automation examples can be found in [`docs/workflows/`](docs/workflows/).

## Commands Covered

See `plugin/skills/obsidian/references/command-reference.md` for the complete list of 130+ commands.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to report bugs, suggest features, add commands, and submit PRs.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

## License

MIT
