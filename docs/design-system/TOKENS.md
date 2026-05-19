# FlowDelivery — Design Tokens

## Objective

Define the token categories that will guide the Flutter theme implementation.

## Spacing

```text
xxs: 4
xs: 8
sm: 12
md: 16
lg: 24
xl: 32
xxl: 48
```

## Radius

```text
none: 0
sm: 4
md: 8
lg: 12
xl: 16
pill: 999
```

## Size

```text
icon-sm: 16
icon-md: 24
icon-lg: 32
touch-target: 48
```

## Duration

```text
fast: 150ms
normal: 250ms
slow: 400ms
```

## Color Roles

```text
primary
secondary
background
surface
surface-variant
success
warning
error
info
outline
text-primary
text-secondary
text-disabled
```

## Usage Convention

Widgets should use tokens through the closest semantic API available.

### Colors

Prefer `Theme.of(context).colorScheme` for semantic UI colors.

Examples:

- `Theme.of(context).colorScheme.primary`
- `Theme.of(context).colorScheme.surface`
- `Theme.of(context).colorScheme.onSurface`
- `Theme.of(context).colorScheme.error`

Avoid hardcoded `Color(0x...)` values inside widgets.

`AppLightColors` and `AppDarkColors` are theme implementation details. Use them
mainly inside `lib/app/theme` when building `ThemeData`, `ColorScheme`, or
future theme extensions.

Status colors such as `success`, `warning`, and `info` may be used by shared
components until the project introduces a dedicated `ThemeExtension` for them.

### Spacing, Radius, Size, and Duration

Use token classes for layout and interaction values:

- `AppSpacing` for gaps, padding, and margins.
- `AppRadius` for border radius.
- `AppSizes` for icons and touch targets.
- `AppDurations` for animations and transitions.

Avoid magic numbers such as `8`, `16`, `24`, or `250` in widgets when an
equivalent token exists.

### Feature Widgets

Feature widgets should:

- read semantic colors from `Theme.of(context)`;
- use spacing/radius/size/duration tokens for layout values;
- avoid depending directly on light or dark color palettes;
- avoid creating feature-specific visual constants unless the value is truly
  local to that component.

## Implementation Note

Token names are stable contracts. Flutter constants can be introduced later under `lib/app/theme` or `lib/shared/constants`.
