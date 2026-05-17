$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$files = @(
  ".ai/memory/current_sprint.md",
  ".ai/memory/current_feature.md",
  ".ai/memory/technical_debt.md",
  ".ai/memory/known_issues.md",
  ".ai/memory/architecture_notes.md",
  ".codex/guardrails.md",
  ".codex/workflow.md",
  ".codex/workflows/AI_MEMORY_LOOP.md",
  ".ai/context/product_vision.md",
  ".ai/context/architecture.md",
  ".ai/context/mvvm_rules.md",
  ".ai/context/flutter_rules.md",
  ".ai/context/state_management_riverpod.md",
  ".ai/context/supabase_patterns.md",
  ".ai/context/coding_standards.md"
)

$sections = foreach ($file in $files) {
  if (Test-Path $file) {
    @"

---
## $file

$(Get-Content $file -Raw -Encoding utf8)
"@
  }
}

$content = @"
# FlowDelivery Session Bootstrap

Use este contexto para recuperar o estado atual do projeto antes de planejar, implementar, revisar ou explicar qualquer mudanca.

$($sections -join "`n")
"@

$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Session context copied to clipboard!"
Write-Host ""
