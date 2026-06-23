#!/usr/bin/env bash
set -euo pipefail

content=$(cat ".codex/commands/end_day.md")

latest_path=".ai/prompts/end_day_latest.md"
review_dir=".ai/reviews"
dated_path="${review_dir}/$(date +%Y-%m-%d)-end-day-prompt.md"

mkdir -p ".ai/prompts"
mkdir -p "$review_dir"

echo "$content" > "$latest_path"
echo "$content" > "$dated_path"
echo "$content" | pbcopy

echo "$content"
echo ""
echo "Prompt saved to $latest_path"
echo "Prompt snapshot saved to $dated_path"
echo "Prompt copied to clipboard!"
echo ""
