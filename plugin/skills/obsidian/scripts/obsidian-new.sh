#!/bin/bash
# obsidian-new.sh — /obsidian new implementation

set -e

VAULT_DIR="${VAULT_DIR:-$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes}"
TEMPLATE_DIR="$VAULT_DIR/Template"

TITLE="$*"

if [ -z "$TITLE" ]; then
  echo "Error: No title provided."
  echo "Usage: /obsidian new <title>"
  exit 1
fi

# Sanitize title: replace whitespace with -, strip special chars
FILENAME="$(echo "$TITLE" | sed -E 's/[[:space:]]+/-/g' | sed 's/[^a-zA-Z0-9_-]//g')"

# Deduplication: if file exists, append -1, -2, etc.
BASENAME="$FILENAME"
COUNTER=1
while [ -f "$VAULT_DIR/${FILENAME}.md" ]; do
  FILENAME="${BASENAME}-${COUNTER}"
  COUNTER=$((COUNTER + 1))
done

FULL_PATH="$VAULT_DIR/${FILENAME}.md"

# Create note
{
  echo "# $TITLE"
  echo ""

  # Prepend template if exists
  if [ -f "$TEMPLATE_DIR/template.md" ]; then
    cat "$TEMPLATE_DIR/template.md"
    echo ""
  fi
} > "$FULL_PATH"

# Open the note (non-blocking)
obsidian open "$FULL_PATH" 2>/dev/null &

echo "Created: $FILENAME.md"