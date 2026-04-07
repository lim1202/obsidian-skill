#\!/bin/bash
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
if \! echo "$content" | grep -q "Added content"; then
  echo "FAIL: content should be appended"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: content appended successfully"

# Test: path traversal blocked
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" result="$("$SCRIPT" "../etc/passwd" "hacked" 2>&1 || true)"
if \! echo "$result" | grep -q "Path traversal"; then
  echo "FAIL: path traversal should be blocked"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: path traversal blocked"

# Test: missing file returns error
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" result="$("$SCRIPT" "nonexistent.md" "content" 2>&1 || true)"
if \! echo "$result" | grep -q "does not exist"; then
  echo "FAIL: missing file should return error"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: missing file returns error"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-append tests passed"
