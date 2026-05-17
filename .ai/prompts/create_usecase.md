# Create Use Case Prompt

## Objective

Create a focused use case or domain service for FlowDelivery when business logic should not live in UI, ViewModels or repositories.

## Required Context

Read before acting:

- `.ai/context/architecture.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/coding_standards.md`

## When to Create a Use Case

Create a use case when logic:

- coordinates multiple repositories
- applies domain rules
- is reused by multiple ViewModels
- is complex enough to test independently
- should remain independent from Flutter widgets

Do not create a use case for simple repository pass-through calls.

## Instructions

1. Inspect existing domain services before adding a new abstraction.
2. Give the use case one clear responsibility.
3. Inject repositories or services through the constructor.
4. Return typed domain results.
5. Keep UI state formatting outside the use case.

## Expected Deliverables

- use case or domain service file
- focused method API
- updated ViewModel integration if needed
- unit tests when practical

## Validation Checklist

- [ ] Use case has one clear responsibility
- [ ] No Flutter widget dependency
- [ ] No raw Supabase dependency
- [ ] Logic is testable in isolation
