import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flowdelivery_app/features/home/presentation/pages/home_page.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _homePageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

Widget _buildTestApp({List overrides = const []}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: _homePageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    ),
  );
}

void main() {
  group('HomePage', () {
    testWidgets('renders remote feed content from the repository success path', (
      tester,
    ) async {
      final remoteContent = await _loadRemoteContent();

      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _FakeHomeRepository(() async => remoteContent),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(context);

      expect(
        find.text(l10n.homeDeliveryAddressValue(remoteContent.deliveryAddress)),
        findsOneWidget,
      );
      expect(find.text('Pizza Prime'), findsOneWidget);
      expect(find.text('Forno Central'), findsOneWidget);
      expect(
        find.text(homeFeedFixtureContent.featuredRestaurants.first.name),
        findsNothing,
      );
      expect(find.text(l10n.homeLoadingStateTitle), findsNothing);
      expect(find.text(l10n.homeEmptyStateTitle), findsNothing);
      expect(find.text(l10n.homeErrorStateTitle), findsNothing);
    });

    testWidgets(
      'renders localized header, categories, promotion, restaurants, and selected home destination',
      (tester) async {
        await tester.pumpWidget(_buildTestApp());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(HomePage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.homeDeliveryAddressLabel), findsOneWidget);
        expect(
          find.text(
            l10n.homeDeliveryAddressValue(
              homeFeedFixtureContent.deliveryAddress,
            ),
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.homeSearchHint), findsOneWidget);

        expect(find.byType(ChoiceChip), findsNWidgets(5));

        final allCategoryChip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, l10n.homeCategoryAll),
        );
        final burgersCategoryChip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, l10n.homeCategoryBurgers),
        );

        expect(allCategoryChip.selected, isTrue);
        expect(burgersCategoryChip.selected, isFalse);

        expect(find.text(l10n.homeBannerTitle), findsOneWidget);
        expect(
          find.text(
            l10n.homeBannerDiscountValue(
              homeFeedFixtureContent.promotion.discountPercentage,
            ),
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.homeBannerFreeDeliveryBadge), findsOneWidget);
        expect(find.text(l10n.homeFeaturedSectionTitle), findsOneWidget);

        for (final restaurant in homeFeedFixtureContent.featuredRestaurants) {
          expect(find.text(restaurant.name), findsOneWidget);
        }

        final navigationBar = tester.widget<NavigationBar>(
          find.byType(NavigationBar),
        );
        expect(navigationBar.selectedIndex, 0);
        expect(find.text(l10n.homeBottomNavHome), findsOneWidget);
      },
    );

    testWidgets('search input updates discovery state and filters restaurants', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'japanese');
      await tester.pumpAndSettle();

      expect(find.text('Sushi Zen'), findsOneWidget);
      expect(find.text('Burger Artisan Collective'), findsNothing);
      expect(find.text('Pasta Roma'), findsNothing);
      expect(find.text('Taco Harbor'), findsNothing);
    });

    testWidgets(
      'renders localized discovery empty results and clears active filters',
      (tester) async {
        await tester.pumpWidget(_buildTestApp());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(HomePage));
        final l10n = AppLocalizations.of(context);

        await tester.tap(find.widgetWithText(ChoiceChip, l10n.homeCategoryPizza));
        await tester.enterText(find.byType(TextField), 'japanese');
        await tester.pumpAndSettle();

        expect(find.text(l10n.homeDiscoveryEmptyStateTitle), findsOneWidget);
        expect(find.text(l10n.homeDiscoveryEmptyStateMessage), findsOneWidget);
        expect(
          find.widgetWithText(
            FilledButton,
            l10n.homeDiscoveryClearFiltersAction,
          ),
          findsOneWidget,
        );

        await tester.tap(
          find.widgetWithText(
            FilledButton,
            l10n.homeDiscoveryClearFiltersAction,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Burger Artisan Collective'), findsOneWidget);
        expect(find.text(l10n.homeDiscoveryEmptyStateTitle), findsNothing);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller?.text,
          isEmpty,
        );
        expect(
          tester
              .widget<ChoiceChip>(
                find.widgetWithText(ChoiceChip, l10n.homeCategoryAll),
              )
              .selected,
          isTrue,
        );
      },
    );

    testWidgets(
      'category chip selection updates discovery state and selected UI deterministically',
      (tester) async {
        await tester.pumpWidget(_buildTestApp());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(HomePage));
        final l10n = AppLocalizations.of(context);

        await tester.tap(find.widgetWithText(ChoiceChip, l10n.homeCategoryHealthy));
        await tester.pumpAndSettle();

        final allCategoryChip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, l10n.homeCategoryAll),
        );
        final healthyCategoryChip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, l10n.homeCategoryHealthy),
        );

        expect(allCategoryChip.selected, isFalse);
        expect(healthyCategoryChip.selected, isTrue);
        expect(find.text('Pasta Roma'), findsOneWidget);
        expect(find.text('Taco Harbor'), findsOneWidget);
        expect(find.text('Burger Artisan Collective'), findsNothing);
        expect(find.text('Sushi Zen'), findsNothing);
      },
    );

    testWidgets('renders a semantic localized loading state', (tester) async {
      final completer = Completer<HomeFeedContent>();

      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _FakeHomeRepository(() => completer.future),
            ),
          ],
        ),
      );
      await tester.idle();
      await tester.pump();

      final context = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.homeLoadingStateTitle), findsOneWidget);
      expect(find.text(l10n.homeLoadingStateMessage), findsOneWidget);
      expect(
        find.bySemanticsLabel(l10n.homeLoadingStateSemanticLabel),
        findsOneWidget,
      );

      completer.complete(homeFeedFixtureContent);
    });

    testWidgets('renders a localized empty state when no restaurants are available', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _FakeHomeRepository(
                () async => HomeFeedContent(
                  deliveryAddress: homeFeedFixtureContent.deliveryAddress,
                  categories: homeFeedFixtureContent.categories,
                  promotion: homeFeedFixtureContent.promotion,
                  featuredRestaurants: const [],
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.homeEmptyStateTitle), findsOneWidget);
      expect(find.text(l10n.homeEmptyStateMessage), findsOneWidget);
      expect(find.text(l10n.homeDeliveryAddressLabel), findsOneWidget);
      expect(
        find.text(homeFeedFixtureContent.featuredRestaurants.first.name),
        findsNothing,
      );
    });

    testWidgets('renders a localized retryable error state', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            homeFeedAsyncProvider.overrideWith((ref) async {
                callCount++;
                throw Exception('boom');
              }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.homeErrorStateTitle), findsOneWidget);
      expect(find.text(l10n.homeErrorStateMessage), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, l10n.homeRetryAction),
        findsOneWidget,
      );
      expect(callCount, greaterThan(0));
      final callCountBeforeRetry = callCount;

      await tester.tap(find.widgetWithText(FilledButton, l10n.homeRetryAction));
      await tester.pumpAndSettle();

      expect(callCount, greaterThan(callCountBeforeRetry));
    });

    testWidgets('keeps deferred bottom navigation items non-functional', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(find.text(l10n.homeBottomNavBrowse));
      await tester.pumpAndSettle();

      var navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, 0);
      expect(
        find.text(homeFeedFixtureContent.featuredRestaurants.first.name),
        findsOneWidget,
      );

      await tester.tap(find.text(l10n.homeBottomNavOrders));
      await tester.pumpAndSettle();

      navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navigationBar.selectedIndex, 0);

      await tester.tap(find.text(l10n.homeBottomNavAccount));
      await tester.pumpAndSettle();

      navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navigationBar.selectedIndex, 0);
    });
  });
}

class _FakeHomeRepository implements HomeRepository {
  const _FakeHomeRepository(this.loader);

  final Future<HomeFeedContent> Function() loader;

  @override
  Future<HomeFeedContent> getHomeFeedContent() {
    return loader();
  }
}

Future<HomeFeedContent> _loadRemoteContent() async {
  return HomeFeedContent(
    deliveryAddress: 'Avenida Paulista, 1500',
    categories: const [
      HomeCategory(id: 'all'),
      HomeCategory(id: 'pizza'),
    ],
    promotion: const HomePromotion(
      id: 'promotion-remote',
      imageAssetPath: 'assets/images/promo.png',
      discountPercentage: 35,
      hasFreeDelivery: false,
    ),
    featuredRestaurants: [
      HomeRestaurant(
        id: 'restaurant-remote-1',
        name: 'Pizza Prime',
        imageAssetPath: 'assets/images/restaurant.png',
        rating: 4.9,
        deliveryTimeMinMinutes: 15,
        deliveryTimeMaxMinutes: 25,
        cuisine: 'pizza',
        categoryIds: ['all', 'pizza'],
      ),
      HomeRestaurant(
        id: 'restaurant-remote-2',
        name: 'Forno Central',
        imageAssetPath: 'assets/images/restaurant.png',
        rating: 4.7,
        deliveryTimeMinMinutes: 20,
        deliveryTimeMaxMinutes: 30,
        cuisine: 'italian',
        categoryIds: ['all'],
      ),
    ],
  );
}
