import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

final _cartPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

const _burger = ProductDetails(
  id: 'signature_truffle',
  restaurantId: 'burger_artisan_collective',
  categoryId: 'burgers',
  name: 'The Signature Truffle',
  description: 'Wagyu beef with truffle aioli.',
  imageAssetPath: 'assets/images/signature-truffle.png',
  priceInCents: 1850,
);

const _fries = ProductDetails(
  id: 'sweet_potato_crisps',
  restaurantId: 'burger_artisan_collective',
  categoryId: 'sides',
  name: 'Sweet Potato Crisps',
  description: 'Crispy sweet potato with sea salt.',
  imageAssetPath: 'assets/images/sweet-potato-crisps.png',
  priceInCents: 650,
);

String _formatCents(int cents) {
  return NumberFormat.simpleCurrency(locale: 'pt-BR').format(cents / 100);
}

Widget _buildTestApp({
  required ProviderContainer container,
  VoidCallback? onExploreRestaurants,
  VoidCallback? onProceedToCheckout,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: _cartPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: CartPage(
        onExploreRestaurants: onExploreRestaurants,
        onProceedToCheckout: onProceedToCheckout,
      ),
    ),
  );
}

void main() {
  group('CartPage', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    testWidgets(
      'renders the localized empty state with a working explore action',
      (tester) async {
        var exploreTapped = false;

        await tester.pumpWidget(
          _buildTestApp(
            container: container,
            onExploreRestaurants: () => exploreTapped = true,
          ),
        );
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CartPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.cartTitle), findsOneWidget);
        expect(find.text(l10n.cartEmptyTitle), findsOneWidget);
        expect(find.text(l10n.cartEmptyMessage), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsNothing);

        await tester.tap(find.widgetWithText(FilledButton, l10n.cartEmptyAction));
        await tester.pumpAndSettle();

        expect(exploreTapped, isTrue);
      },
    );

    testWidgets(
      'renders items, formatted prices, pluralized count, and total',
      (tester) async {
        container.read(cartProvider.notifier)
          ..addItem(_burger)
          ..addItem(_burger)
          ..addItem(_fries);

        await tester.pumpWidget(_buildTestApp(container: container));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CartPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(_burger.name), findsOneWidget);
        expect(find.text(_fries.name), findsOneWidget);
        expect(find.text(l10n.cartItemCount(3)), findsOneWidget);
        expect(find.text(_formatCents(_burger.priceInCents)), findsOneWidget);
        expect(
          find.text(_formatCents(_burger.priceInCents * 2)),
          findsOneWidget,
        );
        expect(find.text(l10n.cartTotal), findsOneWidget);
        expect(
          find.text(_formatCents(_burger.priceInCents * 2 + _fries.priceInCents)),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(FilledButton, l10n.cartProceedToCheckout),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'checkout CTA is enabled and triggers the navigation callback',
      (tester) async {
        var checkoutRequested = 0;
        container.read(cartProvider.notifier).addItem(_burger);

        await tester.pumpWidget(
          _buildTestApp(
            container: container,
            onProceedToCheckout: () => checkoutRequested++,
          ),
        );
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CartPage));
        final l10n = AppLocalizations.of(context);
        final checkoutButtonFinder = find.widgetWithText(
          FilledButton,
          l10n.cartProceedToCheckout,
        );

        expect(tester.widget<FilledButton>(checkoutButtonFinder).enabled, isTrue);

        await tester.ensureVisible(checkoutButtonFinder);
        await tester.tap(checkoutButtonFinder);
        await tester.pumpAndSettle();

        expect(checkoutRequested, 1);
      },
    );

    testWidgets('quantity controls update the cart state', (tester) async {
      container.read(cartProvider.notifier).addItem(_burger);

      await tester.pumpWidget(_buildTestApp(container: container));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CartPage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(find.byTooltip(l10n.cartIncreaseQuantity));
      await tester.pumpAndSettle();

      expect(container.read(cartProvider).itemCount, 2);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byTooltip(l10n.cartDecreaseQuantity));
      await tester.pumpAndSettle();

      expect(container.read(cartProvider).itemCount, 1);
    });

    testWidgets('decreasing a single-quantity item removes it', (tester) async {
      container.read(cartProvider.notifier).addItem(_burger);

      await tester.pumpWidget(_buildTestApp(container: container));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CartPage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(find.byTooltip(l10n.cartRemoveItem));
      await tester.pumpAndSettle();

      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(find.text(l10n.cartEmptyTitle), findsOneWidget);
    });

    testWidgets('clear action empties the cart', (tester) async {
      container.read(cartProvider.notifier)
        ..addItem(_burger)
        ..addItem(_fries);

      await tester.pumpWidget(_buildTestApp(container: container));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CartPage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(find.byTooltip(l10n.cartClearAction));
      await tester.pumpAndSettle();

      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(find.text(l10n.cartEmptyTitle), findsOneWidget);
    });
  });
}
