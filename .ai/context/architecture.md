# FlowDelivery AI Context — Architecture

## Source of Truth

Primary docs:

- `docs/architecture/ARCHITECTURE_OVERVIEW.md`
- `docs/architecture/MVVM_STRUCTURE.md`
- `docs/ai/CODEX_GOVERNANCE.md`

## Baseline Architecture

FlowDelivery follows:

- MVVM
- feature-first organization
- Repository Pattern
- Supabase isolated from presentation
- centralized app configuration
- shared design system and reusable widgets

## Layer Flow

```text
UI
↓
ViewModel
↓
Repository
↓
Datasource
↓
Supabase / External Services
```

## Folder Responsibilities

`lib/app` owns:

- routing through centralized modules under `lib/app/routes`
- theme
- environment config
- dependency setup
- app shell

`lib/features` owns feature domains:

- auth
- restaurants
- products
- cart
- checkout
- orders
- delivery
- profile
- analytics

`lib/shared` owns generic reusable code:

- common widgets
- extensions
- constants
- utilities
- shared models

## Dependency Rules

- UI depends on ViewModels.
- ViewModels depend on repositories.
- Repositories depend on datasources.
- Datasources depend on Supabase or external clients.
- UI must not call Supabase directly.
- Global routes must not be defined inside feature widgets.
- Features must not depend on another feature implementation.
- Shared code must remain generic.

## AI Instruction

When generating code, preserve the architecture contract before adding convenience shortcuts.
