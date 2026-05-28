# FlowDelivery — Design System

## Objective

Define the visual and interaction foundation for FlowDelivery.

## Principles

- Consistent spacing
- Semantic colors
- Accessible contrast
- Responsive layouts
- Reusable components
- Material 3 alignment
- Light and dark theme support

## Core Areas

### Color

Colors should be semantic instead of hardcoded by usage.

Examples:

- primary
- secondary
- surface
- background
- success
- warning
- error
- info

### Typography

Typography must support clear hierarchy:

- display
- headline
- title
- body
- label

Current font families in app theme:

- Primary: Plus Jakarta Sans
- Secondary: Inter
- Mono: Space Grotesk

Implementation reference:

- `lib/app/theme/app_tokens.dart` (`AppFonts`)
- `lib/app/theme/app_theme.dart` (ThemeData/TextTheme application)

### Spacing

Spacing should use tokens instead of arbitrary numbers.

### Radius

Radius values should be centralized and reused.

### Components

Reusable components should live in shared or app-level UI folders when they are not feature-specific.

### Language and Copy

User-facing copy must not be hardcoded in widgets, pages, or route placeholders.

Current copy source of truth:

- `lib/l10n/app_pt.arb`
- `lib/l10n/app_pt_BR.arb`
- `lib/l10n/app_en.arb`

Localization pipeline:

- `pubspec.yaml` enables Flutter code generation for localization.
- `l10n.yaml` configures `gen-l10n`.
- UI should consume generated strings via `AppLocalizations`.

Guardrail:

- New placeholders and new features must introduce user-facing copy through ARB files before adding UI code.
- Data and domain layers should not localize text directly; they should expose failure codes or neutral values that presentation maps to localized copy.

Current app locale setup:

- `lib/app/app.dart` sets `Locale('pt', 'BR')` as default and configures Flutter localization delegates.

## Token Usage

The official token usage convention is documented in `docs/design-system/TOKENS.md`.

In short:

- use `Theme.of(context).colorScheme` for semantic colors in widgets;
- use token classes for spacing, radius, size, and duration values;
- keep light and dark palette constants inside theme implementation code.

## Sprint 0 Scope

Sprint 0 defines the design system contract. Full component implementation can happen incrementally.
