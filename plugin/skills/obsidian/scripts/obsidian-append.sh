#!/bin/bash
# obsidian-append.sh — /obsidian append implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_DIR="$("${SCRIPT_DIR}/obsidian-vault.sh")"

# Parse path and content (separated by first space after path)
if [ -z "$1" ]; then
  echo "Error: No path provided."
  echo "Usage: /obsidian append <path> <content>"
  exit 1
fi

PATH_ARG="$1"
shift

CONTENT="$*"

if [ -z "$PATH_ARG" ] || [ -z "$CONTENT" ]; then
  echo "Error: Both path and content are required."
  echo "Usage: /obsidian append <path> <content>"
  exit 1
fi

# Security: prevent path traversal
if [[ "$PATH_ARG" == *"../"* ]]; then
  echo "Error: Path traversal not allowed."
  exit 1
fi

FULL_PATH="$VAULT_DIR/$PATH_ARG"

# Check file exists
if [ \! -f "$FULL_PATH" ]; then
  echo "Error: File '$PATH_ARG' does not exist."
  echo "Hint: Use /obsidian new to create a new note."
  exit 1
fi

# Append content
echo "" >> "$FULL_PATH"
echo "$CONTENT" >> "$FULL_PATH"

echo "Appended to [[$PATH_ARG]]"
