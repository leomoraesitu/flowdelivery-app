# Current Sprint

## Sprint

Sprint 1 — Authentication Foundation

## Status

Active.

## Focus

- authentication foundation
- Supabase Auth integration boundaries
- Riverpod dependency wiring
- GoRouter route conventions and auth guard
- MVVM and Clean Architecture validation
- focused tests per implementation slice
- PT-BR localization and auth copy consistency
- documentation and memory reconciliation after auth stabilization
- theme guard enforcement and UI/UX standardization planning

## Current Priorities

- execute `.ai/plans/2026-05-19-authentication-plan.md` incrementally
- execute only the next approved pending task
- keep Supabase outside widgets and ViewModels
- keep route policy at app level
- update documentation and memory only after validated implementation slices
- keep auth i18n centralized in Flutter gen-l10n ARB files and generated `AppLocalizations`
- keep the hardcoded copy guard test green when adding new UI placeholders or features
- keep Theme Guard checklist and visual hardcoded constraints enforced for UI tasks
- keep design-system docs synchronized with implemented typography and locale choices
- execute `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md` incrementally after explicit approval per task

## Notes

- Use `.codex/workflows/` for repeatable execution.
- Use `.ai/context/` as project context.
- Use `.ai/agents/` for role-specific behavior.
- Sprint 0 foundation and governance completed.
- Sprint 1 generated in `docs/project-management/SPRINT_1.md`.
- Authentication technical plan registered in `.ai/plans/2026-05-19-authentication-plan.md`.
- Theme guard technical plan registered in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`.
- Theme Guard status: Task 4 (priority auth slice normalization) and Task 5 (memory reconciliation) completed.
- Visual hardcoded guard test now strict (no baseline exception) and green.
- Post-review corrective pass completed: router coupling and forgot-password lifecycle consistency fixed with focused coverage.
- Next pending step: Awaiting approval for next plan/slice or commit of validated corrections.
