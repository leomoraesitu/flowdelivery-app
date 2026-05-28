# FlowDelivery — Project Management Standard

## Objective

Define the governance, workflow, engineering standards and project management processes for the FlowDelivery application.

---

# Methodology

The project follows:

- Scrum
- Incremental Delivery
- Agile Development
- Continuous Documentation
- AI-Assisted Development
- GitFlow Simplified

---

# Core Principles

## Engineering First

Every feature must:
- follow architecture standards
- include documentation
- maintain scalability
- preserve maintainability

---

## Incremental Delivery

Development occurs through:
- Sprints
- Epics
- User Stories
- Continuous validation

---

## Documentation Driven

All important decisions must be documented.

Examples:
- architecture decisions
- environment setup
- workflows
- release process

---

## AI Governance

AI assistants must:
- propose before implementing
- explain architectural decisions
- never overwrite files automatically
- never delete files without confirmation
- never commit without approval
- keep ARB files and `AppLocalizations` as the source of truth for presentation copy

---

# Project Structure

```txt
docs/
lib/
assets/
supabase/
scripts/
test/
```
---

# Engineering Workflow

- Refinement
- Planning
- Architecture Validation
- Development
- Code Review
- QA
- Release
- Documentation Update

## Planning Rules

Any feature or planning artifact that introduces user-facing copy must:
- list the affected screens or flows
- confirm the ARB key strategy before implementation
- include the Localization Guard Checklist below before implementation

Any feature or planning artifact that introduces or changes user-facing UI styling must:
- list the affected screens or flows
- confirm semantic theme/token usage before implementation
- include the Theme Guard Checklist below before implementation

# Sprint Structure

Each sprint contains:
- objective
- scope
- acceptance criteria
- backlog items
- story points
- release goals

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key
- [ ] UI reads strings through `AppLocalizations`
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`
- [ ] ARB catalog parity guard remains green after copy changes
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs
- [ ] New placeholders and route placeholders are covered by the guard tests
- [ ] Generated localization freshness guard remains green after ARB changes once available

## Theme Guard Checklist

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`)
- [ ] No `Color(0x...)` hardcoded values in feature presentation code
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside `lib/app/theme`
- [ ] No direct `Colors.*` hardcoded usage in feature presentation when equivalent semantic `ColorScheme` roles exist
- [ ] Visual hardcoded guard test remains green after UI changes

# Required Standards

## Git
- Conventional Commits
- Pull Request validation
- Branch naming conventions

## Flutter
- MVVM
- Feature-first structure
- SOLID principles

## QA
- analyzer validation
- testing evidence
- screenshots

# Governance Documents

- PROJECT_MANAGEMENT_STANDARD.md
- TRELLO_WORKFLOW.md
- SPRINT_0.md
- DEFINITION_OF_DONE.md
- BRANCHING_STRATEGY.md

# Success Metrics

- Build stability
- Test coverage
- Sprint velocity
- Lead time
- Documentation quality
- Release consistency
