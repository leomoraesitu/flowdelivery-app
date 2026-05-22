# FlowDelivery — Definition of Done

# Objective

Define mandatory completion criteria for all backlog items.

---

# General Rules

A task can only move to DONE when all criteria are satisfied.

---

# Mandatory Criteria

## Engineering

- [ ] Build successful
- [ ] Analyzer without errors
- [ ] No critical warnings
- [ ] Formatting applied

---

## Architecture

- [ ] MVVM respected
- [ ] Folder structure respected
- [ ] Naming conventions respected

---

## QA

- [ ] Tests executed
- [ ] Main flow validated
- [ ] No blocking bugs

---

## Documentation

- [ ] Documentation updated
- [ ] Technical decisions documented
- [ ] Screenshots attached if necessary

Use the exact Localization Guard Checklist below for any task that touches user-facing text.

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key
- [ ] UI reads strings through `AppLocalizations`
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`
- [ ] New placeholders and route placeholders are covered by the guard test

---

## Git

- [ ] Conventional Commit applied
- [ ] Branch synchronized
- [ ] Pull Request approved

---

# Release Criteria

For release tasks:

- [ ] Version updated
- [ ] Changelog updated
- [ ] QA evidence attached
- [ ] Release notes created

---

# AI Governance

AI-generated code must:
- be reviewed manually
- be explained
- preserve standards
- avoid destructive actions