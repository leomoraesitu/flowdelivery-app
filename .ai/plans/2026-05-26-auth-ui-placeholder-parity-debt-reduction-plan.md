# Auth UI Placeholder Parity Debt Reduction Plan

## Objective

Preserve the prototype-aligned auth UI while preventing visual placeholders from being treated as implemented authentication capabilities.

## Current Problem

The auth UI intentionally includes prototype-aligned affordances such as social sign-in buttons and a reports tab label. These elements are useful for visual parity, but they can create scope confusion if future work treats them as real features without an approved implementation plan.

## Scope

- Add widget coverage proving social auth controls are visible but disabled.
- Add widget coverage proving the reports tab is visual copy, not a navigation action.
- Update technical debt memory to reflect the new executable guard.

## Out of Scope

- Implementing Google or Apple sign-in.
- Implementing reports navigation.
- Changing the auth visual layout.
- Performing pixel-perfect visual regression testing.

## Validation

- Run `test/features/auth/presentation/auth_pages_test.dart`.
- Keep existing auth page tests green.

## Remaining Monitoring Rule

Future auth UI work may preserve prototype affordances only when tests or documentation make their capability status explicit. A visual placeholder must either remain disabled/non-interactive or be promoted through an approved feature plan with repository, routing, localization, and focused tests.
