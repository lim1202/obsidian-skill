#!/bin/bash
# obsidian-ask.sh — /obsidian ask implementation

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_DIR="$("${SCRIPT_DIR}/obsidian-vault.sh")"

QUESTION="$*"

if [ -z "$QUESTION" ]; then
  echo "Error: No question provided."
  echo "Usage: /obsidian ask <question>"
  exit 1
fi

# Step 1: Search vault for relevant notes
echo "Searching vault for: $QUESTION" >&2

SEARCH_OUTPUT="$(obsidian search "$QUESTION" 2>&1)" || {
  echo "Error: obsidian search failed. Is the Obsidian CLI installed?" >&2
  exit 1
}

# Step 2: Parse search results to get note paths
# obsidian search outputs format: "Note Title (path/to/note.md)"
NOTE_PATHS="$(echo "$SEARCH_OUTPUT" | grep -oE '[^()]+\.md' | head -5)" || {
  echo "I couldn't find anything in your vault matching that query." >&2
  exit 0
}

if [ -z "$NOTE_PATHS" ]; then
  echo "I couldn't find anything in your vault matching that query." >&2
  exit 0
fi

# Step 3: Read top 5 matching notes
NOTE_CONTENTS=""
for path in $NOTE_PATHS; do
  full_path="$VAULT_DIR/$path"
  if [ -f "$full_path" ]; then
    title="$(basename "$path" .md)"
    content="$(cat "$full_path")"
    NOTE_CONTENTS="${NOTE_CONTENTS}\n\n=== ${title} ===\n${content}"
  fi
done

# Step 4: Construct prompt for Claude
PROMPT="You are answering a question about notes in an Obsidian vault.
Based on the following notes, answer the user's question.

Question: $QUESTION

${NOTE_CONTENTS}

Provide a clear answer with bullet points of key insights. Cite sources as [[Note Title]]."
export CLAUDE_NO_AUTO_COMMIT=true

# Step 5: Execute Claude with prompt
ANSWER="$(claude -p --model opus-4.6 "$PROMPT" 2>&1)" || {
  echo "Error: Claude API failed. Please retry." >&2
  exit 1
}

echo "$ANSWER"