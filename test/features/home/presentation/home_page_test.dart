import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/presentation/pages/home_page.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _homePageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

Widget _buildTestApp() {
  return ProviderScope(
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
