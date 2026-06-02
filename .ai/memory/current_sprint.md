# Current Sprint

## Sprint

Sprint 4 — Home Discovery Interactions

## Status

Completed.

Sprint 4 starts from the validated remote-feed baseline and is limited to interactive search/category discovery on the authenticated Home feed.

## Focus

- interactive search and category discovery on top of the validated remote Home feed
- derived filtering state owned in Riverpod rather than widgets
- preserved `/home` route contract and existing remote datasource/repository boundaries
- localized discovery empty-results feedback only if interaction UX requires it
- Localization Guard and Theme Guard enforcement for new interaction states

## Current Priorities

- preserve the validated auth foundation and Sprint 2 Home baseline as the current baseline
- treat Sprint 4 as the active approved Home slice and execute only one approved task at a time
- keep profile/address persistence out of this Home slice
- keep restaurant details, destination tabs, ranking, pagination, Storage media, and Realtime deferred until separate approved slices
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
- Sprint 4 generated in `docs/project-management/SPRINT_4.md`.
- Home remote technical plan registered in `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
- Home discovery technical plan registered in `.ai/plans/2026-06-01-home-discovery-interactions-plan.md`.
- The next Home slice introduces interactive search/category discovery only; delivery-address persistence remains local/deferred.
- Active branch: `feat/home`.
- The previous real Trello story remains closed with validated implementation evidence: `https://trello.com/c/X3jAdpd2`.
- The Sprint 3 real Trello story is closed with validated implementation evidence: `https://trello.com/c/bzxIa3wx`.
- Sprint 3 validation includes focused datasource/repository/provider/widget tests, localization/theme guards, router regression coverage, and Trello checklist parity validation.
- Sprint 4 real Trello story is active with Scope, Acceptance Criteria, Dependencies, Validation, Localization Guard, and Theme Guard checklists: `https://trello.com/c/5EUe5qOp`.
- Sprint 4 Tasks 1-4 are validated. Task 4 added localized discovery no-match feedback and a clear-filters action that resets Riverpod discovery state plus the visible search field.
- Sprint 4 Trello parity after Task 4 is intentionally partial: Scope `5/6`, Validation `7/8`, Localization Guard `7/7`, Theme Guard `5/5`, Acceptance Criteria `5/8`, and Dependencies `6/6`. Global completion items remain open for Tasks 5-6.
- Sprint 4 Task 5 is validated: provider reset regression plus combined category/search no-match widget recovery are covered, focused Home suites passed with 22 tests, and the consolidated router/guard matrix passed with 41 tests.
- Sprint 4 Task 6 is complete: docs, plan, memory, technical-debt monitoring, and the real Trello story were reconciled after validation.
- Sprint 4 final real Trello parity is complete for `https://trello.com/c/5EUe5qOp`: Scope `6/6`, Validation `8/8`, Localization Guard `7/7`, Theme Guard `5/5`, Acceptance Criteria `8/8`, and Dependencies `6/6`.
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
