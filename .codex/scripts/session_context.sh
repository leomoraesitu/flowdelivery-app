#!/usr/bin/env bash
set -euo pipefail

files=(
  ".ai/memory/current_sprint.md"
  ".ai/memory/current_feature.md"
  ".ai/memory/technical_debt.md"
  ".ai/memory/known_issues.md"
  ".ai/memory/architecture_notes.md"
  ".ai/prompts/end_day_latest.md"
  ".codex/guardrails.md"
  ".codex/workflow.md"
  ".codex/workflows/AI_MEMORY_LOOP.md"
  ".ai/context/product_vision.md"
  ".ai/context/architecture.md"
  ".ai/context/mvvm_rules.md"
  ".ai/context/flutter_rules.md"
  ".ai/context/state_management_riverpod.md"
  ".ai/context/supabase_patterns.md"
  ".ai/context/coding_standards.md"
)

sections=""
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    sections+="$(printf '\n---\n## %s\n\n%s\n' "$file" "$(cat "$file")")"
  fi
done

content="# FlowDelivery Session Bootstrap

Use este contexto para recuperar o estado atual do projeto antes de planejar, implementar, revisar ou explicar qualquer mudanca.
${sections}"

echo "$content"
echo ""
echo "$content" | pbcopy
echo "Session context copied to clipboard!"
echo ""
