# FlowDelivery — Project Bootstrap

Version: 1.0.0  
Status: Bootstrap Phase  
Author: Leonardo de Moraes Souza  
Project Type: Portfolio / SaaS Simulation / Fullstack Flutter Engineering  
Architecture: MVVM + Feature First  
Backend: Supabase  
Frontend: Flutter  
State Management: Riverpod  

---

# 1. Project Vision

## Objective

FlowDelivery is a recruiter-grade Flutter application designed to simulate a real-world food delivery platform while showcasing modern software engineering practices.

The project aims to demonstrate advanced competencies in:

- Flutter Engineering
- MVVM Architecture
- Backend-as-a-Service integration
- PostgreSQL relational modeling
- Real-time systems
- Clean code
- State management
- Scalability
- CI/CD
- Software architecture
- AI-assisted development workflows

This project is intentionally structured as a professional software product rather than a tutorial-level CRUD application.

---

# 2. Product Overview

## Product Concept

FlowDelivery is a multi-role food delivery platform composed of:

- Customer App
- Restaurant Management Module
- Delivery Driver Module
- Admin/Analytics Dashboard

---

## Core Goals

The project should demonstrate:

- Scalable Flutter architecture
- Clean separation of concerns
- Professional folder organization
- Robust state management
- Production-grade backend integration
- Realtime synchronization
- Responsive UI
- Offline-aware architecture
- Professional engineering workflows

---

# 3. Engineering Philosophy

This project follows enterprise-inspired software engineering conventions.

## Key Principles

- Feature-first organization
- Separation of concerns
- SOLID principles
- Single source of truth
- Scalable architecture
- Testability
- Predictable state management
- Strong typing
- Immutable models
- Environment isolation
- Automation-first mindset

---

# 4. AI-Assisted Development Strategy

## IMPORTANT

This project is intentionally designed to be developed with AI pair-programming assistance using tools such as:

- Codex
- GitHub Copilot
- GPT-based agents
- MCP tooling
- Automated code generation assistants

---

## AI Agent Rules

All AI agents interacting with this repository should follow these rules:

### Architectural Consistency

Agents MUST:
- Respect MVVM architecture
- Preserve folder organization
- Avoid tight coupling
- Avoid business logic inside widgets
- Avoid direct Supabase calls inside UI layers

---

### State Management Rules

Agents MUST:
- Use Riverpod providers
- Keep ViewModels responsible for UI state
- Avoid setState for feature state management
- Keep state immutable when possible

---

### Code Quality Rules

Agents MUST:
- Generate strongly typed code
- Prefer composition over inheritance
- Avoid duplicated logic
- Prefer reusable widgets
- Respect lint rules
- Generate documentation comments when necessary

---

### UI Rules

Agents MUST:
- Follow the design system
- Respect spacing tokens
- Use responsive layouts
- Support light/dark mode
- Avoid hardcoded values

---

### Backend Rules

Agents MUST:
- Use repositories for data access
- Keep Supabase isolated from presentation layer
- Respect Row Level Security patterns
- Use DTO mapping when appropriate

---

# 5. Tech Stack

## Frontend

- Flutter
- Dart

## Architecture

- MVVM
- Feature-first architecture
- Repository Pattern

## State Management

- flutter_riverpod

## Routing

- go_router

## Backend

- Supabase
- PostgreSQL
- Realtime
- Storage
- Edge Functions

## Code Generation

- freezed
- json_serializable
- build_runner

## UI

- flex_color_scheme
- google_fonts
- responsive_framework

## Utilities

- intl
- logger
- equatable

---

# 6. Folder Structure

```txt
lib/
├── app/
│   ├── config/
│   ├── core/
│   ├── routes/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── restaurants/
│   ├── products/
│   ├── cart/
│   ├── checkout/
│   ├── orders/
│   ├── delivery/
│   ├── profile/
│   └── analytics/
│
├── shared/
│   ├── models/
│   ├── extensions/
│   ├── constants/
│   ├── utils/
│   └── widgets/
│
└── main.dart
```

---

# 7. Feature Structure

Each feature should follow this structure:

```txt
feature/
├── data/
│   ├── datasources/
│   ├── dto/
│   ├── repositories/
│   └── mappers/
│
├── domain/
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── states/
│
└── viewmodels/
```

---

# 8. MVVM Pattern

## Model

Represents immutable business entities.

Example:
- User
- Restaurant
- Product
- Order

---

## View

Flutter UI only.

Views should:
- Render state
- Trigger actions
- Avoid business rules

---

## ViewModel

Responsible for:
- UI state
- Use case orchestration
- Loading/error states
- User interactions

---

## Repository

Responsible for:
- Supabase communication
- Data abstraction
- DTO mapping
- Query organization

---

# 9. State Management Strategy

## Recommended Pattern

```txt
UI
↓
ViewModel
↓
Repository
↓
Datasource
↓
Supabase
```

---

## Rules

- No direct Supabase calls inside widgets
- No business logic inside UI
- No repository logic inside ViewModels

---

# 10. Design System

The project must implement a centralized design system.

## Tokens

- AppSpacing
- AppRadius
- AppSizes
- AppTypography
- AppDurations

---

## Theme Requirements

- Light theme
- Dark theme
- Material 3
- Semantic colors
- Responsive typography

---

# 11. Responsive Strategy

The app must support:

- Mobile
- Tablet
- Web

Responsive behavior should be planned from the beginning.

---

# 12. Environment Strategy

## Environments

- Development
- Production

---

## Environment Variables

```txt
SUPABASE_URL
SUPABASE_ANON_KEY
APP_ENV
API_BASE_URL
```

---

## Rules

Environment files must NEVER be committed with secrets.

---

# 13. Supabase Architecture

## Services Used

- Auth
- Database
- Realtime
- Storage
- Edge Functions

---

# 14. Database Modeling

## Main Tables

```txt
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

---

# 15. Realtime Features

## Planned Realtime Flows

- Order tracking
- Driver updates
- Restaurant order queue
- Notification system

---

# 16. Authentication Strategy

## Supported Auth

- Email/password
- Google OAuth

---

## Roles

```txt
customer
restaurant_owner
driver
admin
```

---

# 17. Security

## Mandatory Security Rules

- RLS enabled on all tables
- Auth required for protected routes
- Role-based authorization
- Input validation
- Secure storage handling

---

# 18. Error Handling

The application must support:

- Network errors
- API failures
- Empty states
- Loading states
- Retry mechanisms

---

# 19. Logging Strategy

## Logging Layers

- UI logs
- Repository logs
- Network logs
- Error logs

Use structured logging when possible.

---

# 20. Testing Strategy

## Minimum Required Tests

### Unit Tests
- ViewModels
- Services
- Repositories

### Widget Tests
- Critical screens
- User flows

---

# 21. Git Strategy

## Branches

```txt
main
develop
feature/*
hotfix/*
release/*
```

---

# 22. Commit Convention

## Conventional Commits

Examples:

```txt
feat(auth): add login flow
fix(cart): correct total calculation
refactor(orders): improve repository structure
```

---

# 23. Versioning Strategy

Semantic Versioning:

```txt
MAJOR.MINOR.PATCH
```

Example:

```txt
1.0.0
```

---

# 24. CI/CD

## GitHub Actions Goals

- Flutter analyze
- Run tests
- Build APK
- Build Web
- Lint validation

---

# 25. Documentation Strategy

## Required Documentation

```txt
README.md
CHANGELOG.md
CONTRIBUTING.md
SECURITY.md
```

---

# 26. MVP Roadmap

# MVP 1

## Customer App

- Authentication
- Restaurant listing
- Product listing
- Cart
- Checkout
- Orders

---

# MVP 2

## Restaurant Module

- Product CRUD
- Order management
- Realtime queue

---

# MVP 3

## Driver Module

- Delivery tracking
- Route visualization
- Order status

---

# MVP 4

## Engineering Polish

- Tests
- Analytics
- Crash reporting
- CI/CD
- Performance optimization

---

# 27. Coding Standards

## Naming

### Files

```txt
snake_case.dart
```

### Classes

```txt
PascalCase
```

### Variables

```txt
camelCase
```

---

# 28. Performance Guidelines

Agents should:
- Avoid unnecessary rebuilds
- Prefer const constructors
- Use pagination
- Cache network images
- Minimize widget tree complexity

---

# 29. Anti-Patterns

The following are prohibited:

- Massive widgets
- Business logic inside UI
- Global mutable state
- Hardcoded strings
- Tight coupling
- Direct database access in pages

---

# 30. Future Scalability

The architecture should support future additions:

- Payments
- Coupons
- AI recommendations
- Chat system
- Push notifications
- Offline-first support

---

# 31. Portfolio Positioning

This project is intended to function as:

- Portfolio flagship
- Engineering showcase
- Recruiter attraction asset
- Architecture demonstration
- Fullstack Flutter case study

---

# 32. Final Engineering Goal

The final objective is NOT only to build a food delivery application.

The real objective is to demonstrate:

- Software architecture maturity
- Engineering discipline
- Backend integration expertise
- Scalable Flutter development
- Professional development workflows
- AI-assisted engineering capabilities

---

# 33. Development Mindset

This project should be treated as a real startup simulation.

All engineering decisions should prioritize:

- Scalability
- Maintainability
- Readability
- Professionalism
- Reusability
- Testability

---

# 34. Final Notes for AI Agents

When generating code:

- Prefer maintainable solutions over quick hacks
- Respect architectural boundaries
- Keep files focused and small
- Avoid unnecessary abstractions
- Favor clarity over cleverness
- Maintain consistency across the project

The repository should remain understandable and scalable for long-term evolution.