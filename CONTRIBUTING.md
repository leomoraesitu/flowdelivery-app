# Contributing to FlowDelivery

## Objective

Define the contribution workflow for FlowDelivery.

## Branching

Use the branch strategy documented in:

```text
docs/project-management/BRANCHING_STRATEGY.md
```

## Commits

Use Conventional Commits:

```text
type(scope): description
```

Example:

```text
feat(auth): add login flow
```

## Pull Requests

Every pull request should include:

- objective
- scope
- validation evidence
- screenshots when UI changes
- risk notes when applicable

## Quality Gates

Before requesting review, run:

```bash
flutter analyze
flutter test
```

## AI-Assisted Work

AI-generated changes must be reviewed by the contributor before merge.
