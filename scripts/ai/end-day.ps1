$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$content = Get-Content .codex/commands/end_day.md -Raw -Encoding utf8

$latestPath = ".ai/prompts/end_day_latest.md"
$reviewDirectory = ".ai/reviews"
$datedPath = Join-Path $reviewDirectory "$(Get-Date -Format 'yyyy-MM-dd')-end-day-prompt.md"

New-Item -ItemType Directory -Force -Path ".ai/prompts" | Out-Null
New-Item -ItemType Directory -Force -Path $reviewDirectory | Out-Null

$content | Set-Content -Path $latestPath -Encoding utf8
$content | Set-Content -Path $datedPath -Encoding utf8
$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Prompt saved to $latestPath"
Write-Host "Prompt snapshot saved to $datedPath"
Write-Host "Prompt copied to clipboard!"
Write-Host ""
