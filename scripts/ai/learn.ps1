$content = Get-Content .codex/commands/learning_mode.md -Raw
$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Prompt copied to clipboard!"
Write-Host ""
