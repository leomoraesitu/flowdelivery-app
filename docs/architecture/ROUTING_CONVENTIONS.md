# FlowDelivery - Routing Conventions

## Objective

Define the routing conventions for FlowDelivery before navigation is implemented.

This document complements `ADR 004 - Use GoRouter`. The ADR records the
decision; this document defines how routing should be organized in the codebase.

## Routing Package

FlowDelivery uses `go_router` as the planned routing solution.

Important:

- `go_router` is accepted as the routing package.
- The dependency must be added intentionally to `pubspec.yaml` before any import.
- Do not import `go_router` while the package is absent from the project.

## App Shell

The application shell should live at app level.

Expected responsibilities:

- `lib/main.dart` initializes app-level dependencies and starts the root widget.
- `lib/app/app.dart` owns the root `MaterialApp.router`.
- `lib/app/routes/` owns route configuration, route paths and route names.
- Feature pages provide screen widgets, not global navigation policy.

The root app should migrate from `MaterialApp` to `MaterialApp.router` only when
the routing dependency is added as part of an approved implementation step.

## Route Organization

Global route definitions belong in:

```text
lib/app/routes/
```

Recommended files:

```text
lib/app/routes/app_router.dart
lib/app/routes/app_routes.dart
```

Responsibilities:

- `app_router.dart` creates and configures the `GoRouter`.
- `app_routes.dart` centralizes route names and paths.

Feature pages belong in:

```text
lib/features/<feature>/presentation/pages/
```

Widgets and feature pages must not define global routes or own application-wide
redirect behavior.

## Naming and Paths

Keep route names and paths centralized.

Expected initial public routes:

```text
/
/sign-in
/sign-up
```

Expected protected routes as the MVP grows:

```text
/home
/restaurants
/cart
/orders
/profile
```

Use clear, stable paths that can support Flutter Web and future deep links.

Avoid hardcoded route strings scattered across widgets. Navigation calls should
use centralized names or paths from the app routing module.

## Auth Guards

Authentication guards belong in the app router configuration.

Rules:

- Redirects must depend on application auth state.
- Auth state should come from the Riverpod/ViewModel/repository flow.
- Route guards must not call Supabase directly.
- Widgets must not implement global auth redirect policy.
- Feature pages should render state and delegate actions to ViewModels.

Expected auth flow:

```text
Router
↓
Auth state provider / ViewModel state
↓
Repository
↓
Datasource
↓
Supabase Auth
```

## Shell Navigation

When the logged-in area has multiple main destinations, use a shell route.

Recommended future structure:

- `StatefulShellRoute.indexedStack` for authenticated app tabs.
- One branch per major tab, such as home, restaurants, orders and profile.
- Persistent tab state when users switch between sections.

This keeps the app shell responsible for navigation while feature pages remain
focused on rendering their own UI state.

## Implementation Path

Feature navigation should be introduced incrementally. Do not implement the full
route tree before the feature slices that need it exist.

Recommended order:

1. Keep `go_router` documented as the accepted routing package.
2. Add `go_router` to `pubspec.yaml` only in an approved implementation step.
3. Create `lib/app/routes/app_routes.dart` with route names and paths.
4. Create `lib/app/routes/app_router.dart` with the initial `GoRouter`.
5. Migrate `lib/app/app.dart` from `MaterialApp` to `MaterialApp.router`.
6. Add auth redirects only after auth state is exposed through the app state flow.
7. Add shell navigation only after multiple protected destinations exist.

### Phase 1: Routing Dependency

Entry criteria:

- The technical plan explicitly approves adding navigation dependencies.
- `pubspec.yaml` has been checked before imports are introduced.

Exit criteria:

- `go_router` is installed.
- Dependency resolution succeeds.
- Static analysis still passes.

### Phase 2: Route Registry

Entry criteria:

- `go_router` is available in the project.
- The first routes needed by the current feature are known.

Exit criteria:

- Route paths and names are centralized in `app_routes.dart`.
- Widgets do not contain duplicated route strings.
- Public and protected route groups are easy to identify.

### Phase 3: App Router

Entry criteria:

- Route constants exist.
- Initial destination pages exist or approved placeholders are part of the task.

Exit criteria:

- `app_router.dart` owns the `GoRouter` configuration.
- `lib/app/app.dart` uses `MaterialApp.router`.
- Feature pages are used as destinations but do not own global route policy.

### Phase 4: Auth Redirects

Entry criteria:

- Auth state exists outside widgets.
- The router can read auth state without calling Supabase directly.

Exit criteria:

- Unauthenticated users are redirected to sign in when accessing protected routes.
- Authenticated users are redirected away from sign-in/sign-up when appropriate.
- Loading or unknown auth state is handled without redirect loops.

### Phase 5: Protected App Shell

Entry criteria:

- At least two protected top-level destinations exist.
- Bottom navigation is part of an approved feature scope.

Exit criteria:

- `StatefulShellRoute.indexedStack` owns tab navigation.
- Branches preserve state when switching sections.
- Feature pages remain responsible only for their own UI state.

## Boundaries

Do:

- keep routing in `lib/app/routes`;
- keep route names and paths centralized;
- use feature pages as route destinations;
- update this document when the route structure changes.

Do not:

- define global routes inside feature widgets;
- call Supabase from route builders or widgets;
- let ViewModels own global route paths unless an approved technical plan says so;
- add navigation dependencies without an implementation step and validation.
