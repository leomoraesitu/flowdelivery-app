# FlowDelivery — Branching Strategy

# Objective

Define the Git workflow and branch conventions used in the project.

---

# Main Branches

## main
Production branch.

Rules:
- stable only
- release-ready code
- protected branch

---

## develop
Integration branch.

Rules:
- validated features
- sprint integration

---

## dev
Development validation environment.

Used for:
- homologation
- testing
- temporary validations

---

## flutterflow
FlutterFlow synchronization branch.

Rules:
- avoid direct manual changes
- receive generated updates

---

# Branch Naming Convention

## Features

```txt
feat/feature-name
```
Example:
```txt
feat/authentication-flow
```
---
## Fixes
```txt
fix/problem-name
```
Example:
```txt
fix/cart-state-bug
```
---
## Docs
```txt
docs/document-name
```
Example:
```txt
docs/project-foundation
```
---
## Refactors
```txt
refactor/module-name
```
---
## Chores
```txt
chore/task-name
```
---
# Workflow
## Feature Flow
```txt
develop
   └── feat/feature-name
            └── PR → develop
```
---
## Release Flow
```txt
develop
   └── main
```
---   
## Hotfix Flow
```txt
main
   └── fix/hotfix-name
            └── main
            └── develop
```
---
## Pull Request Rules
Every PR must contain:
- objective
- scope
- screenshots
- technical notes
- checklist
---
## Merge Strategy
Recommended:
- Squash and Merge

Benefits:

- cleaner history
- simplified changelog
- easier rollback
---

## Commit Strategy

Use:

- Conventional Commits

Examples:
```txt
feat: implement authentication flow
fix: resolve cart persistence issue
docs: add mvvm architecture guide
```
---
## AI Governance

Codex rules:

- never commit automatically
- never merge automatically
- never overwrite files without confirmation
- explain architectural decisions