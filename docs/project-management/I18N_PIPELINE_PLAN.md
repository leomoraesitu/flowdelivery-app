# FlowDelivery — I18n Pipeline Plan

## Objective

Evolve FlowDelivery localization from static PT-BR/EN catalogs into a scalable, repeatable, and validated i18n pipeline before new product features expand the UI surface.

## Current State

FlowDelivery already has a working Flutter gen-l10n setup:

- `l10n.yaml` defines `lib/l10n` as the ARB source directory.
- `app_pt_BR.arb` is the template ARB file.
- `app_pt.arb` and `app_en.arb` provide additional locale catalogs.
- Generated access flows through `lib/l10n/generated/app_localizations.dart`.
- UI copy must be consumed through `AppLocalizations`.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart` blocks hardcoded user-facing copy in presentation and route files.
- `test/app/l10n/arb_catalog_parity_test.dart` validates locale declarations, key parity, template descriptions, and orphan metadata.

## Completed Phase 1 — ARB Catalog Parity Guard

Phase 1 has been completed and validated.

Implemented guard:

- validates that `app_pt_BR.arb`, `app_pt.arb`, and `app_en.arb` expose the same string keys;
- validates that every ARB file declares the expected `@@locale`;
- validates that every template string key in `app_pt_BR.arb` has `@key.description` metadata;
- validates that metadata entries are not orphaned;
- keeps user-facing copy centralized in ARB catalogs before UI consumption.

Validation command:

```bash
flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart
```

## Problem

The current setup prevents hardcoded UI copy and catalog key drift, but future feature growth can still introduce operational issues:

- generated localization files can become stale after ARB edits;
- dynamic strings can introduce placeholders without metadata;
- translations can accidentally drop or rename placeholders;
- new feature teams may use inconsistent key naming;
- localization validation can be skipped during UI delivery if it is not part of the Definition of Done.

## Phase 2 Scope — Scalable Local Pipeline

Phase 2 should remain local-only, automated, and lightweight.

The goal is not to add a translation platform yet. The goal is to make ARB changes safe, reviewable, and repeatable as the app gains new product features.

### In Scope

- document the required workflow for adding user-facing strings;
- define ARB key naming conventions by feature;
- add generated localization freshness validation;
- harden placeholder validation in the ARB parity guard;
- align the Definition of Done with the complete i18n guard set.

### Out of Scope

- adding new locales;
- rewriting existing auth copy;
- changing tone of voice;
- integrating external translation platforms;
- changing Flutter gen-l10n output paths;
- updating real Trello cards unless explicitly requested.

## String Addition Workflow

Every new user-facing string must follow this flow:

1. Add the template value to `lib/l10n/app_pt_BR.arb`.
2. Add `@key.description` metadata in `lib/l10n/app_pt_BR.arb`.
3. Add matching translated values to `lib/l10n/app_pt.arb` and `lib/l10n/app_en.arb`.
4. Run Flutter localization generation.
5. Consume the generated getter or method through `AppLocalizations`.
6. Run the focused i18n validation suite.

Required validation:

```bash
flutter gen-l10n
flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart
```

After the generated freshness guard is implemented, include:

```bash
flutter test test/app/l10n/generated_localizations_freshness_test.dart
```

## Key Naming Convention

Use feature-prefixed camelCase keys.

Recommended pattern:

```text
<feature><ScreenOrFlow><ElementOrState>
```

Examples:

- `authSignInTitle`
- `authForgotPasswordSuccess`
- `restaurantFeedEmptyTitle`
- `restaurantFeedRetryButton`
- `cartCheckoutButton`
- `orderTrackingStatusPreparing`

Rules:

- Keep keys stable after they are consumed in UI.
- Prefer semantic names over visual names.
- Do not encode layout details in keys.
- Use the feature prefix even when the string seems generic.
- Move truly reusable copy into a shared prefix only after repeated use is proven.

## Placeholder Rules

Use placeholders when copy includes runtime values.

Template example:

```json
{
  "cartItemQuantity": "{quantity} items",
  "@cartItemQuantity": {
    "description": "Cart item count label.",
    "placeholders": {
      "quantity": {
        "type": "int",
        "example": "3"
      }
    }
  }
}
```

Required rules:

- Every placeholder used in the template string must be declared in metadata.
- Every metadata placeholder must be used by the template string.
- Translated catalogs must preserve the same placeholder names.
- Use plural syntax for count-sensitive messages instead of manual string branching in UI.

## Proposed Implementation Plan

### Task 1: Document Scalable String Workflow

Files:

- Modify: `docs/project-management/I18N_PIPELINE_PLAN.md`
- Modify: `docs/project-management/DEFINITION_OF_DONE.md`

Responsibilities:

- Record Phase 1 as completed.
- Define the string addition workflow.
- Define key naming conventions.
- Add i18n pipeline checks to Definition of Done.

Validation:

```bash
flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart
```

### Task 2: Add Generated Localization Freshness Guard

Files:

- Create: `test/app/l10n/generated_localizations_freshness_test.dart`

Responsibilities:

- Read string keys from `lib/l10n/app_pt_BR.arb`.
- Read generated localization output under `lib/l10n/generated`.
- Fail clearly when a template key does not have a generated getter or method.

Validation:

```bash
flutter gen-l10n
flutter test test/app/l10n/generated_localizations_freshness_test.dart
```

### Task 3: Harden Placeholder Validation

Files:

- Modify: `test/app/l10n/arb_catalog_parity_test.dart`

Responsibilities:

- Validate placeholder metadata in the template catalog.
- Validate translated placeholder parity against the template.
- Report failures with file names and key names.

Validation:

```bash
flutter test test/app/l10n/arb_catalog_parity_test.dart
```

### Task 4: Reconcile Workflow and Memory

Files:

- Modify: `.codex/workflows/AI_MEMORY_LOOP.md` if the workflow lacks the new i18n validation reminder.
- Modify: `.ai/memory/current_feature.md`
- Modify: `.ai/memory/current_sprint.md`
- Modify: `.ai/memory/technical_debt.md`

Responsibilities:

- Record that i18n moved from static catalog parity to scalable pipeline guardrails.
- Keep future UI work tied to hardcoded-copy, ARB parity, placeholder, and generated freshness validation.
- Reduce the related technical debt only after the implementation guards are green.

Validation:

```bash
flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart
```

## Acceptance Criteria

- Phase 1 is documented as completed.
- Future UI copy has a documented addition workflow.
- ARB key naming conventions are explicit.
- Definition of Done requires Localization Guard validation for UI copy changes.
- Generated localization freshness has a planned guard.
- Placeholder parity has a planned guard.
- No user-facing copy is changed as part of documentation work.

## Risks

- Generated freshness validation can become brittle if Flutter changes generated file structure.
- Placeholder parsing can become noisy if it attempts to fully parse ICU syntax manually.
- Updating too many workflow artifacts in one task can violate the 3-file guardrail; execution must remain sliced.
- Treating documentation as implementation evidence can create drift; only validated code/tests should reduce technical debt.

## Recommended Trello Card

Create or update one backlog card:

```text
[DEBT] Evolve i18n pipeline guardrails
```

Recommended checklist:

- Document scalable string workflow.
- Add generated localization freshness guard.
- Harden ARB placeholder validation.
- Update Definition of Done.
- Reconcile memory and technical debt after validation.
