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
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" "$SCRIPT" "My Test Note With Spaces" 2>/dev/null || true
expected_file="$VAULT_DIR_TMP/My-Test-Note-With-Spaces.md"
if [ ! -f "$expected_file" ]; then
  echo "FAIL: spaces should be replaced with dashes"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: title sanitization works"

# Test: special chars stripped
HOME="$HOME_DIR_TMP" VAULT_DIR="$VAULT_DIR_TMP" "$SCRIPT" "Test@Note#123" 2>/dev/null || true
expected_file="$VAULT_DIR_TMP/TestNote123.md"
if [ ! -f "$expected_file" ]; then
  echo "FAIL: special chars should be stripped"
  rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
  exit 1
fi
echo "PASS: special chars stripped"

rm -rf "$VAULT_DIR_TMP" "$HOME_DIR_TMP"
echo "All obsidian-new tests passed"