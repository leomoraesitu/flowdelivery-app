# Sprint 1 - Authentication Foundation

## Objective

Implement the first authentication foundation for FlowDelivery using the approved Authentication plan.

Reference plan:

- `.ai/plans/2026-05-19-authentication-plan.md`

---

## Sprint Goal

Deliver a minimal, testable authentication foundation with Supabase Auth, Riverpod, GoRouter, MVVM, and Clean Architecture boundaries.

---

## Status

Completed and validated.

Sprint 1 is closed and its implementation state is reflected in the repository docs and memory.

This sprint was implemented incrementally from the approved technical plan.
Tasks 1-10 are completed for the Authentication foundation.

---

## Scope

Sprint 1 focuses on authentication foundation only:

- approved auth dependencies;
- app-level Supabase environment configuration;
- auth domain model and repository contract;
- auth ViewModel and explicit UI state;
- Supabase datasource isolated in the data layer;
- repository implementation;
- Riverpod provider wiring;
- initial declarative routing and auth guard;
- sign-in and sign-up UI;
- documentation and memory reconciliation after validated slices.

---

## Deliverables

### Engineering

- Auth dependencies added intentionally.
- Supabase configuration centralized.
- Auth feature structure created under `lib/features/auth`.
- Auth domain, data, presentation, ViewModel, and provider boundaries implemented.
- Initial GoRouter route registry and app router implemented.
- Sign-in and sign-up screens implemented.
- Post-completion sign-in screen UI/UX parity update applied to match `docs/ux/prototypes/auth-screen.png`.
- Shared auth UI shell extracted to reduce duplication between sign-in and sign-up pages.
- Forgot-password route and page were connected to a functional password recovery request flow.
- Reset-password route, UI, ViewModel state, repository contract, and Supabase password update support were added for established recovery sessions.
- Social login placeholders remain explicitly disabled with "coming soon" microcopy.
- Auth flow UI was translated to PT-BR and locale was configured at app level.
- Authentication copy and user-safe auth errors were centralized in app-level i18n files.
- Typography families were confirmed and applied through theme tokens with Google Fonts integration.

### Testing

- Focused tests for environment configuration.
- Focused tests for auth domain boundaries.
- Focused tests for Auth ViewModel behavior.
- Focused tests for repository implementation behavior.
- Focused tests for Riverpod provider wiring.
- Focused tests for auth pages.
- Routing tests when route implementation is introduced.
- Auth pages tests updated to account for a scrollable sign-in layout and kept passing.
- Router tests include redirect coverage for unauthenticated, authenticated, and loading auth states.
- Recovery flow tests added for repository, viewmodel, and forgot-password page success/error feedback.
- Recovery flow tests include stale-feedback reset behavior when revisiting forgot-password screen.
- Reset-password tests cover repository password update mapping, ViewModel reset lifecycle, auth guard routing, widget validation, success, and failure feedback.
- Localization and i18n refactor changes were validated with focused auth test suites.
- User-facing strings now flow through Flutter gen-l10n ARB files and generated `AppLocalizations`.
- The localization guard test blocks hardcoded copy in presentation and route files, including `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, `semanticLabel`, `InputDecoration.errorText`, `TextSpan.text`, and `SnackBarAction`.

### Documentation

- Supabase setup documentation updated after implementation changes were validated.
- Routing conventions wording refreshed to reflect implemented behavior.
- Current feature memory updated after completed slices.
- Technical debt updated after planned dependencies and startup integration were completed.
- Memory and sprint records updated after sign-in UI parity stabilization.
- Design system docs were updated with explicit font families and i18n source-of-truth references.
- Documentation and workflow templates were updated so new feature plans must include a localization guard checklist before implementation.

### Post-Completion Stabilization

- A focused UI/UX stabilization step was executed after Tasks 1-10 to align the sign-in page with the approved auth prototype.
- The update was restricted to presentation-layer behavior and did not introduce new authentication capabilities.
- Validation remained focused on auth page widget tests for regression safety.
- A second stabilization slice unified auth UI composition with a shared shell and clearer visual-state semantics.
- Placeholder controls were made intentionally non-interactive to avoid implying unsupported behavior.
- A third stabilization slice enabled functional password recovery wiring while preserving MVVM/Clean Architecture boundaries.
- A fourth stabilization slice translated authentication UI and operational auth messages to PT-BR.
- A fifth stabilization slice centralized auth copy into Flutter gen-l10n ARB files and removed the duplicate static auth copy catalog.
- A sixth stabilization slice expanded localization discipline with a guard test that blocks hardcoded user-facing copy in presentation and route files.
- A seventh stabilization slice applied post-review corrective fixes for router/provider coupling, password-recovery lifecycle consistency, and semantic theme usage cleanup in auth presentation.

### Password Recovery Completion

- The implemented Sprint 1 recovery scope currently sends the Supabase recovery email and shows request feedback.
- The password recovery completion slice added reset-password route handling, new-password UI, ViewModel reset state, repository/datasource password update support, and focused automated tests.
- Supabase password update calls remain isolated in the datasource layer.
- Recovery redirect configuration was validated with a real Supabase recovery link against the local release web build; the link lands on `/reset-password` and renders the reset-password UI.
- Inbox/email-provider deliverability remains environment-specific and should be validated when a non-local QA mailbox is selected.
- Social login, profile synchronization, role-based access, realtime, Edge Functions, and the full authenticated app shell remain out of scope.

---

## Sprint Backlog

### Dependencies

- [x] Add `flutter_riverpod`, `go_router`, and `supabase_flutter` intentionally.
- [x] Run dependency resolution.
- [x] Run static analysis after dependency changes.

### App Configuration

- [x] Create app-level Supabase environment configuration.
- [x] Add tests for `SUPABASE_URL` and `SUPABASE_ANON_KEY` access.
- [x] Validate configuration slice.

### Auth Domain

- [x] Create `AuthUser`.
- [x] Create `AuthFailure`.
- [x] Create `AuthRepository` contract.
- [x] Add domain tests.

### Auth Presentation Logic

- [x] Create explicit `AuthState`.
- [x] Create `AuthViewModel`.
- [x] Add ViewModel tests for initial, success, failure, and sign-out states.

### Auth Data Layer

- [x] Create auth remote datasource contract.
- [x] Create Supabase Auth datasource implementation.
- [x] Create repository implementation.
- [x] Add repository implementation tests with fake datasource.

### Riverpod Wiring

- [x] Create auth providers.
- [x] Add provider override tests.
- [x] Wrap the app root with `ProviderScope` when approved by the implementation step.

### Routing

- [x] Create route constants.
- [x] Create app router with GoRouter.
- [x] Add auth redirect behavior based on auth state.
- [x] Preserve app-level ownership of global navigation policy.
- [x] Add routing tests.

### Auth UI

- [x] Create sign-in page.
- [x] Create sign-up page.
- [x] Render email and password fields.
- [x] Render primary action buttons.
- [x] Render navigation between sign-in and sign-up.
- [x] Add widget tests for auth pages.

### Startup Integration

- [x] Initialize Supabase at app startup using app-level configuration.
- [x] Avoid real SDK initialization in tests where possible.
- [x] Validate startup integration with analysis and tests.

### Documentation and Memory

- [x] Update `.ai/memory/current_feature.md` after validated implementation slices.
- [x] Update `.ai/memory/technical_debt.md` after dependencies are installed.
- [x] Update `docs/setup/SUPABASE_SETUP.md` with required Dart defines.
- [x] Update routing documentation when wording needed reconciliation with implemented behavior.

---

## Acceptance Criteria

- [x] Auth feature has explicit domain, data, presentation, provider, and routing boundaries.
- [x] Widgets do not import Supabase.
- [x] ViewModels do not import Supabase.
- [x] Supabase calls are isolated in the datasource layer.
- [x] Riverpod is used for dependency wiring and UI state observation.
- [x] GoRouter owns global route policy and auth redirects.
- [x] Route paths and names are centralized.
- [x] Each implemented slice has focused validation.
- [x] Documentation and memory reflect only validated implementation.

---

## Out of Scope

- Platform-specific production deep-link delivery beyond the local web recovery redirect.
- Social login.
- Profile table synchronization.
- Role-based access.
- Realtime auth-dependent flows.
- Edge Functions.
- Production secrets or service role keys.
- Full authenticated app shell with multiple tabs.

---

## Risks

- Package versions may need adjustment during dependency resolution.
- Supabase Auth manual validation requires real project credentials.
- Router guards can create redirect loops if loading, authenticated, and unauthenticated states are not separated.
- Widget tests may require provider overrides to avoid real Supabase initialization.
- Documentation can drift if updated before implementation is validated.

---

## Validation Strategy

Validate each slice with the smallest reliable command from the implementation plan.

Common validation commands:

```bash
flutter analyze
flutter test
```

Project rule:

- Flutter and Dart commands should use Dart MCP after `add_roots` when that tooling is available.
- If Dart MCP is unavailable, record the fallback before using CLI commands.

Final Sprint 1 validation:

- Dart MCP `analyze_files`: No errors.
- Dart MCP `run_tests`: All tests passed.

---

## Success Criteria

- Authentication foundation was implemented incrementally.
- Each slice is testable and reversible.
- MVVM and Clean Architecture boundaries remain intact.
- Supabase stays outside widgets and ViewModels.
- Recruiter-facing documentation remains aligned with repository behavior.
