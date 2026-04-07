#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/obsidian-list.sh"

VAULT_DIR_TMP="$(mktemp -d)"
HOME_DIR_TMP="$(mktemp -d)"

# Setup: create test vault with notes
echo "# Note1" > "$VAULT_DIR_TMP/note1.md"
echo "# Note2" > "$VAULT_DIR_TMP/note2.md"
mkdir -p "$VAULT_DIR_TMP/Work"
echo "# Work Note" > "$VAULT_DIR_TMP/Work/work-note.md"

export VAULT_DIR="$VAULT_DIR_TMP"
export HOME="$HOME_DIR_TMP"
result="$("$SCRIPT" 2>&1)"

if ! echo "$result" | grep -q "note1"; then
  echo "FAIL: should list root notes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: lists root notes"

result="$("$SCRIPT" Work 2>&1)"
if ! echo "$result" | grep -q "work-note"; then
  echo "FAIL: should list Work folder notes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: lists subfolder notes"

# Test: nonexistent folder returns error
result="$("$SCRIPT" Nonexistent 2>&1 || true)"
if ! echo "$result" | grep -q "does not exist"; then
  echo "FAIL: nonexistent folder should return error"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: nonexistent folder returns error"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-list tests passed"