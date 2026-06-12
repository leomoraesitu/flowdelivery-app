# Changelog

All notable changes to FlowDelivery will be documented in this file.

The project follows Semantic Versioning and Conventional Commits.

## [Unreleased]

### Added

- GitHub Pages web deployment pipeline (`.github/workflows/deploy-web.yml`): tag-triggered (`v*.*.*`) Flutter web build with `--base-href "/flowdelivery-app/"`, Supabase dart-defines injected from Actions variables/secret, and a `404.html` SPA fallback for deep-links and refresh.
- Live web demo published at https://leomoraesitu.github.io/flowdelivery-app/ serving the v0.2.0 read-only catalog browsing build.

### Fixed

- Password recovery redirect now preserves the GitHub Pages project subpath so reset links resolve under `/flowdelivery-app/reset-password` (covered by `test/app/routes/auth_recovery_redirect_test.dart`).

### Changed

- GitHub Pages deploy actions pinned to Node 24 majors (`checkout@v6`, `upload-pages-artifact@v5`, `deploy-pages@v5`).

## [0.2.0] - 2026-06-11

### Added

- Read-only catalog browsing experience built across Sprints 2-8 on top of the Sprint 1 authentication foundation, also published as a live web demo at https://leomoraesitu.github.io/flowdelivery-app/.
- Authenticated Home feed with remote Supabase-backed restaurants, categories, and promotions.
- Home discovery interactions: search and category filtering with localized no-match recovery.
- Restaurant details with remote menu categories and items.
- Read-only product details loaded by stable product ID.
- Deterministic catalog demo coverage for all four seeded restaurants (13 menu categories, 16 menu items).
- Storage-backed catalog media served from the public-read `catalog-media` bucket through a shared URL resolver and shared media renderer.
- PT-BR / EN localization via ARB + generated `AppLocalizations`.

### Changed

- Theme Guard and Localization Guard enforced across all presentation slices.
- README, sprint records, release docs, and project memory reconciled with the read-only catalog browsing milestone.

## [0.1.1] - 2026-06-01

### Added

- Sprint 1 Authentication Foundation completed and validated.
- Password recovery flow, PT-BR auth localization, Riverpod wiring, GoRouter auth guard, and MVVM/Clean Architecture auth boundaries stabilized.

### Changed

- README, bootstrap documentation, sprint records, and project memory were updated to reflect Sprint 1 closure and the next governance slice.
- Google Fonts files are bundled locally so Android release builds render the configured typography without runtime downloads.

### Fixed

- Android release builds now declare internet access, allowing Supabase authentication requests outside debug and profile modes.

## [0.1.0] - Sprint 0

### Added

- Initial Flutter project foundation.
- Project management documentation.
- Trello workflow templates and mappings.
- Conventional commits documentation.
- Branching strategy documentation.
- Sprint 0 governance baseline.
- AI-native context, memory, plans and workflow structure.
- Initial Material 3 theme structure with light and dark placeholders.
- Design token constants for spacing, radius, size, duration and fonts.
- GitHub labels aligned with project conventions.

### Changed

- Sprint 0 marked complete after Trello, GitHub label and governance reconciliation.
- README and bootstrap documentation aligned with the current implemented stack.
