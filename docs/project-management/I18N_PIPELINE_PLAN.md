# FlowDelivery — I18n Pipeline Plan

## Objective

Evolve the current static PT-BR/EN localization catalog into a small, scalable, and validated localization pipeline before new product features expand the UI surface.

## Current State

FlowDelivery already has a working Flutter gen-l10n setup:

- `l10n.yaml` defines `lib/l10n` as the ARB source directory.
- `app_pt_BR.arb` is the template ARB file.
- `app_pt.arb` and `app_en.arb` provide additional locale catalogs.
- Generated access flows through `lib/l10n/generated/app_localizations.dart`.
- UI copy must be consumed through `AppLocalizations`.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart` blocks hardcoded user-facing copy in presentation and route files.

## Problem

The current setup protects UI code from hardcoded copy, but it does not yet validate ARB catalog health. As new features add more strings, the project can drift through:

- missing keys in one locale;
- metadata entries without matching string keys;
- string keys without template descriptions;
- incorrect `@@locale` declarations;
- generated localization files becoming stale after ARB edits.

## Recommended Scope

Phase 1 should stay local-only and automated.

Create a focused ARB parity guard that validates:

- all string keys exist in `app_pt_BR.arb`, `app_pt.arb`, and `app_en.arb`;
- every string key in the template catalog has matching `@key.description` metadata;
- metadata keys do not exist without their base string key;
- each ARB file declares the expected `@@locale`;
- the generated localization output remains compatible with the catalogs.

Out of scope for Phase 1:

- rewriting auth copy;
- changing tone of voice;
- adding new locales;
- integrating external translation platforms;
- updating real Trello cards.

## Proposed Implementation Plan

### Task 1: Add ARB Catalog Parity Test

Files:

- Create: `test/app/l10n/arb_catalog_parity_test.dart`

Responsibilities:

- Parse all ARB files with `dart:convert`.
- Ignore metadata keys that start with `@` when comparing string keys.
- Validate `@@locale` values against file names.
- Validate template descriptions for every string key in `app_pt_BR.arb`.
- Report failures with file names and key names.

Validation:

```bash
flutter test test/app/l10n/arb_catalog_parity_test.dart
```

### Task 2: Reconcile Current ARB Metadata

Files:

- Modify: `lib/l10n/app_pt.arb` if metadata policy requires locale-level descriptions.
- Modify: `lib/l10n/app_en.arb` if metadata policy requires locale-level descriptions.
- Prefer keeping descriptions only in the template ARB unless Flutter tooling requires otherwise.

Responsibilities:

- Keep `app_pt_BR.arb` as the metadata source of truth.
- Avoid duplicating metadata into every locale unless there is a tooling reason.
- Preserve existing translated values.

Validation:

```bash
flutter test test/app/l10n/arb_catalog_parity_test.dart
```

### Task 3: Add Pipeline Documentation to Daily Workflow

Files:

- Modify: `.codex/workflows/AI_MEMORY_LOOP.md` only if the workflow needs an explicit i18n validation reminder.
- Modify: `.ai/memory/technical_debt.md` after validation passes.

Responsibilities:

- Record that future UI work must keep both hardcoded-copy and ARB parity guards green.
- Keep implementation instructions tied to Dart MCP validation.

Validation:

```bash
flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart
```

## Acceptance Criteria

- ARB parity test exists and passes.
- The test fails clearly when any locale misses a key.
- The test fails clearly when template metadata is missing.
- The test fails clearly when `@@locale` does not match the ARB file.
- No user-facing copy is changed as part of Phase 1.
- The technical debt entry is updated after the guard is validated.

## Risks

- Over-validating metadata in non-template ARBs can create unnecessary maintenance work.
- Running Flutter tests may update `pubspec.lock` if the local Flutter SDK resolves different transitive versions; restore unrelated lockfile noise before committing.
- Generated localization files can drift if ARB changes are made without running the proper Flutter generation step.

## Recommended Trello Card

Create one backlog card:

```text
[DEBT] Add ARB catalog parity guard
```

The card should live in `FlowDelivery - Product Backlog` under `📥 Backlog` until the implementation task is explicitly approved.
