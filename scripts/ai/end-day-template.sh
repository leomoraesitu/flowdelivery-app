#!/usr/bin/env bash
set -euo pipefail

date_str=$(date +%Y-%m-%d)
path=".ai/reviews/${date_str}-end-day-prompt.md"

mkdir -p ".ai/reviews"

cat > "$path" <<EOF
# End Day Prompt - ${date_str}

## Progress

## Pending

## Risks

## Next Steps
EOF

cat "$path"
