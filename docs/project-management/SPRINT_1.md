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

Planned.

This sprint is generated from the approved technical plan. Implementation has not started yet.

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

### Testing

- Focused tests for environment configuration.
- Focused tests for auth domain boundaries.
- Focused tests for Auth ViewModel behavior.
- Focused tests for repository implementation behavior.
- Focused tests for Riverpod provider wiring.
- Focused tests for auth pages.
- Routing tests when route implementation is introduced.

### Documentation

- Supabase setup documentation updated only after implementation changes are validated.
- Current feature memory updated after completed slices.
- Technical debt updated after planned dependencies are installed.

---

## Sprint Backlog

### Dependencies

- [ ] Add `flutter_riverpod`, `go_router`, and `supabase_flutter` intentionally.
- [ ] Run dependency resolution.
- [ ] Run static analysis after dependency changes.

### App Configuration

- [ ] Create app-level Supabase environment configuration.
- [ ] Add tests for `SUPABASE_URL` and `SUPABASE_ANON_KEY` access.
- [ ] Validate configuration slice.

### Auth Domain

- [ ] Create `AuthUser`.
- [ ] Create `AuthFailure`.
- [ ] Create `AuthRepository` contract.
- [ ] Add domain tests.

### Auth Presentation Logic

- [ ] Create explicit `AuthState`.
- [ ] Create `AuthViewModel`.
- [ ] Add ViewModel tests for initial, success, failure, and sign-out states.

### Auth Data Layer

- [ ] Create auth remote datasource contract.
- [ ] Create Supabase Auth datasource implementation.
- [ ] Create repository implementation.
- [ ] Add repository implementation tests with fake datasource.

### Riverpod Wiring

- [ ] Create auth providers.
- [ ] Add provider override tests.
- [ ] Wrap the app root with `ProviderScope` when approved by the implementation step.

### Routing

- [ ] Create route constants.
- [ ] Create app router with GoRouter.
- [ ] Add auth redirect behavior based on auth state.
- [ ] Preserve app-level ownership of global navigation policy.
- [ ] Add routing tests.

### Auth UI

- [ ] Create sign-in page.
- [ ] Create sign-up page.
- [ ] Render email and password fields.
- [ ] Render primary action buttons.
- [ ] Render navigation between sign-in and sign-up.
- [ ] Add widget tests for auth pages.

### Startup Integration

- [ ] Initialize Supabase at app startup using app-level configuration.
- [ ] Avoid real SDK initialization in tests where possible.
- [ ] Validate startup integration with analysis and tests.

### Documentation and Memory

- [ ] Update `.ai/memory/current_feature.md` after validated implementation slices.
- [ ] Update `.ai/memory/technical_debt.md` after dependencies are installed.
- [ ] Update `docs/setup/SUPABASE_SETUP.md` with required Dart defines.
- [ ] Update routing documentation only if implemented behavior differs from current conventions.

---

## Acceptance Criteria

- [ ] Auth feature has explicit domain, data, presentation, provider, and routing boundaries.
- [ ] Widgets do not import Supabase.
- [ ] ViewModels do not import Supabase.
- [ ] Supabase calls are isolated in the datasource layer.
- [ ] Riverpod is used for dependency wiring and UI state observation.
- [ ] GoRouter owns global route policy and auth redirects.
- [ ] Route paths and names are centralized.
- [ ] Each implemented slice has focused validation.
- [ ] Documentation and memory reflect only validated implementation.

---

## Out of Scope

- Password reset.
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

---

## Success Criteria

- Authentication foundation is implemented incrementally.
- Each slice is testable and reversible.
- MVVM and Clean Architecture boundaries remain intact.
- Supabase stays outside widgets and ViewModels.
- Recruiter-facing documentation remains aligned with repository behavior.
