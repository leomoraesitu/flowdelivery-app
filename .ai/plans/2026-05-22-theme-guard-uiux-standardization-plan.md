# Theme Guard and UI/UX Standardization Plan

> For agentic workers: execute incrementally, one approved task at a time. Do not implement multiple tasks without explicit approval.

**Goal:** Standardize user-facing UI styling decisions under a strict Theme Guard workflow, preventing visual hardcoded values and preserving design-system consistency across feature presentation layers.

**Architecture:** Keep MVVM + Clean Architecture boundaries intact while enforcing visual governance in presentation code. Theme behavior remains centralized in `lib/app/theme`; features consume semantic theme APIs and tokens only.

**Tech Stack:** Flutter, Dart, Material 3, `flutter_test`, `flutter_riverpod`, existing design tokens and app theme modules.

---

## Current Baseline

- Localization Guard governance is already established and documented.
- Theme Guard governance was recently introduced in project-management and Trello artifacts.
- Remaining risk is operational drift: developers may still introduce visual hardcodeds in feature presentation files without immediate guardrail feedback.

## Out of Scope

- Re-design of branding or visual identity.
- Theme engine rewrite.
- New color system or token taxonomy changes.
- Refactors outside user-facing presentation files unless required by guardrails.

## Planned File Responsibilities

- `test/app/theme/no_hardcoded_visual_values_test.dart` (or equivalent guard test file): detect disallowed visual hardcodeds in presentation files.
- `lib/app/theme/*`: remains the only location for low-level palette/token definitions.
- `lib/features/**/presentation/**`: consume semantic APIs/tokens; never define hardcoded visual primitives when tokens exist.
- `docs/project-management/*`: retain canonical workflow/checklists and Definition of Done alignment.
- `.ai/*`, `.codex/*`, `.agents/*`: keep AI operational scaffolding consistent with Theme Guard + Localization Guard parity.

---

### Task 1: Audit Visual Governance Baseline

**Concept:** Before enforcing, map the current risk surface and prioritize fixes.

**Files:**

- Read: `lib/features/**/presentation/**`
- Read: `lib/app/theme/**`
- Read: existing guard tests under `test/app/**`

**Responsibilities:**

- Identify where visual hardcodeds still appear.
- Classify violations by severity and fix complexity.
- Define a first enforcement scope that is strict but low-noise.

**Validation:**

- Produce an actionable inventory grouped by file and pattern.

**Skills aplicáveis:**

- `flutter-apply-architecture-best-practices`
- `dart-run-static-analysis`

- [x] Step 1: scan presentation files for visual hardcodeds
- [x] Step 2: classify findings (critical/high/medium/low)
- [x] Step 3: approve enforcement scope

#### Task 1 Audit Result (2026-05-22)

Scope scanned:

- `lib/features/**/presentation/**/*.dart` (current repository returns auth presentation files only).

Findings:

- High: direct low-level palette usage outside `lib/app/theme` in `lib/features/auth/presentation/widgets/auth_page_shell.dart` (3 occurrences of `AppLightColors.secondaryText`).
- Medium: direct `Colors.white` usage in `lib/features/auth/presentation/widgets/auth_page_shell.dart` (allowed for now, but should be reviewed for semantic replacement in a later pass).
- Low: no `Color(0x...)` hardcoded occurrences found in presentation files for current scope.

Approved enforcement scope for Task 2/3:

- Enforce as blocking: `AppLightColors`/`AppDarkColors` outside `lib/app/theme`.
- Enforce as blocking: `Color(0x...)` in feature presentation.
- Keep as non-blocking advisory in first cycle: selected `Colors.*` constants until semantic mapping is finalized.

Initial priority slice for normalization (Task 4):

- `lib/features/auth/presentation/widgets/auth_page_shell.dart`.

---

### Task 2: Define Canonical Theme Guard Contract

**Concept:** Teams need one explicit contract for what is allowed and what is forbidden.

**Files:**

- Modify: `docs/project-management/TRELLO_WORKFLOW.md` only if gaps remain
- Modify: `.ai/templates/*.md` only if gaps remain
- Modify: `.codex/workflows/*.md` only if gaps remain

**Responsibilities:**

- Confirm canonical Theme Guard checklist wording.
- Confirm allowed style sources (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- Confirm forbidden patterns (`Color(0x...)` and low-level palette usage outside `lib/app/theme`).

**Validation:**

- Checklist parity across workflow, templates, and command scaffolding.

**Skills aplicáveis:**

- `flutter-apply-architecture-best-practices`

- [x] Step 1: review contract consistency in docs and templates
- [x] Step 2: update only divergent artifacts
- [x] Step 3: verify parity with Localization Guard governance

#### Task 2 Contract Result (2026-05-22)

Review scope:

- Canonical source: `docs/project-management/TRELLO_WORKFLOW.md` and `docs/project-management/trello/config/trello-map.md`.
- Operational scaffolding: `.ai/templates/*.md` and `.codex/commands|workflows` files.

Result:

- Contract is consistent across project-management docs, Trello artifacts, `.codex` workflows/commands, and `.ai` templates.
- Minor wording divergences in `.ai` templates were normalized to match canonical wording exactly.
- Localization Guard and Theme Guard parity is confirmed for UI-related planning and execution flows.

---

### Task 3: Implement/Expand Visual Hardcoded Guard Test

**Concept:** Governance without automated checks regresses quickly.

**Files:**

- Create or modify: `test/app/theme/no_hardcoded_visual_values_test.dart`

**Responsibilities:**

- Detect forbidden visual hardcoded patterns in presentation paths.
- Ignore permitted theme-layer files to avoid false positives.
- Document extension points for future patterns.

**Validation:**

- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart`

**Skills aplicáveis:**

- `dart-add-unit-test`
- `dart-run-static-analysis`

- [x] Step 1: design scanner scope and exclusions
- [x] Step 2: implement failing-first checks for representative patterns
- [x] Step 3: make test pass with approved baseline

#### Task 3 Guard Test Result (2026-05-22)

Implemented file:

- `test/app/theme/no_hardcoded_visual_values_test.dart`

Current enforced patterns:

- `Color(0x...)` hardcoded values in presentation files.
- Direct `AppLightColors.*` usage in presentation files.
- Direct `AppDarkColors.*` usage in presentation files.

Scope and exclusions:

- Scan scope: `lib/features/**/presentation/**/*.dart`.
- Baseline exception (temporary): `AppLightColors.secondaryText` in `lib/features/auth/presentation/widgets/auth_page_shell.dart`.
- Intent: block new regressions now, remove exception during Task 4 normalization.

Validation:

- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart` passed.

---

### Task 4: Normalize Priority UI Surfaces

**Concept:** Replace risky visual patterns with semantic theme usage in prioritized screens.

**Files:**

- Modify (approved subset): `lib/features/**/presentation/**`

**Responsibilities:**

- Replace hardcoded visual values with semantic APIs/tokens.
- Preserve behavior and accessibility.
- Keep changes incremental by screen/feature slice.

**Validation:**

- Focused widget tests per touched feature
- `flutter analyze`

**Skills aplicáveis:**

- `flutter-build-responsive-layout`
- `flutter-add-widget-test`
- `dart-run-static-analysis`

- [x] Step 1: select first priority slice
- [x] Step 2: refactor styling to semantic APIs/tokens
- [x] Step 3: validate UI and tests

#### Task 4 Normalization Result (2026-05-22)

Priority slice normalized:

- `lib/features/auth/presentation/widgets/auth_page_shell.dart`

Applied changes:

- Replaced direct `AppLightColors.secondaryText` usages with semantic `colorScheme.onSurfaceVariant` in auth subtitle, legal text, and reports tab label.
- Removed direct palette dependency import from presentation layer (`app_colors.dart`).
- Removed temporary baseline exception from `test/app/theme/no_hardcoded_visual_values_test.dart` so the guard now runs strictly.

Validation:

- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart` passed.
- `flutter analyze lib/features/auth/presentation/widgets/auth_page_shell.dart` passed with no issues.

---

### Task 5: Reconcile Memory and Operational Artifacts

**Concept:** Process memory must reflect the implemented enforcement state.

**Files:**

- Modify: `.ai/memory/current_feature.md`
- Modify: `.ai/memory/current_sprint.md`
- Modify: `.ai/memory/technical_debt.md` if needed

**Responsibilities:**

- Record what was enforced and where.
- Capture remaining debt and next recommended slices.

**Validation:**

- Memory files mention Theme Guard and guard-test scope accurately.

**Skills aplicáveis:**

- `dart-run-static-analysis`

- [x] Step 1: update current feature state
- [x] Step 2: update sprint focus and risks
- [x] Step 3: log residual debt

#### Task 5 Reconciliation Result (2026-05-22)

Updated memory artifacts:

- `.ai/memory/current_feature.md`
- `.ai/memory/current_sprint.md`
- `.ai/memory/technical_debt.md`

Recorded state:

- Theme Guard visual hardcoded test is strict and green (`test/app/theme/no_hardcoded_visual_values_test.dart`).
- Priority normalization slice completed for auth shell (`lib/features/auth/presentation/widgets/auth_page_shell.dart`).
- Residual debt documented with recommended next slice order: `home` -> `feed` -> `cart`.

#### Post-Task Follow-up Audit (2026-05-22)

- Approved follow-up execution attempted for next slice normalization.
- Current workspace does not contain `lib/features/home`, `lib/features/feed`, or `lib/features/cart` presentation surfaces.
- Effective state: all existing `lib/features/**/presentation/**/*.dart` files are compliant with the current visual guard rules.
- Next trigger: when a new feature presentation slice is added, run incremental normalization + focused validation in the same pattern.

#### Post-Review Corrective Pass (2026-05-22)

Validated fixes applied after rigorous code review:

- Router coupling fix: `lib/app/routes/app_router.dart` now reads `authViewModelProvider` without subscribing for provider rebuilds and keeps redirect refresh via `refreshListenable`.
- Password recovery lifecycle fix: stale recovery feedback is reset safely on forgot-password screen entry and validated through focused widget tests.
- Theme semantic alignment cleanup:
	- Replaced remaining `Colors.white` usage in auth loading indicators and auth shell icon with semantic `colorScheme.onPrimary`.
	- Replaced selected tab `colorScheme.shadow.withAlpha(30)` with semantic container/on-container roles.

Validation results:

- `flutter test test/app/routes/app_router_test.dart test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart test/features/auth/presentation/auth_providers_test.dart test/app/theme/no_hardcoded_visual_values_test.dart` passed.
- `flutter analyze lib/features/auth/presentation/viewmodels/auth_view_model.dart lib/features/auth/presentation/pages/forgot_password_page.dart lib/features/auth/presentation/pages/sign_in_page.dart lib/features/auth/presentation/pages/sign_up_page.dart lib/features/auth/presentation/widgets/auth_page_shell.dart test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart` passed with no issues.

---

## Acceptance Criteria

- Theme Guard contract is explicit, canonical, and aligned across docs/templates/commands.
- Automated visual hardcoded guard test exists and is green.
- Priority UI slices no longer use forbidden visual hardcoded patterns.
- Architecture boundaries remain preserved (theme internals centralized in `lib/app/theme`).
- Memory and workflow artifacts reflect actual validated state.

## Risks

- Overly broad pattern matching may create noisy false positives.
- Aggressive refactors may cause UI regressions if not sliced incrementally.
- Inconsistent token usage can persist if guard exclusions are too permissive.

## Open Questions

- What first feature slice should be prioritized for normalization after auth (home/feed/cart)?
- Should the visual guard include typography-size hardcodeds in phase 1 or defer to phase 2?
- Should guard failures block CI immediately or after one stabilization cycle?
