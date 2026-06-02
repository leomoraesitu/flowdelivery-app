import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/repositories/restaurant_details_repository.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/pages/restaurant_details_page.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/providers/restaurant_details_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../restaurant_details_fixtures.dart';

final _restaurantDetailsPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

Widget _buildTestApp({
  required String restaurantId,
  List overrides = const [],
  VoidCallback? onBack,
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: _restaurantDetailsPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: RestaurantDetailsPage(
        restaurantId: restaurantId,
        onBack: onBack,
      ),
    ),
  );
}

void main() {
  group('RestaurantDetailsPage', () {
    const restaurantId = 'burger_artisan_collective';

    testWidgets('renders loading state', (tester) async {
      final completer = Completer<RestaurantDetails>();

      await tester.pumpWidget(
        _buildTestApp(
          restaurantId: restaurantId,
          overrides: [
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(() => completer.future),
            ),
          ],
        ),
      );
      await tester.idle();
      await tester.pump();

      final context = tester.element(find.byType(RestaurantDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.restaurantDetailsLoadingStateTitle), findsOneWidget);
      expect(
        find.text(l10n.restaurantDetailsLoadingStateMessage),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(l10n.restaurantDetailsLoadingStateSemanticLabel),
        findsOneWidget,
      );

      completer.complete(restaurantDetailsFixture);
    });

    testWidgets('renders localized retryable error state', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          restaurantId: restaurantId,
          overrides: [
            restaurantDetailsProvider(restaurantId).overrideWith((ref) async {
                callCount++;
                throw Exception('boom');
              }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(RestaurantDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.restaurantDetailsErrorStateTitle), findsOneWidget);
      expect(find.text(l10n.restaurantDetailsErrorStateMessage), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, l10n.restaurantDetailsRetryAction),
        findsOneWidget,
      );
      expect(callCount, greaterThan(0));
      final callCountBeforeRetry = callCount;

      await tester.tap(
        find.widgetWithText(FilledButton, l10n.restaurantDetailsRetryAction),
      );
      await tester.pumpAndSettle();

      expect(callCount, greaterThan(callCountBeforeRetry));
    });

    testWidgets('renders localized empty state', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          restaurantId: restaurantId,
          overrides: [
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(
                () async => RestaurantDetails(
                  id: restaurantDetailsFixture.id,
                  name: restaurantDetailsFixture.name,
                  imageAssetPath: restaurantDetailsFixture.imageAssetPath,
                  rating: restaurantDetailsFixture.rating,
                  deliveryTimeMinMinutes:
                      restaurantDetailsFixture.deliveryTimeMinMinutes,
                  deliveryTimeMaxMinutes:
                      restaurantDetailsFixture.deliveryTimeMaxMinutes,
                  cuisine: restaurantDetailsFixture.cuisine,
                  categories: const [],
                  items: const [],
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(RestaurantDetailsPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.restaurantDetailsEmptyStateTitle), findsOneWidget);
      expect(find.text(l10n.restaurantDetailsEmptyStateMessage), findsOneWidget);
    });

    testWidgets(
      'renders restaurant details, categories, and visible items on success',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(
            restaurantId: restaurantId,
            overrides: [
              restaurantDetailsRepositoryProvider.overrideWithValue(
                _FakeRestaurantDetailsRepository(
                  () async => restaurantDetailsFixture,
                ),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(restaurantDetailsFixture.name), findsOneWidget);
        expect(find.byType(ChoiceChip), findsNWidgets(3)); // Popular, Burgers, Sides

        for (final item in restaurantDetailsFixture.items) {
          expect(find.text(item.name), findsOneWidget);
        }
      },
    );

    testWidgets('category selection filters visible items', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          restaurantId: restaurantId,
          overrides: [
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(
                () async => restaurantDetailsFixture,
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(RestaurantDetailsPage));
      final l10n = AppLocalizations.of(context);

      // Select 'Sides' category
      final sidesCategory = restaurantDetailsFixture.categories[2];
      expect(sidesCategory.id, 'sides');

      await tester.tap(
        find.widgetWithText(ChoiceChip, l10n.restaurantDetailsCategorySides),
      );
      await tester.pumpAndSettle();

      expect(find.text('Truffle Fries'), findsOneWidget);
      expect(find.text('The Signature Truffle'), findsNothing);
      expect(find.text('Classic Cheeseburger'), findsNothing);

      // Select 'Burgers' category
      await tester.tap(
        find.widgetWithText(ChoiceChip, l10n.restaurantDetailsCategoryBurgers),
      );
      await tester.pumpAndSettle();

      expect(find.text('Truffle Fries'), findsNothing);
      expect(find.text('The Signature Truffle'), findsOneWidget);
      expect(find.text('Classic Cheeseburger'), findsOneWidget);
    });

    testWidgets('triggers onBack callback when back button is tapped', (
      tester,
    ) async {
      var backTapped = false;
      await tester.pumpWidget(
        _buildTestApp(
          restaurantId: restaurantId,
          onBack: () => backTapped = true,
          overrides: [
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(
                () async => restaurantDetailsFixture,
              ),
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

class _FakeRestaurantDetailsRepository implements RestaurantDetailsRepository {
  const _FakeRestaurantDetailsRepository(this.loader);

  final Future<RestaurantDetails> Function() loader;

  @override
  Future<RestaurantDetails> getRestaurantDetails(String restaurantId) {
    return loader();
  }
}
