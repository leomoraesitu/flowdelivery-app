import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:flowdelivery_app/features/product_details/presentation/pages/product_details_page.dart';
import 'package:flowdelivery_app/features/product_details/presentation/providers/product_details_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _productDetailsPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

const _product = ProductDetails(
  id: 'signature_truffle',
  restaurantId: 'burger_artisan_collective',
  categoryId: 'burgers',
  name: 'The Signature Truffle',
  description: 'Wagyu beef with truffle aioli.',
  imageAssetPath: 'assets/images/signature-truffle.png',
  priceInCents: 1850,
);

Widget _buildTestApp({
  required String productId,
  List overrides = const [],
  VoidCallback? onBack,
  VoidCallback? onOpenCart,
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: _productDetailsPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProductDetailsPage(
        productId: productId,
        onBack: onBack,
        onOpenCart: onOpenCart,
      ),
    ),
  );
}

void main() {
  group('ProductDetailsPage', () {
    const productId = 'signature_truffle';

    testWidgets('renders loading state', (tester) async {
      final completer = Completer<ProductDetails?>();

      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() => completer.future),
            ),
          ],
        ),
      );
      await tester.idle();
      await tester.pump();

      final context = tester.element(find.byType(ProductDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.productDetailsLoadingStateTitle), findsOneWidget);
      expect(find.text(l10n.productDetailsLoadingStateMessage), findsOneWidget);
      expect(
        find.bySemanticsLabel(l10n.productDetailsLoadingStateSemanticLabel),
        findsOneWidget,
      );

      completer.complete(_product);
    });

    testWidgets('renders localized retryable error state', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          overrides: [
            productDetailsProvider(productId).overrideWith((ref) async {
              callCount++;
              throw Exception('boom');
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(ProductDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.productDetailsErrorStateTitle), findsOneWidget);
      expect(find.text(l10n.productDetailsErrorStateMessage), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, l10n.productDetailsRetryAction),
        findsOneWidget,
      );
      expect(callCount, greaterThan(0));
      final callCountBeforeRetry = callCount;

      await tester.tap(
        find.widgetWithText(FilledButton, l10n.productDetailsRetryAction),
      );
      await tester.pumpAndSettle();

      expect(callCount, greaterThan(callCountBeforeRetry));
    });

    testWidgets('renders localized not-found state for a missing product', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          productId: 'missing_product',
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() async => null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(ProductDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.productDetailsNotFoundStateTitle), findsOneWidget);
      expect(
        find.text(l10n.productDetailsNotFoundStateMessage),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OutlinedButton, l10n.productDetailsBackAction),
        findsOneWidget,
      );
    });

    testWidgets('renders product name and description on success', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() async => _product),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(_product.name), findsOneWidget);
      expect(find.text(_product.description), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders remote product media with localized semantics', (
      tester,
    ) async {
      const remoteProduct = ProductDetails(
        id: 'signature_truffle',
        restaurantId: 'burger_artisan_collective',
        categoryId: 'burgers',
        name: 'The Signature Truffle',
        description: 'Wagyu beef with truffle aioli.',
        imageAssetPath: 'https://example.com/signature-truffle.webp',
        priceInCents: 1850,
      );

      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() async => remoteProduct),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(ProductDetailsPage));
      final expectedLabel = AppLocalizations.of(
        context,
      ).productDetailsImageSemanticLabel(remoteProduct.name);
      final image = tester.widget<Image>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is NetworkImage &&
              (widget.image as NetworkImage).url ==
                  remoteProduct.imageAssetPath,
        ),
      );

      expect(image.semanticLabel, expectedLabel);
      expect(image.excludeFromSemantics, isFalse);
    });

    testWidgets('triggers onBack callback when back button is tapped', (
      tester,
    ) async {
      var backTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          onBack: () => backTapped = true,
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() async => _product),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(backTapped, isTrue);
    });
  });

  group('ProductDetailsPage cart integration', () {
    const productId = 'signature_truffle';

    const otherRestaurantProduct = ProductDetails(
      id: 'sushi_zen_omakase_sampler',
      restaurantId: 'sushi_zen',
      categoryId: 'rolls',
      name: 'Omakase Sampler',
      description: 'Chef selection of seasonal nigiri.',
      imageAssetPath: 'assets/images/omakase-sampler.png',
      priceInCents: 4200,
    );

    Future<AppLocalizations> pumpSuccessPage(
      WidgetTester tester, {
      VoidCallback? onOpenCart,
    }) async {
      await tester.pumpWidget(
        _buildTestApp(
          productId: productId,
          onOpenCart: onOpenCart,
          overrides: [
            productDetailsRepositoryProvider.overrideWithValue(
              _FakeProductDetailsRepository(() async => _product),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      return AppLocalizations.of(
        tester.element(find.byType(ProductDetailsPage)),
      );
    }

    ProviderContainer containerOf(WidgetTester tester) {
      return ProviderScope.containerOf(
        tester.element(find.byType(ProductDetailsPage)),
      );
    }

    // The cart action area sits below the tall product hero, outside the
    // default test viewport, so scroll to it before tapping.
    Future<void> tapVisible(WidgetTester tester, Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
    }

    testWidgets('shows the add-to-cart button when the product is not in '
        'the cart', (tester) async {
      final l10n = await pumpSuccessPage(tester);

      expect(
        find.widgetWithText(FilledButton, l10n.cartAddToCart),
        findsOneWidget,
      );
      expect(find.text(l10n.cartAlreadyInCart), findsNothing);
    });

    testWidgets('shows quantity controls when the product is in the cart', (
      tester,
    ) async {
      final l10n = await pumpSuccessPage(tester);

      await tapVisible(
        tester,
        find.widgetWithText(FilledButton, l10n.cartAddToCart),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.cartAlreadyInCart), findsOneWidget);
      expect(find.byTooltip(l10n.cartIncreaseQuantity), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, l10n.cartAddToCart),
        findsNothing,
      );

      await tapVisible(tester, find.byTooltip(l10n.cartIncreaseQuantity));
      await tester.pumpAndSettle();

      expect(containerOf(tester).read(cartProvider).itemCount, 2);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
      'cancelling the different-restaurant dialog keeps the current cart',
      (tester) async {
        final l10n = await pumpSuccessPage(tester);
        final container = containerOf(tester);
        container.read(cartProvider.notifier).addItem(otherRestaurantProduct);
        await tester.pumpAndSettle();

        await tapVisible(
          tester,
          find.widgetWithText(FilledButton, l10n.cartAddToCart),
        );
        await tester.pumpAndSettle();

        expect(find.text(l10n.cartDifferentRestaurantTitle), findsOneWidget);
        expect(find.text(l10n.cartDifferentRestaurantMessage), findsOneWidget);

        await tester.tap(
          find.widgetWithText(TextButton, l10n.cartDifferentRestaurantCancel),
        );
        await tester.pumpAndSettle();

        final cart = container.read(cartProvider);
        expect(cart.restaurantId, otherRestaurantProduct.restaurantId);
        expect(cart.itemCount, 1);
      },
    );

    testWidgets(
      'confirming the different-restaurant dialog clears the cart and adds '
      'the new item',
      (tester) async {
        final l10n = await pumpSuccessPage(tester);
        final container = containerOf(tester);
        container.read(cartProvider.notifier).addItem(otherRestaurantProduct);
        await tester.pumpAndSettle();

        await tapVisible(
          tester,
          find.widgetWithText(FilledButton, l10n.cartAddToCart),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            FilledButton,
            l10n.cartDifferentRestaurantConfirm,
          ),
        );
        await tester.pumpAndSettle();

        final cart = container.read(cartProvider);
        expect(cart.restaurantId, _product.restaurantId);
        expect(cart.itemCount, 1);
        expect(cart.items.first.productId, _product.id);
        expect(find.text(l10n.cartAlreadyInCart), findsOneWidget);
      },
    );

    testWidgets('hides the badge count on an empty cart and shows it after '
        'items are added', (tester) async {
      var cartOpened = false;
      final l10n = await pumpSuccessPage(
        tester,
        onOpenCart: () => cartOpened = true,
      );

      final emptyBadge = tester.widget<Badge>(find.byType(Badge));
      expect(emptyBadge.isLabelVisible, isFalse);

      await tapVisible(
        tester,
        find.widgetWithText(FilledButton, l10n.cartAddToCart),
      );
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byTooltip(l10n.cartIncreaseQuantity));
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue);
      expect(
        find.descendant(of: find.byType(Badge), matching: find.text('2')),
        findsOneWidget,
      );

      await tapVisible(tester, find.byTooltip(l10n.cartTitle));
      await tester.pumpAndSettle();

      expect(cartOpened, isTrue);
    });
  });
}

class _FakeProductDetailsRepository implements ProductDetailsRepository {
  const _FakeProductDetailsRepository(this.loader);

  final Future<ProductDetails?> Function() loader;

  @override
  Future<ProductDetails?> getProductDetails(String productId) {
    return loader();
  }
}
