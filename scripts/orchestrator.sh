#!/bin/bash
# orchestrator.sh — routes /obsidian subcommands to handlers

set -e

SUBCOMMAND="${1:-}"
shift || true

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$SUBCOMMAND" in
  ask)
    "$SCRIPT_DIR/obsidian-ask.sh" "$@"
    ;;
  new)
    "$SCRIPT_DIR/obsidian-new.sh" "$@"
    ;;
  append)
    "$SCRIPT_DIR/obsidian-append.sh" "$@"
    ;;
  list)
    "$SCRIPT_DIR/obsidian-list.sh" "$@"
    ;;
  "")
    echo "Error: No subcommand specified."
    echo "Usage: /obsidian <ask|new|append|list> [args]"
    exit 1
    ;;
  *)
    echo "Error: Unknown subcommand '$SUBCOMMAND'."
    echo "Usage: /obsidian <ask|new|append|list> [args]"
    exit 1
    ;;
esac