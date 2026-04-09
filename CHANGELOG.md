# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-04-07

### Breaking Changes

- **Pure knowledge-type architecture**: All shell scripts have been removed. The skill now relies entirely on the official Obsidian CLI (v1.12+) instead of custom scripts. If you were using the old `ask`, `new`, `append`, or `list` commands, please use the equivalent CLI commands documented in `plugin/skills/obsidian/SKILL.md`.
- Vault auto-detection and `OBSIDIAN_VAULT_DIR` environment variable support removed in favor of native CLI vault handling.

### Features

- **130+ Obsidian CLI commands** documented across 20 categories (Files, Daily Notes, Search, Properties, Tags, Tasks, Links, Bookmarks, Templates, Plugins, Sync, Themes, CSS Snippets, Commands/Hotkeys, Obsidian Bases, History, Workspace/Tabs, Diff, Developer, Vault/System)
- Complete command reference at `plugin/skills/obsidian/references/command-reference.md`
- New agent workflows for vault Q&A, note creation with metadata, and daily note automation
- **`dangerouslyDisableSandbox: true`** requirement prominently documented in SKILL.md to prevent common sandbox blocking issues

### Bug Fixes

- Skills path corrected to `plugin/skills/obsidian` in marketplace.json
- Obsidian vault path fallback behavior improved

### Documentation

- SKILL.md rewritten as pure knowledge-type skill
- Sandbox mode warning added to Tips and Troubleshooting sections
- README updated for v2 knowledge-type architecture

## [1.x.x] - Earlier Versions

See git history for details on the v1 script-based architecture.
