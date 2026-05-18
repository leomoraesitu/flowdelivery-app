$content = Get-Content .codex/commands/technical_plan.md -Raw
$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Prompt copied to clipboard!"
Write-Host ""
