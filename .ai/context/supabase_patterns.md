# FlowDelivery AI Context — Supabase Patterns

## Source of Truth

Primary doc:

- `docs/setup/SUPABASE_SETUP.md`

## Planned Supabase Services

FlowDelivery is expected to use:

- Auth
- PostgreSQL Database
- Realtime
- Storage
- Edge Functions

## Planned Domain Tables

Initial planned tables:

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

## Security Rules

- Enable Row Level Security on application tables.
- Prefer policies scoped by authenticated user and role.
- Never expose service role keys in Flutter.
- Do not commit real secrets.
- Keep privileged operations outside the client app.

## Client Integration Rules

- Supabase calls must not live inside widgets.
- Datasources own low-level Supabase queries.
- Repositories expose domain-oriented methods.
- DTOs should be mapped before reaching presentation state.
- UI state should use domain models, not raw Supabase responses.

## Data Flow

```text
Widget
↓
ViewModel / State Manager
↓
Repository
↓
Datasource
↓
Supabase Client
```

## Error Handling

Supabase errors should be translated before reaching UI.

Recommended layers:

- datasource captures low-level error
- repository maps to domain failure
- ViewModel or state manager exposes user-safe message

## Secret Handling

Use environment variables for:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

Never use service role keys in Flutter client code.
