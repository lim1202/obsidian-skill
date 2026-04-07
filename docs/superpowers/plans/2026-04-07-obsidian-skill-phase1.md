# Obsidian Skill Phase 1 — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Phase 1 MVP of the Obsidian Claude Code Skill with four commands: ask, new, append, list.

**Architecture:** A Claude Code Skill (slash command) backed by shell scripts. The skill entry point (`obsidian.md`) defines the `/obsidian` slash command with subcommands. An orchestrator shell script routes to command-specific scripts that wrap the Obsidian CLI.

**Tech Stack:** Shell scripts (bash), Obsidian CLI (`obsidian`), Claude Code CLI (`claude`)

---

## File Structure

```
obsidian-skill/
├── obsidian.md              # Skill entry point (slash command handler)
├── scripts/
│   ├── orchestrator.sh      # Route subcommands to handlers
│   ├── obsidian-ask.sh       # /obsidian ask implementation
│   ├── obsidian-new.sh       # /obsidian new implementation
│   ├── obsidian-append.sh    # /obsidian append implementation
│   └── obsidian-list.sh      # /obsidian list implementation
└── tests/
    ├── orchestrator.test.sh
    ├── obsidian-ask.test.sh
    ├── obsidian-new.test.sh
    ├── obsidian-append.test.sh
    └── obsidian-list.test.sh
```

**Key path constants:**
- `VAULT_DIR=~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`

---

## Task 1: Project Scaffolding

**Files:**
- Create: `obsidian.md`
- Create: `scripts/`
- Create: `tests/`
- Modify: `.gitignore` (add `scripts/*.log`, `tests/*.tmp`)

- [ ] **Step 1: Create .gitignore**

```bash
cat > /Users/lim/GitHub/obsidian-skill/.gitignore << 'EOF'
*.log
*.tmp
.DS_Store
EOF
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: add gitignore

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 2: Skill Entry Point — `obsidian.md`

**Files:**
- Create: `obsidian.md`

- [ ] **Step 1: Write skill definition**

```markdown
# obsidian

Interact with your Obsidian vault via conversational AI.

## Commands

### ask <question>

Searches your vault and answers questions using relevant notes.

**Usage:** `/obsidian ask <question>`

**Example:** `/obsidian ask what projects am I working on`

### new <title>

Creates a new note with the given title.

**Usage:** `/obsidian new <title>`

**Example:** `/obsidian new Meeting Notes 2024-04-07`

### append <path> <content>

Appends content to a specific note.

**Usage:** `/obsidian append <path> <content>`

**Example:** `/obsidian append Work/project-x.md Added action items from today's meeting`

### list [folder]

Lists notes in a folder (default: root).

**Usage:** `/obsidian list [folder]`

**Example:** `/obsidian list Work`

---

**Notes:**
- Commands operate on the vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes`
- `<path>` is relative to the vault root (e.g., `Work/project-x.md`)
- The ask command uses AI to synthesize answers from your notes
```

- [ ] **Step 2: Commit**

```bash
git add obsidian.md
git commit -m "feat: add obsidian skill entry point

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 3: Orchestrator Script

**Files:**
- Create: `scripts/orchestrator.sh`
- Create: `tests/orchestrator.test.sh`

- [ ] **Step 1: Write orchestrator.sh**

```bash
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
```

- [ ] **Step 2: Make orchestrator executable**

```bash
chmod +x /Users/lim/GitHub/obsidian-skill/scripts/orchestrator.sh
```

- [ ] **Step 3: Write orchestrator tests**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/orchestrator.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORCHESTRATOR="$SCRIPT_DIR/../scripts/orchestrator.sh"

# Test: no subcommand returns error
result="$(bash "$ORCHESTRATOR" 2>&1 || true)"
if ! echo "$result" | grep -q "No subcommand"; then
  echo "FAIL: no subcommand should return error"
  exit 1
fi
echo "PASS: no subcommand returns error"

# Test: unknown subcommand returns error
result="$(bash "$ORCHESTRATOR" unknowncmd 2>&1 || true)"
if ! echo "$result" | grep -q "Unknown subcommand"; then
  echo "FAIL: unknown subcommand should return error"
  exit 1
fi
echo "PASS: unknown subcommand returns error"

# Test: valid subcommand routes correctly (ask --help-like check)
result="$(bash "$ORCHESTRATOR" ask --help 2>&1 || true)"
if ! echo "$result" | grep -qi "error\|search\|vault"; then
  echo "FAIL: ask subcommand should route to obsidian-ask.sh"
  exit 1
fi
echo "PASS: ask routes correctly"

echo "All orchestrator tests passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/orchestrator.test.sh
```

- [ ] **Step 4: Run orchestrator tests**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/orchestrator.test.sh
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/orchestrator.sh tests/orchestrator.test.sh
git commit -m "feat: add orchestrator script with routing

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 4: `/obsidian ask` — obsidian-ask.sh

**Files:**
- Create: `scripts/obsidian-ask.sh`
- Create: `tests/obsidian-ask.test.sh`

**Prerequisites assumed:** `obsidian search` and `claude -p` available

- [ ] **Step 1: Write obsidian-ask.sh**

```bash
#!/bin/bash
# obsidian-ask.sh — /obsidian ask implementation

set -e

VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"

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
fi

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
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/lim/GitHub/obsidian-skill/scripts/obsidian-ask.sh
```

- [ ] **Step 3: Write obsidian-ask tests**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/obsidian-ask.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/obsidian-ask.sh"

# Test: no question returns error
result="$("$SCRIPT" 2>&1 || true)"
if ! echo "$result" | grep -q "No question"; then
  echo "FAIL: no question should return error"
  exit 1
fi
echo "PASS: no question returns error"

# Test: help text shown on --help
result="$("$SCRIPT" --help 2>&1 || true)"
if ! echo "$result" | grep -qi "usage\|question"; then
  echo "FAIL: --help should show usage"
  exit 1
fi
echo "PASS: --help shows usage"

echo "All obsidian-ask tests passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/obsidian-ask.test.sh
```

- [ ] **Step 4: Run tests**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/obsidian-ask.test.sh
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/obsidian-ask.sh tests/obsidian-ask.test.sh
git commit -m "feat: implement /obsidian ask command

Searches vault with obsidian CLI, reads top 5 notes,
and uses claude -p to synthesize an answer with citations.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 5: `/obsidian new` — obsidian-new.sh

**Files:**
- Create: `scripts/obsidian-new.sh`
- Create: `tests/obsidian-new.test.sh`

- [ ] **Step 1: Write obsidian-new.sh**

```bash
#!/bin/bash
# obsidian-new.sh — /obsidian new implementation

set -e

VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"
TEMPLATE_DIR="$VAULT_DIR/Template"

TITLE="$*"

if [ -z "$TITLE" ]; then
  echo "Error: No title provided."
  echo "Usage: /obsidian new <title>"
  exit 1
fi

# Sanitize title: replace whitespace with -, strip special chars
FILENAME="$(echo "$TITLE" | sed 's/[[:space:]]\+/-/g' | sed 's/[^a-zA-Z0-9\-]//g')"

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

# Open the note
obsidian open "$FULL_PATH" 2>/dev/null || true

echo "Created: $FILENAME.md"
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/lim/GitHub/obsidian-skill/scripts/obsidian-new.sh
```

- [ ] **Step 3: Write obsidian-new tests**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/obsidian-new.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/obsidian-new.sh"

# Test: no title returns error
result="$("$SCRIPT" 2>&1 || true)"
if ! echo "$result" | grep -q "No title"; then
  echo "FAIL: no title should return error"
  exit 1
fi
echo "PASS: no title returns error"

# Test: title sanitization (mock VAULT_DIR)
VAULT_DIR_TMP="$(mktemp -d)"
HOME_DIR_TMP="$(mktemp -d)"
HOME="$HOME_DIR_TMP" "$SCRIPT" "My Test Note With Spaces" 2>/dev/null || true
expected_file="$VAULT_DIR_TMP/My-Test-Note-With-Spaces.md"
if [ ! -f "$expected_file" ]; then
  echo "FAIL: spaces should be replaced with dashes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: title sanitization works"

# Test: special chars stripped
HOME="$HOME_DIR_TMP" "$SCRIPT" "Test@Note#123" 2>/dev/null || true
expected_file="$VAULT_DIR_TMP/TestNote123.md"
if [ ! -f "$expected_file" ]; then
  echo "FAIL: special chars should be stripped"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: special chars stripped"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-new tests passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/obsidian-new.test.sh
```

- [ ] **Step 4: Run tests**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/obsidian-new.test.sh
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/obsidian-new.sh tests/obsidian-new.test.sh
git commit -m "feat: implement /obsidian new command

Creates note with sanitized filename, supports Template/ folder
for prepended content, and deduplicates duplicate filenames.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 6: `/obsidian append` — obsidian-append.sh

**Files:**
- Create: `scripts/obsidian-append.sh`
- Create: `tests/obsidian-append.test.sh`

- [ ] **Step 1: Write obsidian-append.sh**

```bash
#!/bin/bash
# obsidian-append.sh — /obsidian append implementation

set -e

VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"

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
if [ ! -f "$FULL_PATH" ]; then
  echo "Error: File '$PATH_ARG' does not exist."
  echo "Hint: Use /obsidian new to create a new note."
  exit 1
fi

# Append content
echo "" >> "$FULL_PATH"
echo "$CONTENT" >> "$FULL_PATH"

echo "Appended to [[$PATH_ARG]]"
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/lim/GitHub/obsidian-skill/scripts/obsidian-append.sh
```

- [ ] **Step 3: Write obsidian-append tests**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/obsidian-append.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/obsidian-append.sh"

VAULT_DIR_TMP="$(mktemp -d)"
HOME_DIR_TMP="$(mktemp -d)"
HOME="$HOME_DIR_TMP"
export HOME

# Setup: create test vault with a note
mkdir -p "$VAULT_DIR_TMP"
echo "# Test Note" > "$VAULT_DIR_TMP/test.md"
VAULT_DIR="$VAULT_DIR_TMP" HOME="$HOME_DIR_TMP" "$SCRIPT" "test.md" "Added content" 2>&1

# Verify content appended
content="$(cat "$VAULT_DIR_TMP/test.md")"
if ! echo "$content" | grep -q "Added content"; then
  echo "FAIL: content should be appended"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: content appended successfully"

# Test: path traversal blocked
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" result="$("$SCRIPT" "../etc/passwd" "hacked" 2>&1 || true)"
if ! echo "$result" | grep -q "Path traversal"; then
  echo "FAIL: path traversal should be blocked"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: path traversal blocked"

# Test: missing file returns error
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" result="$("$SCRIPT" "nonexistent.md" "content" 2>&1 || true)"
if ! echo "$result" | grep -q "does not exist"; then
  echo "FAIL: missing file should return error"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: missing file returns error"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-append tests passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/obsidian-append.test.sh
```

- [ ] **Step 4: Run tests**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/obsidian-append.test.sh
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/obsidian-append.sh tests/obsidian-append.test.sh
git commit -m "feat: implement /obsidian append command

Appends content to existing notes with path traversal protection.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 7: `/obsidian list` — obsidian-list.sh

**Files:**
- Create: `scripts/obsidian-list.sh`
- Create: `tests/obsidian-list.test.sh`

- [ ] **Step 1: Write obsidian-list.sh**

```bash
#!/bin/bash
# obsidian-list.sh — /obsidian list implementation

set -e

VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"

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
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/lim/GitHub/obsidian-skill/scripts/obsidian-list.sh
```

- [ ] **Step 3: Write obsidian-list tests**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/obsidian-list.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/obsidian-list.sh"

VAULT_DIR_TMP="$(mktemp -d)"
HOME_DIR_TMP="$(mktemp -d)"

# Setup: create test vault with notes
echo "# Note1" > "$VAULT_DIR_TMP/note1.md"
echo "# Note2" > "$VAULT_DIR_TMP/note2.md"
mkdir -p "$VAULT_DIR_TMP/Work"
echo "# Work Note" > "$VAULT_DIR_TMP/Work/work-note.md"

VAULT_DIR="$VAULT_DIR_TMP" HOME="$HOME_DIR_TMP" result="$("$SCRIPT" 2>&1)"

if ! echo "$result" | grep -q "note1"; then
  echo "FAIL: should list root notes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: lists root notes"

VAULT_DIR="$VAULT_DIR_TMP" HOME="$HOME_DIR_TMP" result="$("$SCRIPT" Work 2>&1)"
if ! echo "$result" | grep -q "work-note"; then
  echo "FAIL: should list Work folder notes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: lists subfolder notes"

# Test: nonexistent folder returns error
VAULT_DIR="$VAULT_DIR_TMP" HOME="$HOME_DIR_TMP" result="$("$SCRIPT" Nonexistent 2>&1 || true)"
if ! echo "$result" | grep -q "does not exist"; then
  echo "FAIL: nonexistent folder should return error"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: nonexistent folder returns error"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-list tests passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/obsidian-list.test.sh
```

- [ ] **Step 4: Run tests**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/obsidian-list.test.sh
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/obsidian-list.sh tests/obsidian-list.test.sh
git commit -m "feat: implement /obsidian list command

Lists markdown files in vault or specified folder.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 8: Integration Test — Full Skill Smoke Test

**Files:**
- Create: `tests/integration.test.sh`

- [ ] **Step 1: Write integration test**

```bash
cat > /Users/lim/GitHub/obsidian-skill/tests/integration.test.sh << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORCHESTRATOR="$SCRIPT_DIR/../scripts/orchestrator.sh"

VAULT_DIR_TMP="$(mktemp -d)"
HOME_DIR_TMP="$(mktemp -d)"

# Export vault dir override for testing
export HOME="$HOME_DIR_TMP"

# Mock obsidian CLI for testing
mkdir -p "$HOME/bin"
cat > "$HOME/bin/obsidian" << 'SCRIPT'
#!/bin/bash
case "$1" in
  search)
    echo "Test Note (test-note.md)"
    ;;
  open)
    echo "Opened: $2"
    ;;
  append)
    echo "Appended to: $2"
    ;;
esac
SCRIPT
chmod +x "$HOME/bin/obsidian"
export PATH="$HOME/bin:$PATH"

# Test orchestrator routes to all subcommands
for subcmd in ask new append list; do
  echo "Testing /obsidian $subcmd..."
  result="$(ORCHESTRATOR="$ORCHESTRATOR" VAULT_DIR="$VAULT_DIR_TMP" bash "$ORCHESTRATOR" $subcmd 2>&1 || true)"
  if [ -z "$result" ]; then
    echo "FAIL: $subcmd produced no output"
    rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
    exit 1
  fi
  echo "PASS: /obsidian $subcmd routes correctly"
done

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "Integration smoke test passed"
EOF
chmod +x /Users/lim/GitHub/obsidian-skill/tests/integration.test.sh
```

- [ ] **Step 2: Run integration test**

```bash
bash /Users/lim/GitHub/obsidian-skill/tests/integration.test.sh
```
Expected: All routes pass

- [ ] **Step 3: Commit**

```bash
git add tests/integration.test.sh
git commit -m "test: add integration smoke test

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Self-Review Checklist

- [ ] Spec coverage: All 4 Phase 1 commands implemented (ask, new, append, list)
- [ ] Placeholder scan: No TODOs or TBDs in the plan
- [ ] Type consistency: All scripts use consistent VAULT_DIR path and error message format
- [ ] Each task has: test, implementation, passing test, commit
- [ ] Path for all files is absolute and exact
- [ ] All shell scripts have `set -e` for error propagation
- [ ] Security: path traversal checks in append and list
- [ ] Error handling: descriptive errors for missing inputs, missing files

---

**Plan complete.** All 8 tasks ready for execution.
