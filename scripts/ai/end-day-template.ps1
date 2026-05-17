$date = Get-Date -Format "yyyy-MM-dd"
$path = ".ai/reviews/$date.md"

if (-not (Test-Path ".ai/reviews")) {
  New-Item -ItemType Directory -Force ".ai/reviews" | Out-Null
}

"# Daily Summary - $date" | Out-File $path -Encoding utf8
"" | Out-File $path -Append -Encoding utf8
"## Progress" | Out-File $path -Append -Encoding utf8
"" | Out-File $path -Append -Encoding utf8
"## Pending" | Out-File $path -Append -Encoding utf8
"" | Out-File $path -Append -Encoding utf8
"## Risks" | Out-File $path -Append -Encoding utf8
"" | Out-File $path -Append -Encoding utf8
"## Next Steps" | Out-File $path -Append -Encoding utf8

Get-Content $path
