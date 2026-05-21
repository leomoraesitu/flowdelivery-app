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

Supabase client configuration is read from Dart defines:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

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

## Startup Decision

In development and widget tests, the app may start without Supabase
configuration. Authentication then uses a repository fallback that returns an
`AuthFailure` instead of touching the Supabase SDK.

When Supabase configuration is present, the SDK must be initialized by the app
startup path before any Supabase client provider is read. A configured but
uninitialized SDK is treated as a startup wiring error.

## Sprint 0 Scope

Sprint 0 documents the setup contract. Schema migrations and policies can be created in later tasks.
