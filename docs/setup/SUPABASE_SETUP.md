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

## Remote Schema Deployment

The repository keeps versioned migrations under `supabase/migrations/`. As of
2026-06-03 the following migrations are applied to the active remote project
`flowdelivery-app` (ref `kvbahsdjmhpukzmdttvq`, region `us-west-2`):

```text
home_remote_feed_foundation        (restaurant_categories, restaurants,
                                    restaurant_category_links, home_promotions)
restaurant_details_remote_catalog  (restaurant_menu_categories,
                                    restaurant_menu_items)
catalog_demo_coverage              (deterministic menu categories/items for
                                    pasta_roma, sushi_zen, and taco_harbor)
```

Deployment facts recorded after applying migrations via the Supabase MCP
`apply_migration` tool:

- The migrations succeeded and are listed by `list_migrations`.
- All six `public` tables exist with Row Level Security enabled.
- Seed counts match the deterministic fixtures: `restaurant_categories` 5,
  `restaurants` 4, `restaurant_category_links` 8, `home_promotions` 1,
  `restaurant_menu_categories` 13, `restaurant_menu_items` 16.
- Security advisors reported no missing-RLS issues on the new tables. The only
  open advisory is an unrelated Auth-level `auth_leaked_password_protection`
  warning.

Read access is restricted to the `authenticated` role through explicit grants
and authenticated read policies, so the app must be signed in before the Home
feed and restaurant details load remote data.

Catalog seed coverage now exists for all seeded Home restaurants:
`burger_artisan_collective` has 4 categories and 4 items; `pasta_roma`,
`sushi_zen`, and `taco_harbor` each have 3 categories and 4 items.

Migration application order matters: apply `home_remote_feed_foundation` before
`restaurant_details_remote_catalog`, because the catalog tables reference
`public.restaurants`.

## Catalog Media Storage

The public `catalog-media` bucket stores non-sensitive restaurant and product
catalog images. Its versioned foundation enforces:

- public object downloads;
- `image/webp` as the only allowed MIME type;
- a `1 MiB` per-file limit;
- no `INSERT`, `UPDATE`, or `DELETE` policy for `anon` or `authenticated`.

Catalog media uploads and replacements are administrative deployment
operations. Use approved Supabase tooling outside the Flutter client. Never add
a service-role or secret key to Flutter configuration, source code, or assets.

Public download smoke testing requires at least one uploaded object and is
performed with the deterministic manifest upload task.

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
