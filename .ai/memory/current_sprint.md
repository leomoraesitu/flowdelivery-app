# Current Sprint

## Sprint

Sprint 3 — Home Remote Feed Foundation

## Status

Planned / Approved.

Sprint 3 starts from the validated static Home baseline and is limited to the first authenticated remote-feed read path.

## Focus

- Supabase-backed read-only Home feed foundation
- explicit grants and RLS for new Home feed tables
- DTO, datasource, repository, and async Riverpod provider wiring
- preserved `/home` route contract and existing Home composition
- localized loading/empty/error states only if the async flow requires them
- Localization Guard and Theme Guard enforcement for new async UI states

## Current Priorities

- preserve the validated auth foundation and Sprint 2 Home baseline as the current baseline
- execute only the next approved task from `.ai/plans/2026-06-01-home-remote-feed-plan.md`
- keep profile/address persistence out of this Home slice
- keep search, filtering, detail navigation, destination tabs, Storage media, and Realtime deferred until separate approved slices
- keep Trello documentation, workflow artifacts, and real-card evidence aligned when Trello-governed work touches cards
- validate real Trello checklist parity with `trello_get_card_checklists` before using cards as delivery evidence
- keep Supabase outside widgets and ViewModels
- keep route policy at app level
- update documentation and memory only after validated implementation slices
- keep auth i18n centralized in Flutter gen-l10n ARB files and generated `AppLocalizations`
- keep the hardcoded copy guard test green when adding new UI placeholders or features
- keep ARB catalog parity and generated localization freshness guards green after ARB changes
- keep Theme Guard checklist and visual hardcoded constraints enforced for UI tasks
- keep design-system docs synchronized with implemented typography and locale choices

## Notes

- Sprint 2 (`docs/project-management/SPRINT_2.md`) is closed as the validated static Home baseline.
- Sprint 3 generated in `docs/project-management/SPRINT_3.md`.
- Home remote technical plan registered in `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
- The next Home slice introduces the minimal remote read path only; delivery-address persistence remains local/deferred.
- Active branch: `feat/home`.
- The previous real Trello story remains closed with validated implementation evidence: `https://trello.com/c/X3jAdpd2`.
- The new real Trello story is staged in `✅ Ready`: `https://trello.com/c/bzxIa3wx`.
- Use `.codex/workflows/` for repeatable execution.
- Use `.ai/context/` as project context.
- Use `.ai/agents/` for role-specific behavior.
- Sprint 0 foundation and governance completed.
- Sprint 1 generated in `docs/project-management/SPRINT_1.md` and is now closed.
- Authentication technical plan registered in `.ai/plans/2026-05-19-authentication-plan.md`.
- Theme guard technical plan registered in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`.
- Theme Guard status: Task 4 (priority auth slice normalization) and Task 5 (memory reconciliation) completed.
- Visual hardcoded guard test now strict (no baseline exception) and green.
- Post-review corrective pass completed: router coupling and forgot-password lifecycle consistency fixed with focused coverage.
- I18n pipeline guardrails now include hardcoded-copy, ARB catalog parity, placeholder parity, and generated localization freshness validation.
- Historical Sprint 1 password-recovery planning slice covered reset deep-link/session handling, reset-password route, new-password UI, Supabase password update, focused tests, and Supabase redirect manual QA notes.
- Password recovery completion automated slice implemented: reset-password route, new-password UI, ViewModel reset state, Supabase password update through datasource, ARB copy, and focused tests.
- Sprint 1 is closed; Trello sync debt reduction is now `Reduced / Monitoring`, so the next implementation requires an explicitly selected and approved product or governance slice.
- Recovery deliverability execution remains pending external QA inbox/provider availability.
- Auth hardening post-review implementation tasks completed (`.ai/plans/2026-05-26-auth-hardening-post-review-plan.md` Tasks 1-4) with focused test validation.
- Phased migration strategy from legacy provider usage to non-legacy Riverpod pattern documented with gates and rollback criteria (Task 5).
- Auth hardening consolidated focused suite executed and green (31 tests across auth ViewModel/pages/recovery redirect/router).
