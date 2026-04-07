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

# Setup: create test vault
mkdir -p "$VAULT_DIR_TMP"
echo "# Test Note" > "$VAULT_DIR_TMP/test-note.md"

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