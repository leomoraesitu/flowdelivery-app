# FlowDelivery — QA Strategy

## Objective

Define the baseline quality strategy for Sprint 0 and future development.

## Validation Layers

### Static Analysis

Run:

```bash
flutter analyze
```

Expected result:

- no analyzer errors
- no critical warnings

### Automated Tests

Run:

```bash
flutter test
```

Expected result:

- all tests pass

### Manual QA

Manual QA should validate:

- main user flow
- loading states
- empty states
- error states
- responsive behavior when applicable
- external-provider behavior when applicable (for auth recovery, include
	inbox/email-provider deliverability on a non-local QA mailbox)

## Evidence

For UI tasks, attach evidence when useful:

- screenshots
- screen recordings
- notes about tested devices

## Definition of Done Alignment

A task should not move to Done unless the applicable criteria in `docs/project-management/DEFINITION_OF_DONE.md` are satisfied.
