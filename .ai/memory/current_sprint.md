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
- scalable i18n pipeline guardrails for future UI feature growth
- password recovery completion planning

## Current Priorities

- execute `.ai/plans/2026-05-19-authentication-plan.md` incrementally
- execute only the next approved pending task
- keep Supabase outside widgets and ViewModels
- keep route policy at app level
- update documentation and memory only after validated implementation slices
- keep auth i18n centralized in Flutter gen-l10n ARB files and generated `AppLocalizations`
- keep the hardcoded copy guard test green when adding new UI placeholders or features
- keep ARB catalog parity and generated localization freshness guards green after ARB changes
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
- I18n pipeline guardrails now include hardcoded-copy, ARB catalog parity, placeholder parity, and generated localization freshness validation.
- Password recovery completion is now the selected next feature planning slice: reset deep-link/session handling, reset-password route, new-password UI, Supabase password update, focused tests, and Supabase redirect manual QA notes.
- Password recovery completion automated slice implemented: reset-password route, new-password UI, ViewModel reset state, Supabase password update through datasource, ARB copy, and focused tests.
- Next approved slice decision: continue governance hardening with `.ai/plans/2026-05-26-trello-sync-debt-reduction-plan.md` before starting the next product feature slice.
- Recovery deliverability execution remains pending external QA inbox/provider availability.
- Auth hardening post-review implementation tasks completed (`.ai/plans/2026-05-26-auth-hardening-post-review-plan.md` Tasks 1-4) with focused test validation.
- Phased migration strategy from legacy provider usage to non-legacy Riverpod pattern documented with gates and rollback criteria (Task 5).
- Auth hardening consolidated focused suite executed and green (31 tests across auth ViewModel/pages/recovery redirect/router).
