# Theme Guard Future Slices Debt Reduction Plan

## Objective

Keep Theme Guard enforcement ready for future `home`, `feed`, and `cart` presentation slices without creating placeholder modules before those features are approved.

## Current State

The repository does not currently contain `home`, `feed`, or `cart` feature slices under `lib/features` or `test/features`.

The active Theme Guard is already global for feature presentation code:

- `test/app/theme/no_hardcoded_visual_values_test.dart`
- target: `lib/features/**/presentation/**/*.dart`

This means future feature slices will be checked as soon as they introduce presentation files.

## Scope

- Record the current audit result.
- Keep the debt in monitoring instead of creating empty feature folders.
- Validate that the existing visual hardcoded guard remains green.

## Out of Scope

- Creating `home`, `feed`, or `cart` modules.
- Designing new UI.
- Expanding Theme Guard rules beyond the current forbidden patterns.
- Performing visual regression or screenshot testing.

## Validation

- Confirm no current `home`, `feed`, or `cart` feature slices exist.
- Run `test/app/theme/no_hardcoded_visual_values_test.dart`.

## Remaining Monitoring Rule

When a future `home`, `feed`, or `cart` presentation slice is approved, it must use semantic theme APIs and app tokens from the first implementation task. The global Theme Guard must remain green before the slice is considered complete.
