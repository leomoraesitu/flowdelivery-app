# Sprint 0 Foundation Continuation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the documented Sprint 0 foundation into a minimal, tested Flutter application shell with theme tokens and feature-first structure ready for MVP work, while keeping runtime routing implementation deferred until an approved feature slice needs it.

**Architecture:** The repository already documents MVVM, feature-first organization, repository boundaries, design tokens, QA strategy, Trello workflow, and Codex governance. The application code is still intentionally small: `lib/main.dart` renders a `MaterialApp` with `Hello World!`, while `lib/app`, `lib/features`, and `lib/shared` currently contain structure markers only. This plan implements the smallest code foundation that makes the documented architecture real without starting product features prematurely.

**Tech Stack:** Flutter, Dart, Material 3, `flutter_lints`, `flutter_test`. Future dependencies such as Riverpod, GoRouter, Supabase, Freezed, and json_serializable are documented but should only be added when the task actually needs them.

---

## Current Repository Baseline

Completed foundation:

- Project documentation exists in `README.md` and `docs/PROJECT_BOOTSTRAP.md`.
- Architecture documentation exists in `docs/architecture/ARCHITECTURE_OVERVIEW.md` and `docs/architecture/MVVM_STRUCTURE.md`.
- Design system contract exists in `docs/design-system/DESIGN_SYSTEM.md` and `docs/design-system/TOKENS.md`.
- QA strategy exists in `docs/qa/QA_STRATEGY.md`.
- Codex governance exists in `docs/ai/CODEX_GOVERNANCE.md`.
- Sprint 0 tracking exists in `docs/project-management/SPRINT_0.md`.
- Trello board/list/label IDs are stored in `docs/project-management/trello/config/trello-ids.json`.
- CI exists at `.github/workflows/flutter-ci.yml`.
- Base folders exist: `lib/app`, `lib/features`, `lib/shared`, `assets`, `supabase`, and `test`.

Completed or deferred Sprint 0 items from repository docs:

- Base navigation strategy documented in `docs/architecture/ROUTING_CONVENTIONS.md`.
- Runtime navigation implementation explicitly deferred until approved feature work.

Open Sprint 0 items from repository docs:

- Theme structure implementation.
- GitHub labels synchronization.
- Real Trello card synchronization after external authentication is available.

Important constraint:

- Treat versioned code as the source of truth. Documentation describes the target architecture, but current app code only has the initial Flutter shell.

---

## File Structure

Create:

- `lib/app/app.dart` - app root widget that owns `MaterialApp`.
- `lib/app/theme/app_theme.dart` - light and dark `ThemeData`.
- `lib/app/theme/app_spacing.dart` - spacing tokens from `docs/design-system/TOKENS.md`.
- `lib/app/theme/app_radius.dart` - radius tokens from `docs/design-system/TOKENS.md`.
- `lib/app/theme/app_sizes.dart` - size tokens from `docs/design-system/TOKENS.md`.
- `lib/app/theme/app_durations.dart` - duration tokens from `docs/design-system/TOKENS.md`.
- `lib/features/splash/presentation/pages/splash_page.dart` - first route and visible shell page.
- `test/app/app_test.dart` - tests for app shell behavior.
- `test/app/theme/app_theme_test.dart` - tests for theme construction and token availability.

Modify:

- `lib/main.dart` - delegate app creation to `FlowDeliveryApp`.
- `test/widget_test.dart` - either update to the new app shell or keep only if it remains useful.
- `docs/project-management/SPRINT_0.md` - mark implemented items only after code and validation pass.
- `.ai/plans/2026-05-17-sprint-0-foundation-continuation-plan.md` - keep this plan aligned with the deferred routing decision.

Do not modify in this plan:

- Supabase integration files.
- Trello JSON IDs.
- Product features such as auth, cart, checkout, orders, or profile.
- External synchronization tasks that require authenticated services.
- Runtime routing implementation. Routing conventions are documented, but GoRouter wiring belongs to an approved feature plan.

---

### Task 1: App Root Extraction

**Files:**

- Create: `lib/app/app.dart`
- Create: `lib/features/splash/presentation/pages/splash_page.dart`
- Modify: `lib/main.dart`
- Test: `test/app/app_test.dart`

- [ ] **Step 1: Write the failing app shell test**

Create `test/app/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/app/app.dart';

void main() {
  testWidgets('renders FlowDelivery app shell', (tester) async {
    await tester.pumpWidget(const FlowDeliveryApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('FlowDelivery'), findsOneWidget);
    expect(find.text('Foundation ready'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the new test and confirm it fails**

Run:

```bash
flutter test test/app/app_test.dart
```

Expected:

```text
Error: Couldn't resolve the package 'flowdelivery_app/app/app.dart'
```

- [ ] **Step 3: Create the splash page**

Create `lib/features/splash/presentation/pages/splash_page.dart`:

```dart
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('FlowDelivery'),
            SizedBox(height: 8),
            Text('Foundation ready'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create the app root widget**

Create `lib/app/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flowdelivery_app/features/splash/presentation/pages/splash_page.dart';

class FlowDeliveryApp extends StatelessWidget {
  const FlowDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FlowDelivery',
      home: SplashPage(),
    );
  }
}
```

- [ ] **Step 5: Update the entry point**

Modify `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flowdelivery_app/app/app.dart';

void main() {
  runApp(const FlowDeliveryApp());
}
```

- [ ] **Step 6: Run the app shell test and confirm it passes**

Run:

```bash
flutter test test/app/app_test.dart
```

Expected:

```text
All tests passed!
```

- [ ] **Step 7: Commit**

```bash
git add lib/main.dart lib/app/app.dart lib/features/splash/presentation/pages/splash_page.dart test/app/app_test.dart
git commit -m "feat(app): extract initial application shell"
```

---

### Task 2: Theme Tokens

**Files:**

- Create: `lib/app/theme/app_spacing.dart`
- Create: `lib/app/theme/app_radius.dart`
- Create: `lib/app/theme/app_sizes.dart`
- Create: `lib/app/theme/app_durations.dart`
- Test: `test/app/theme/app_theme_test.dart`

- [ ] **Step 1: Write token tests**

Create `test/app/theme/app_theme_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/app/theme/app_durations.dart';
import 'package:flowdelivery_app/app/theme/app_radius.dart';
import 'package:flowdelivery_app/app/theme/app_sizes.dart';
import 'package:flowdelivery_app/app/theme/app_spacing.dart';

void main() {
  group('design tokens', () {
    test('spacing values match the documented contract', () {
      expect(AppSpacing.xxs, 4);
      expect(AppSpacing.xs, 8);
      expect(AppSpacing.sm, 12);
      expect(AppSpacing.md, 16);
      expect(AppSpacing.lg, 24);
      expect(AppSpacing.xl, 32);
      expect(AppSpacing.xxl, 48);
    });

    test('radius values match the documented contract', () {
      expect(AppRadius.none, 0);
      expect(AppRadius.sm, 4);
      expect(AppRadius.md, 8);
      expect(AppRadius.lg, 12);
      expect(AppRadius.xl, 16);
      expect(AppRadius.pill, 999);
    });

    test('sizes match the documented contract', () {
      expect(AppSizes.iconSm, 16);
      expect(AppSizes.iconMd, 24);
      expect(AppSizes.iconLg, 32);
      expect(AppSizes.touchTarget, 48);
    });

    test('durations match the documented contract', () {
      expect(AppDurations.fast, const Duration(milliseconds: 150));
      expect(AppDurations.normal, const Duration(milliseconds: 250));
      expect(AppDurations.slow, const Duration(milliseconds: 400));
    });
  });
}
```

- [ ] **Step 2: Run token tests and confirm they fail**

Run:

```bash
flutter test test/app/theme/app_theme_test.dart
```

Expected:

```text
Error: Couldn't resolve the package 'flowdelivery_app/app/theme/app_spacing.dart'
```

- [ ] **Step 3: Create spacing tokens**

Create `lib/app/theme/app_spacing.dart`:

```dart
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
```

- [ ] **Step 4: Create radius tokens**

Create `lib/app/theme/app_radius.dart`:

```dart
abstract final class AppRadius {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double pill = 999;
}
```

- [ ] **Step 5: Create size tokens**

Create `lib/app/theme/app_sizes.dart`:

```dart
abstract final class AppSizes {
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double touchTarget = 48;
}
```

- [ ] **Step 6: Create duration tokens**

Create `lib/app/theme/app_durations.dart`:

```dart
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
```

- [ ] **Step 7: Run token tests and confirm they pass**

Run:

```bash
flutter test test/app/theme/app_theme_test.dart
```

Expected:

```text
All tests passed!
```

- [ ] **Step 8: Commit**

```bash
git add lib/app/theme/app_spacing.dart lib/app/theme/app_radius.dart lib/app/theme/app_sizes.dart lib/app/theme/app_durations.dart test/app/theme/app_theme_test.dart
git commit -m "feat(theme): add documented design tokens"
```

---

### Task 3: Material Theme Structure

**Files:**

- Create: `lib/app/theme/app_theme.dart`
- Modify: `lib/app/app.dart`
- Test: `test/app/theme/app_theme_test.dart`
- Test: `test/app/app_test.dart`

- [ ] **Step 1: Extend theme tests**

Update `test/app/theme/app_theme_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/app/theme/app_durations.dart';
import 'package:flowdelivery_app/app/theme/app_radius.dart';
import 'package:flowdelivery_app/app/theme/app_sizes.dart';
import 'package:flowdelivery_app/app/theme/app_spacing.dart';
import 'package:flowdelivery_app/app/theme/app_theme.dart';

void main() {
  group('design tokens', () {
    test('spacing values match the documented contract', () {
      expect(AppSpacing.xxs, 4);
      expect(AppSpacing.xs, 8);
      expect(AppSpacing.sm, 12);
      expect(AppSpacing.md, 16);
      expect(AppSpacing.lg, 24);
      expect(AppSpacing.xl, 32);
      expect(AppSpacing.xxl, 48);
    });

    test('radius values match the documented contract', () {
      expect(AppRadius.none, 0);
      expect(AppRadius.sm, 4);
      expect(AppRadius.md, 8);
      expect(AppRadius.lg, 12);
      expect(AppRadius.xl, 16);
      expect(AppRadius.pill, 999);
    });

    test('sizes match the documented contract', () {
      expect(AppSizes.iconSm, 16);
      expect(AppSizes.iconMd, 24);
      expect(AppSizes.iconLg, 32);
      expect(AppSizes.touchTarget, 48);
    });

    test('durations match the documented contract', () {
      expect(AppDurations.fast, const Duration(milliseconds: 150));
      expect(AppDurations.normal, const Duration(milliseconds: 250));
      expect(AppDurations.slow, const Duration(milliseconds: 400));
    });
  });

  group('app theme', () {
    test('builds light and dark Material 3 themes', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppTheme.dark.brightness, Brightness.dark);
    });
  });
}
```

- [ ] **Step 2: Run the theme tests and confirm they fail**

Run:

```bash
flutter test test/app/theme/app_theme_test.dart
```

Expected:

```text
Error: Couldn't resolve the package 'flowdelivery_app/app/theme/app_theme.dart'
```

- [ ] **Step 3: Create app themes**

Create `lib/app/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE53935),
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE53935),
        brightness: Brightness.dark,
      ),
    );
  }
}
```

- [ ] **Step 4: Wire themes into the app root**

Modify `lib/app/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/splash/presentation/pages/splash_page.dart';

class FlowDeliveryApp extends StatelessWidget {
  const FlowDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowDelivery',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const SplashPage(),
    );
  }
}
```

- [ ] **Step 5: Run focused tests**

Run:

```bash
flutter test test/app/theme/app_theme_test.dart test/app/app_test.dart
```

Expected:

```text
All tests passed!
```

- [ ] **Step 6: Commit**

```bash
git add lib/app/app.dart lib/app/theme/app_theme.dart test/app/theme/app_theme_test.dart
git commit -m "feat(theme): add Material 3 app themes"
```

---

### Task 4: Base Navigation Strategy Documentation

**Files:**

- Create: `docs/architecture/ROUTING_CONVENTIONS.md`
- Modify: `docs/architecture/ARCHITECTURE_OVERVIEW.md`
- Modify: `.ai/context/architecture.md`
- Modify: `docs/project-management/SPRINT_0.md`
- Modify: `docs/project-management/trello/boards/product-backlog-board.json`
- Modify: `docs/project-management/trello/boards/sprint-0-board.json`
- Test: documentation and JSON validation only

- [x] **Step 1: Document routing conventions**

Create `docs/architecture/ROUTING_CONVENTIONS.md` with:

```text
- go_router as the accepted routing package
- MaterialApp.router as the future app shell
- lib/app/routes as the global routing boundary
- centralized route names and paths
- auth redirects based on app auth state
- StatefulShellRoute.indexedStack as the future protected shell approach
```

- [x] **Step 2: Document the implementation path**

Add the incremental routing path:

```text
1. Add go_router only in an approved implementation step.
2. Create app_routes.dart for route names and paths.
3. Create app_router.dart with GoRouter.
4. Migrate lib/app/app.dart to MaterialApp.router.
5. Add auth redirects after auth state exists.
6. Add StatefulShellRoute.indexedStack after multiple protected destinations exist.
```

- [x] **Step 3: Update architecture documentation**

Update `docs/architecture/ARCHITECTURE_OVERVIEW.md` and `.ai/context/architecture.md` so agents and humans know that global routes belong under `lib/app/routes` and feature widgets must not own global route policy.

- [x] **Step 4: Reconcile Sprint 0 and local Trello artifacts**

Update:

```text
docs/project-management/SPRINT_0.md
docs/project-management/trello/boards/product-backlog-board.json
docs/project-management/trello/boards/sprint-0-board.json
```

Expected state:

```text
- Base navigation strategy is documented.
- Runtime navigation implementation is explicitly deferred.
- Theme structure, GitHub labels, and real Trello sync remain open.
```

- [x] **Step 5: Update the real Trello card**

Update the real Trello card `[ARCH] Implement base navigation strategy`:

```text
- description includes the documented outcome
- checklist items are complete
- card is moved to Done
```

- [x] **Step 6: Validate documentation and JSON**

Run:

```bash
git diff --check
Get-Content -Raw docs/project-management/trello/boards/sprint-0-board.json | ConvertFrom-Json | Out-Null
Get-Content -Raw docs/project-management/trello/boards/product-backlog-board.json | ConvertFrom-Json | Out-Null
```

Expected:

```text
No diff check errors.
Both JSON files parse successfully.
```

- [x] **Step 7: Commit**

```bash
git add .ai/context/architecture.md docs/architecture/ARCHITECTURE_OVERVIEW.md docs/architecture/ROUTING_CONVENTIONS.md docs/project-management/SPRINT_0.md docs/project-management/trello/boards/product-backlog-board.json docs/project-management/trello/boards/sprint-0-board.json
git commit -m "docs(architecture): document routing strategy"
```

---

### Task 5: Sprint 0 Documentation Reconciliation

**Files:**

- Modify: `docs/project-management/SPRINT_0.md` only after theme Tasks 1 through 3 pass
- Test: documentation review only

- [ ] **Step 1: Update completed theme checklist items**

Modify the open Sprint 0 items only if Tasks 1 through 3 passed:

```markdown
Open:

- GitHub labels synchronization
- Real Trello card synchronization after Composio authentication is available
```

Update backlog sections:

```markdown
### Architecture

- [x] MVVM structure documented
- [x] Feature-first organization documented
- [x] Base navigation strategy documented in `docs/architecture/ROUTING_CONVENTIONS.md`
- [x] Navigation implementation explicitly deferred until approved feature work

### Design System

- [x] Tokens documented
- [x] Typography strategy documented
- [x] Spacing system documented
- [x] Theme structure implementation
```

- [ ] **Step 2: Confirm no external sync was claimed**

Review `docs/project-management/SPRINT_0.md` and confirm these remain open:

```markdown
- [ ] GitHub labels
- [ ] Real Trello cards synchronized
```

- [ ] **Step 3: Commit**

```bash
git add docs/project-management/SPRINT_0.md
git commit -m "docs(project): update sprint 0 implementation status"
```

---

### Task 6: Final Validation

**Files:**

- Validate: full repository

- [ ] **Step 1: Run static analysis**

Run:

```bash
flutter analyze
```

Expected:

```text
No issues found!
```

- [ ] **Step 2: Run all tests**

Run:

```bash
flutter test
```

Expected:

```text
All tests passed!
```

- [ ] **Step 3: Inspect git status**

Run:

```bash
git status --short
```

Expected:

```text

```

This expected output is only valid after all planned commits are created. If the user asked not to commit, expected output should show only the intentional uncommitted files from this plan.

---

## Out of Scope

- Auth implementation.
- Restaurant feed implementation.
- Cart, checkout, orders, delivery, analytics, and profile features.
- Supabase schema, RLS policies, Edge Functions, and environment secret setup.
- GitHub API synchronization without authenticated tooling.
- Runtime routing implementation. `go_router` remains documented and deferred until an approved feature task needs it.
- Adding Riverpod or GoRouter before there is a concrete use case in code.

---

## Recommended Next Plan After This

After this foundation lands, create a separate plan for the first real MVP feature:

```text
.ai/plans/YYYY-MM-DD-authentication-foundation-plan.md
```

That future plan should introduce Riverpod, Supabase Auth, auth repositories, auth ViewModels, route guards, and focused auth tests in one bounded slice.

---

## Self-Review

Spec coverage:

- Sprint 0 navigation strategy is covered by Task 4 as documented and explicitly deferred.
- Sprint 0 open item "Theme structure implementation" is covered by Tasks 2 and 3.
- GitHub label sync is intentionally left open because it requires external authenticated tooling.
- Real Trello sync for the base navigation card was completed through authenticated Zapier tooling; broad Trello synchronization remains outside this plan.
- The current `Hello World!` shell is replaced through Task 1, with tests.

Placeholder scan:

- No `TBD`, `TODO`, or "implement later" placeholders are used.
- Every implementation task includes exact paths, concrete code, command, and expected result.

Type consistency:

- `FlowDeliveryApp`, `AppTheme`, `SplashPage`, `AppSpacing`, `AppRadius`, `AppSizes`, and `AppDurations` are defined before use in later tasks.
- Runtime route symbols are no longer introduced in this plan. Future route names and paths should follow `docs/architecture/ROUTING_CONVENTIONS.md`.
