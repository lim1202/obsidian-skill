#!/bin/bash
# obsidian-vault.sh — Detect or configure Obsidian vault path

set -e

CONFIG_DIR="${HOME}/.obsidian-skill"
CONFIG_FILE="${CONFIG_DIR}/config"

# 1. Check environment variable
if [ -n "${OBSIDIAN_VAULT_DIR}" ]; then
  echo "${OBSIDIAN_VAULT_DIR}"
  exit 0
fi

# 2. Check saved config
if [ -f "${CONFIG_FILE}" ]; then
  cat "${CONFIG_FILE}"
  exit 0
fi

# 3. Try to detect common vault locations
COMMON_PATHS=(
  "${HOME}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"
  "${HOME}/Obsidian"
  "${HOME}/obsidian"
  "${HOME}/Documents/Obsidian"
)

for path in "${COMMON_PATHS[@]}"; do
  if [ -d "$path" ]; then
    echo "$path"
    exit 0
  fi
done

# 4. No vault found — prompt user
echo "No Obsidian vault configured." >&2
echo "Please set your vault path:" >&2
read -r VAULT_PATH

if [ -z "$VAULT_PATH" ]; then
  echo "Error: No vault path provided" >&2
  exit 1
fi

# 5. Save to config
mkdir -p "${CONFIG_DIR}"
echo "$VAULT_PATH" > "${CONFIG_FILE}"

echo "$VAULT_PATH"
