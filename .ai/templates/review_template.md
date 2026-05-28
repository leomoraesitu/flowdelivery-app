# Review Template

## Findings

- Severity — file:line — issue and impact

## Open Questions

## Suggested Improvements

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key
- [ ] UI reads strings through `AppLocalizations`
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`
- [ ] New placeholders and route placeholders are covered by the guard test

## Theme Guard Checklist

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`)
- [ ] No `Color(0x...)` hardcoded values in feature presentation code
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside `lib/app/theme`
- [ ] Visual hardcoded guard test is updated when new UI patterns are introduced

## Validation

## Residual Risk
