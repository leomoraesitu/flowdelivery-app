# Auth Docs Sync Debt Reduction Plan

## Objective

Reduce documentation drift between the stabilized authentication implementation and the project documentation that describes app architecture, Supabase usage, and auth capabilities.

## Current Problem

Some broad project docs were written before implementation and mix product roadmap intent with current repository behavior. That can make planned capabilities such as Google OAuth, role-based access, database-backed profiles, and full protected-route coverage look implemented when they are still out of scope.

## Source of Truth

Implementation source of truth:

- `lib/app/bootstrap/supabase_bootstrap.dart`
- `lib/app/config/app_environment.dart`
- `lib/app/routes/app_router.dart`
- `lib/features/auth/**`
- `test/features/auth/**`
- `test/app/routes/app_router_test.dart`

Documentation source of truth:

- `docs/project-management/SPRINT_1.md`
- `docs/design-system/TOKENS.md`
- `.ai/memory/technical_debt.md`

## Scope

- Clarify `docs/PROJECT_BOOTSTRAP.md` so current auth support is separated from planned auth capabilities.
- Keep Supabase documentation aligned with the implemented auth-only integration.
- Update technical debt notes to record the reconciliation and remaining monitoring rule.

## Out of Scope

- Rewriting historical implementation plans.
- Adding new auth behavior.
- Updating Trello state.
- Changing source code or tests.

## Validation

- Search docs for roadmap-only auth terms and confirm they are labeled as planned or out of scope.
- Confirm no implementation claims are added without matching code.
- No Flutter test is required because this is documentation-only.

## Remaining Monitoring Rule

When auth behavior changes, update docs in the same task after focused validation passes. Documentation should describe validated code, not planned behavior.
