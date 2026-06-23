#!/usr/bin/env bash
set -euo pipefail

echo ""
echo "=== FLOWDELIVERY AI MEMORY LOOP ==="
echo ""
echo "1 - Morning Start"
echo "2 - Start Feature"
echo "3 - Technical Plan"
echo "4 - Continue Feature"
echo "5 - Review Feature"
echo "6 - Learning Mode"
echo "7 - End Day"
echo ""
read -rp "Choose option: " option

case "$option" in
  1) path=".codex/commands/morning_start.md" ;;
  2) path=".codex/commands/start_feature.md" ;;
  3) path=".codex/commands/technical_plan.md" ;;
  4) path=".codex/commands/continue_feature.md" ;;
  5) path=".codex/commands/review_feature.md" ;;
  6) path=".codex/commands/learning_mode.md" ;;
  7) path=".codex/commands/end_day.md" ;;
  *)
    echo "ERROR: Invalid option." >&2
    exit 1
    ;;
esac

if [ ! -f "$path" ]; then
  echo "ERROR: Command file not found: $path" >&2
  exit 1
fi

content=$(cat "$path")

echo ""
echo "$content"
echo ""
echo "$content" | pbcopy
echo "Prompt copied to clipboard!"
echo ""
