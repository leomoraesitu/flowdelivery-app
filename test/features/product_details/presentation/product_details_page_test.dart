import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
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
      home: ProductDetailsPage(productId: productId, onBack: onBack),
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
}

class _FakeProductDetailsRepository implements ProductDetailsRepository {
  const _FakeProductDetailsRepository(this.loader);

  final Future<ProductDetails?> Function() loader;

  @override
  Future<ProductDetails?> getProductDetails(String productId) {
    return loader();
  }
}
