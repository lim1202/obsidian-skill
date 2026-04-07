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