# FlowDelivery — Supabase Setup

## Objective

Define the planned Supabase foundation for FlowDelivery.

## Services

FlowDelivery is expected to use:

- Auth
- PostgreSQL Database
- Realtime
- Storage
- Edge Functions

## Initial Tables

Planned domain tables:

```text
profiles
restaurants
restaurant_categories
products
product_options
orders
order_items
drivers
deliveries
payments
reviews
notifications
```

## Security Baseline

- Enable Row Level Security on application tables.
- Prefer policies scoped by authenticated user and role.
- Never expose service role keys in Flutter.
- Keep all privileged operations outside the client app.

## Client Integration Rules

- Supabase calls must not live inside widgets.
- Datasources own low-level Supabase queries.
- Repositories expose domain-oriented methods.
- DTOs should be mapped before reaching presentation state.
- Riverpod dependency wiring belongs to the app composition root under
  `lib/app`, not to presentation widgets.

## Runtime Configuration

Supabase client configuration is read from Dart defines at app startup:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

Both values are required to enable real authentication. They are read by
`AppEnvironment` and passed to `Supabase.initialize` from `lib/main.dart`.

For local VS Code launches, use:

```text
.vscode/supabase.local.json
```

The local file must not be committed. The repository keeps
`.vscode/supabase.example.json` as a safe template and ignores the local file in
`.gitignore`.

The VS Code Supabase launch configurations pass the local file with:

```text
--dart-define-from-file=.vscode/supabase.local.json
```

Use either `flowdelivery_app (supabase)` or `flowdelivery_app (supabase web)`
from `.vscode/launch.json` when testing authentication against a real Supabase
project.

## Startup Decision

In development and widget tests, the app may start without Supabase
configuration. Authentication then uses a repository fallback that returns an
`AuthFailure` instead of touching the Supabase SDK.

Current fallback:

```text
UnconfiguredAuthRepository
```

The fallback keeps widgets and ViewModels testable without real Supabase
credentials while still surfacing a user-safe configuration error when auth
actions are attempted.

When Supabase configuration is present, the SDK must be initialized by the app
startup path before any Supabase client provider is read. A configured but
uninitialized SDK is treated as a startup wiring error.

## Sprint 0 Scope

Sprint 0 documents the setup contract. Schema migrations and policies can be created in later tasks.

## Manual QA - Recovery Email Deliverability (Non-local Mailbox)

Use this checklist when validating password-recovery email delivery in a QA
environment outside local/dev inboxes.

Preconditions:

- Supabase project has Auth URL configuration with the intended redirect origin.
- The app runs with valid `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
- A real non-local QA mailbox is available (for example, corporate or provider
  inbox).

Execution:

1. Start the app with Supabase-enabled launch settings.
2. Open forgot-password and submit a valid QA email address.
3. Confirm the app shows success feedback for the request action.
4. Open the mailbox and confirm recovery email arrival within the expected SLA.
5. Open the recovery link and verify the browser lands on `/reset-password`.
6. Submit a new password and confirm success feedback in the reset flow.

Evidence to record:

- Mail provider and mailbox used for the run.
- Timestamp of request and timestamp of email arrival.
- Recovery-link target URL observed after click.
- Pass/fail outcome and any provider-specific anomaly notes.

Failure handling:

- If email is not delivered, capture provider spam/quarantine checks and
  Supabase Auth email logs before retesting.
- If redirect path is incorrect, re-check Supabase Auth URL settings and app
  redirect path conventions.
