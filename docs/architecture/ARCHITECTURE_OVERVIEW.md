# FlowDelivery — Architecture Overview

## Objective

Define the baseline architecture for FlowDelivery before product feature implementation.

## Architectural Style

FlowDelivery follows:

- MVVM
- Feature-first organization
- Repository Pattern
- Supabase isolated from presentation
- Centralized app configuration
- Shared design system and reusable widgets

## High-Level Layers

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

### lib/app

Application-level configuration:

- routing
- theme
- environment config
- dependency setup
- app shell

### lib/features

Business features grouped by domain:

- auth
- restaurants
- products
- cart
- checkout
- orders
- delivery
- profile
- analytics

### lib/shared

Reusable code that is not owned by a single feature:

- common widgets
- extensions
- constants
- utilities
- shared models

## Dependency Rules

- UI can depend on ViewModels.
- ViewModels can depend on repositories.
- Repositories can depend on datasources.
- Datasources can depend on Supabase or external clients.
- Features must not depend directly on another feature implementation.
- Shared code must remain generic and reusable.

## Sprint 0 Scope

Sprint 0 establishes the architecture contract. It does not require full feature implementation.
