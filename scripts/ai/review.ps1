$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$path = ".codex/commands/review_feature.md"

if (-not (Test-Path $path)) {
	Write-Error "Command file not found: $path"
	exit 1
}

$content = Get-Content $path -Raw -Encoding utf8
$content | Set-Clipboard

Write-Host $content
Write-Host ""
Write-Host "Prompt copied to clipboard!"
Write-Host ""
