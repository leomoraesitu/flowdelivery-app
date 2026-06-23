#!/usr/bin/env bash
set -euo pipefail

path=".codex/commands/continue_feature.md"

if [ ! -f "$path" ]; then
  echo "ERROR: Command file not found: $path" >&2
  exit 1
fi

content=$(cat "$path")

echo "$content"
echo ""
echo "$content" | pbcopy
echo "Prompt copied to clipboard!"
echo ""
