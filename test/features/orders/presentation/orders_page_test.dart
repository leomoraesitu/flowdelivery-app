import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/repositories/order_history_repository.dart';
import 'package:flowdelivery_app/features/orders/presentation/pages/orders_page.dart';
import 'package:flowdelivery_app/features/orders/presentation/providers/order_history_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

final _ordersPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

Widget _buildTestApp({
  required List overrides,
  VoidCallback? onExploreRestaurants,
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: _ordersPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: OrdersPage(onExploreRestaurants: onExploreRestaurants),
    ),
  );
}

void main() {
  group('OrdersPage', () {
    testWidgets('renders localized loading state', (tester) async {
      final completer = Completer<List<OrderHistoryEntry>>();

      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            orderHistoryRepositoryProvider.overrideWithValue(
              _FakeOrderHistoryRepository(() => completer.future),
            ),
          ],
        ),
      );
      await tester.idle();
      await tester.pump();

      final context = tester.element(find.byType(OrdersPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.ordersPageTitle), findsOneWidget);
      expect(
        find.bySemanticsLabel(l10n.ordersLoadingSemanticLabel),
        findsOneWidget,
      );

      completer.complete(const []);
    });

    testWidgets('renders localized retryable error state', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            orderHistoryProvider.overrideWith((ref) async {
              callCount++;
              throw StateError('boom');
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(OrdersPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.ordersErrorTitle), findsOneWidget);
      expect(find.text(l10n.ordersErrorMessage), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, l10n.ordersRetryAction),
        findsOneWidget,
      );
      final callCountBeforeRetry = callCount;

      await tester.tap(
        find.widgetWithText(FilledButton, l10n.ordersRetryAction),
      );
      await tester.pumpAndSettle();

      expect(callCount, greaterThan(callCountBeforeRetry));
    });

    testWidgets('renders localized empty state and explore action', (
      tester,
    ) async {
      var exploreTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          onExploreRestaurants: () => exploreTapped = true,
          overrides: [
            orderHistoryRepositoryProvider.overrideWithValue(
              _FakeOrderHistoryRepository(() async => const []),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(OrdersPage));
      final l10n = AppLocalizations.of(context);

      expect(find.text(l10n.ordersEmptyTitle), findsOneWidget);
      expect(find.text(l10n.ordersEmptyMessage), findsOneWidget);

      await tester.tap(
        find.widgetWithText(FilledButton, l10n.ordersEmptyAction),
      );
      await tester.pumpAndSettle();

      expect(exploreTapped, isTrue);
    });

    testWidgets('renders order cards with localized content', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            orderHistoryRepositoryProvider.overrideWithValue(
              _FakeOrderHistoryRepository(() async => [_entry]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(OrdersPage));
      final l10n = AppLocalizations.of(context);
      final formattedDate = MaterialLocalizations.of(
        context,
      ).formatMediumDate(_entry.createdAt);
      final formattedTotal = NumberFormat.simpleCurrency(
        locale: 'pt-BR',
      ).format(_entry.totalInCents / 100);

      expect(find.text(_entry.restaurantName), findsOneWidget);
      expect(find.text(formattedDate), findsOneWidget);
      expect(find.text(l10n.ordersStatusPlaced), findsOneWidget);
      expect(find.text(l10n.ordersItemCount(_entry.itemCount)), findsOneWidget);
      expect(find.text(l10n.ordersTotalLabel), findsOneWidget);
      expect(find.text(formattedTotal), findsOneWidget);
    });

    testWidgets('renders remote restaurant media through AppMediaImage', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          overrides: [
            orderHistoryRepositoryProvider.overrideWithValue(
              _FakeOrderHistoryRepository(() async => [_remoteEntry]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is NetworkImage &&
              (widget.image as NetworkImage).url ==
                  _remoteEntry.restaurantImagePath,
        ),
      );

      expect(image.excludeFromSemantics, isTrue);
    });
  });
}

class _FakeOrderHistoryRepository implements OrderHistoryRepository {
  const _FakeOrderHistoryRepository(this.load);

  final Future<List<OrderHistoryEntry>> Function() load;

  @override
  Future<List<OrderHistoryEntry>> loadOrderHistory() => load();
}

final _entry = OrderHistoryEntry(
  id: 'order-1',
  restaurantName: 'Burger Artisan Collective',
  restaurantImagePath: 'assets/images/restaurant.png',
  createdAt: DateTime.parse('2026-07-08T14:30:00Z'),
  itemCount: 3,
  totalInCents: 4949,
  status: OrderHistoryStatus.placed,
);

final _remoteEntry = OrderHistoryEntry(
  id: 'order-2',
  restaurantName: 'Sushi Zen',
  restaurantImagePath: 'https://example.com/sushi-zen.webp',
  createdAt: DateTime.parse('2026-07-08T15:30:00Z'),
  itemCount: 1,
  totalInCents: 4200,
  status: OrderHistoryStatus.placed,
);
