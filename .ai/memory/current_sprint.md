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

## Notes

- Use `.codex/workflows/` for repeatable execution.
- Use `.ai/context/` as project context.
- Use `.ai/agents/` for role-specific behavior.
- Sprint 0 foundation and governance completed.
- Sprint 1 generated in `docs/project-management/SPRINT_1.md`.
- Authentication technical plan registered in `.ai/plans/2026-05-19-authentication-plan.md`.
- Next pending step: Awaiting next approved task for Authentication.
- Latest stabilization status: PT-BR auth UI and user-safe auth errors completed and validated.
