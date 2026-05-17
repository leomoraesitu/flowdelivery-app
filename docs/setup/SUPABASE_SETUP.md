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

## Sprint 0 Scope

Sprint 0 documents the setup contract. Schema migrations and policies can be created in later tasks.
