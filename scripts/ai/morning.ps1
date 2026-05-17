$content = Get-Content .codex/commands/morning_start.md -Raw
$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Prompt copied to clipboard!"
Write-Host ""
