#!/bin/bash
# obsidian-list.sh — /obsidian list implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_DIR="$("${SCRIPT_DIR}/obsidian-vault.sh")"

FOLDER="$1"

if [ -z "$FOLDER" ]; then
  LIST_DIR="$VAULT_DIR"
else
  LIST_DIR="$VAULT_DIR/$FOLDER"
fi

# Security: prevent path traversal
if [[ "$LIST_DIR" == *"$VAULT_DIR/../"* ]]; then
  echo "Error: Path traversal not allowed."
  exit 1
fi

if [ ! -d "$LIST_DIR" ]; then
  echo "Error: Folder '$FOLDER' does not exist."
  exit 1
fi

# List markdown files
echo "## Notes in $FOLDER"
echo ""
cd "$LIST_DIR"
for file in *.md; do
  if [ -f "$file" ]; then
    title="$(basename "$file" .md)"
    echo "- [[$title]]"
  fi
done