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

## Implementation Note

Token names are stable contracts. Flutter constants can be introduced later under `lib/app/theme` or `lib/shared/constants`.
