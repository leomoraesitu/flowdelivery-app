# ADR 002 — Use Supabase

## Status

Accepted

## Context

FlowDelivery needs a backend platform for authentication, relational data, realtime flows, storage and server-side operations.

The project is a portfolio-grade Flutter application and should demonstrate fullstack architecture without requiring custom backend infrastructure at the start.

## Decision

Use Supabase as the planned backend platform.

Expected Supabase services:

- Auth
- PostgreSQL Database
- Realtime
- Storage
- Edge Functions

## Consequences

Positive:

- faster backend foundation
- PostgreSQL supports relational modeling
- Auth and Realtime fit the delivery domain
- Edge Functions support privileged operations outside the Flutter client

Tradeoffs:

- Row Level Security must be designed carefully
- client code must never expose service role keys
- Supabase queries must be isolated from UI
- schema and policy changes need documentation and validation

## Implementation Notes

Supabase integration must follow this flow:

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

Rules:

- widgets must not call Supabase directly
- datasources own low-level Supabase queries
- repositories expose domain-oriented methods
- DTOs must be mapped before reaching presentation state
- RLS must be enabled on application tables
- service role keys must never be used in Flutter client code
