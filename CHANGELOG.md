# Changelog

All notable changes to FlowDelivery will be documented in this file.

The project follows Semantic Versioning and Conventional Commits.

## [Unreleased]

No unreleased changes yet.

## [0.4.0] - 2026-07-07

### Added

- Persisted checkout flow (Sprint 10): authenticated users can review their
  cart on `/checkout`, confirm an order, and receive a real persisted order
  ID.
- First complete write path in the app:
  `CheckoutPage -> CheckoutViewModel -> OrderRepository ->
  OrderRemoteDatasource -> Supabase RPC`.
- Supabase `orders` and `order_items` foundation with explicit grants, RLS
  scoped to `auth.uid()`, and an atomic `create_order` SECURITY INVOKER
  function.
- Pure-Dart checkout domain contracts: `OrderDraft`, `PlacedOrder`,
  `OrderRepository`, and neutral order-placement failure codes.
- Checkout data layer with RPC datasource, DTO parsing, repository
  implementation, and app-level dependency composition.
- `CheckoutViewModel` with idle, submitting, success, and failure states;
  double-submit protection; and single cart clear on success.
- Protected `/checkout` route plus enabled cart checkout CTA.
- Localized checkout UI with order summary, demo delivery address, static
  cash-on-delivery payment method, retry feedback, and success confirmation.
- 18 checkout localization keys across pt_BR, pt, and en, plus generated
  `AppLocalizations` accessors.
- Focused checkout datasource, repository, ViewModel, widget, cart CTA,
  router, localization, theme, and Trello guard coverage.
- Android release APK artifact for `v0.4.0`, with SHA-1 and SHA-256 checksum
  assets attached to the GitHub Release.

### Changed

- Cart checkout action now navigates to the real checkout flow instead of
  remaining a placeholder.
- Supabase setup documentation now includes the orders migration runbook and
  write-path precedent.
- Sprint 10 docs, project memory, and technical debt notes reconciled with
  the persisted checkout milestone.

### Known Limitations

- Payment remains a static "cash on delivery" demo method.
- Delivery address is still a localized demo placeholder; persisted profile
  addresses are deferred.
- Order history, order tracking, Realtime status updates, dynamic delivery
  fees, coupons, and payment gateway integration remain future slices.
- Cart state remains session-local until a separate persistence slice is
  approved.

## [0.3.0] - 2026-07-03

### Added

- Session-local shopping cart (Sprint 9): immutable `CartItem`/`Cart` domain aggregates with a `CartNotifier` (`Notifier<Cart>`) domain boundary — no repository/datasource; persistence deferred to the Checkout slice.
- Protected `/cart` route and `CartPage` with localized empty/non-empty states, quantity controls (remove affordance at quantity 1), per-item subtotal, running total, and a visible-but-disabled checkout CTA with placeholder copy.
- "Add to cart" action on product details, switching to in-cart quantity controls through a derived per-product selector (`cartItemProvider`).
- Single-restaurant constraint enforced in the domain via the `CartAddResult` return signal, surfaced as a localized confirmation dialog.
- Cart item-count badge (`Badge` M3, hidden at zero) on restaurant and product hero headers, navigating to `/cart`.
- Shared `formatPriceInCents` utility in `lib/shared/utils/price_formatter.dart`, replacing duplicated price formatting in restaurant/product details sections.
- 21 `cart*` localization keys (pt_BR template, pt, en) including an ICU plural item count.
- Recorded cart demo gif in `docs/ux/demo/` embedded in the README.
- GitHub Pages web deployment pipeline (`.github/workflows/deploy-web.yml`): tag-triggered (`v*.*.*`) Flutter web build with `--base-href "/flowdelivery-app/"`, Supabase dart-defines injected from Actions variables/secret, and a `404.html` SPA fallback for deep-links and refresh.
- Live web demo published at https://leomoraesitu.github.io/flowdelivery-app/ (initially serving the v0.2.0 read-only catalog build, updated to v0.3.0 with this release).

### Fixed

- Password recovery redirect now preserves the GitHub Pages project subpath so reset links resolve under `/flowdelivery-app/reset-password` (covered by `test/app/routes/auth_recovery_redirect_test.dart`).
- GitHub Pages environment now allows `v*` tag deployments (deployment branch policy), so tag-triggered deploys run without manual intervention.

### Changed

- GitHub Pages deploy actions pinned to Node 24 majors (`checkout@v6`, `upload-pages-artifact@v5`, `deploy-pages@v5`).
- AI workflow scripts converted from PowerShell to bash for macOS (PowerShell variants retained for Windows); README command loop updated accordingly.
- README, routing conventions, and project bootstrap documentation reconciled with the implemented sprints 3-9 state (Supabase database/Storage surface, real route tree, cart status).

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
