Write-Host ""
Write-Host "=== FLOWDELIVERY AI MEMORY LOOP ==="
Write-Host ""

Write-Host "1 - Morning Start"
Write-Host "2 - Start Feature"
Write-Host "3 - Technical Plan"
Write-Host "4 - Continue Feature"
Write-Host "5 - Review Feature"
Write-Host "6 - Learning Mode"
Write-Host "7 - End Day"

$option = Read-Host "Choose option"

$path = $null

switch ($option) {
  "1" {
    $path = ".codex/commands/morning_start.md"
  }
  "2" {
    $path = ".codex/commands/start_feature.md"
  }
  "3" {
    $path = ".codex/commands/technical_plan.md"
  }
  "4" {
    $path = ".codex/commands/continue_feature.md"
  }
  "5" {
    $path = ".codex/commands/review_feature.md"
  }
  "6" {
    $path = ".codex/commands/learning_mode.md"
  }
  "7" {
    $path = ".codex/commands/end_day.md"
  }
}

if ($null -ne $path) {
  $content = Get-Content $path -Raw
  $content | Set-Clipboard

  Write-Host ""
  Write-Host $content
  Write-Host ""
  Write-Host "Prompt copied to clipboard!"
  Write-Host ""
}
