import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
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
