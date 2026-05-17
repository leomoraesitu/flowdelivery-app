# FlowDelivery AI Context — Design System

## Source of Truth

Primary docs:

- `docs/design-system/DESIGN_SYSTEM.md`
- `docs/design-system/TOKENS.md`

## Design Principles

FlowDelivery UI must prioritize:

- consistent spacing
- semantic colors
- accessible contrast
- responsive layouts
- reusable components
- Material 3 alignment
- light and dark theme support

## Token Categories

Use centralized tokens for:

- spacing
- radius
- size
- duration
- color roles
- typography roles

## Spacing Tokens

```text
xxs: 4
xs: 8
sm: 12
md: 16
lg: 24
xl: 32
xxl: 48
```

## Radius Tokens

```text
none: 0
sm: 4
md: 8
lg: 12
xl: 16
pill: 999
```

## Color Rules

Use semantic color roles instead of hardcoded usage-specific colors.

Expected roles:

- primary
- secondary
- background
- surface
- surface-variant
- success
- warning
- error
- info
- outline
- text-primary
- text-secondary
- text-disabled

## Component Rules

- Feature-specific widgets stay inside the feature.
- Generic reusable widgets belong in shared or app-level UI folders.
- Avoid arbitrary visual values when a token exists.
- Keep component APIs small and explicit.
