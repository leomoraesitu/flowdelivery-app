# Trello Board Mapping

## Boards
- project_management
- product_backlog

## Project Management Lists
- governance
- epics
- roadmap
- documentation
- architecture
- design-system
- ai-codex
- devops-infrastructure
- releases
- metrics
- risks-blockers
- decisions-log
- archive

## Product Backlog Lists
- epics
- roadmap
- backlog
- refinement
- ready
- in-progress
- code-review
- qa
- ready-for-release
- done
- blocked

## Labels
- flutterflow
- performance
- test
- priority-medium
- auth
- architecture
- ai
- priority-high
- fix
- security
- ci-cd
- refactor
- mvvm
- blocked
- design-system
- technical-debt
- release
- qa
- ux
- backend
- frontend
- supabase
- api
- feat
- priority-low
- analytics
- docs
- recruiter-portfolio
- database
- chore

## Guard Checklists

Use these checklists in cards that touch user-facing UI:

### Localization Guard Checklist
- Every new user-facing string has an ARB key
- UI reads strings through `AppLocalizations`
- No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`
- ARB catalog parity guard remains green after copy changes
- New placeholders are declared in template metadata and preserved across translated catalogs
- New placeholders and route placeholders are covered by the guard tests
- Generated localization freshness guard remains green after ARB changes once available

### Theme Guard Checklist
- UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`)
- No `Color(0x...)` hardcoded values in feature presentation code
- No direct `AppLightColors`/`AppDarkColors` usage outside `lib/app/theme`
- No direct `Colors.*` hardcoded usage in feature presentation when equivalent semantic `ColorScheme` roles exist
- Visual hardcoded guard test is updated when new UI patterns are introduced
