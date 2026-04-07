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

# Test: valid subcommand routes to obsidian-ask.sh (handler may not exist yet)
result="$(bash "$ORCHESTRATOR" ask --help 2>&1 || true)"
if ! echo "$result" | grep -q "obsidian-ask.sh"; then
  echo "FAIL: ask subcommand should route to obsidian-ask.sh"
  exit 1
fi
echo "PASS: ask routes to obsidian-ask.sh"

echo "All orchestrator tests passed"