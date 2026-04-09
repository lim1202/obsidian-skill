# Version Compatibility

This document explains Obsidian version requirements and upgrade paths.

## Obsidian CLI Requirement

The Obsidian CLI was released in **February 2026** with **Obsidian Desktop v1.12.0**. This skill requires:

- **Obsidian Desktop v1.12.0 or later**
- **CLI enabled** in Settings → Command line interface → Toggle ON

Without these, the `obsidian` CLI binary will not be available in your PATH.

## Upgrading from Older Obsidian

### How to Check Your Version

```bash
obsidian --version
```

Or open Obsidian → Settings → About.

### If You Have an Older Version

1. Download the latest Obsidian from [obsidian.md](https://obsidian.md)
2. Install or upgrade — your vault data is unaffected
3. Enable CLI: Settings → Command line interface → Toggle ON
4. Restart Obsidian (required for CLI to register in PATH)

Your existing vaults and plugins are fully compatible with the new version.

## Platform-Specific Notes

### macOS

- The `obsidian` binary is installed to `/usr/local/bin` or `~/.local/bin`
- If not found after enabling CLI, restart your terminal session
- Apple Silicon (M1/M2/M3): ensure Rosetta 2 is installed if running Intel-era Obsidian

### Linux

- Binary location varies by distribution; check with `which obsidian`
- If not in PATH after enabling CLI, add Obsidian's install directory to `$PATH`

### Windows

- Use PowerShell or Command Prompt, not Git Bash, for best CLI compatibility
- If Git Bash fails with path issues, create a wrapper as described in the [Troubleshooting](../plugin/skills/obsidian/SKILL.md#troubleshooting) section

## Obsidian Mobile

The Obsidian CLI is **desktop-only**. This skill cannot be used with Obsidian on mobile devices. All operations require:

- Obsidian Desktop app running (or accessible via IPC)
- A local or cloud-synced vault that the desktop app can open

## Obsidian Sync & Vaults

If your vault is synced via Obsidian Sync, iCloud, Dropbox, etc.:

- The CLI operates on the **local vault folder** that Obsidian has open
- Ensure Obsidian opens the correct vault before using CLI commands
- If you use multiple vaults, pass the vault name as the first argument:

```bash
obsidian "My Vault" read path="note.md"
```
