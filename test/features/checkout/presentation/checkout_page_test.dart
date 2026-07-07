import 'dart:async';

import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/placed_order.dart';
import 'package:flowdelivery_app/features/checkout/domain/failures/order_placement_failure.dart';
import 'package:flowdelivery_app/features/checkout/domain/repositories/order_repository.dart';
import 'package:flowdelivery_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:flowdelivery_app/features/checkout/presentation/viewmodels/checkout_view_model.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

final _checkoutPageTestTheme = AppTheme.light.copyWith(
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

final _placedOrder = PlacedOrder(
  id: 'order-1',
  totalInCents: 4299,
  createdAt: DateTime.utc(2026, 7, 7, 12),
);

String _formatCents(int cents) {
  return NumberFormat.simpleCurrency(locale: 'pt-BR').format(cents / 100);
}

class _FakeOrderRepository implements OrderRepository {
  _FakeOrderRepository({this.failure});

  final OrderPlacementFailure? failure;
  Completer<PlacedOrder>? pendingCompleter;
  bool holdNextCall = false;
  int callCount = 0;

  @override
  Future<PlacedOrder> placeOrder(OrderDraft draft) {
    callCount++;

    final failure = this.failure;
    if (failure != null) {
      return Future<PlacedOrder>.error(failure);
    }

    if (holdNextCall) {
      pendingCompleter = Completer<PlacedOrder>();
      return pendingCompleter!.future;
    }

    return Future<PlacedOrder>.value(_placedOrder);
  }
}

Widget _buildTestApp({
  required ProviderContainer container,
  VoidCallback? onBackToHome,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: _checkoutPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: CheckoutPage(onBackToHome: onBackToHome),
    ),
  );
}

ProviderContainer _buildContainer(OrderRepository repository) {
  return ProviderContainer(
    overrides: [orderRepositoryProvider.overrideWithValue(repository)],
  );
}

void main() {
  group('CheckoutPage', () {
    late ProviderContainer container;
    late _FakeOrderRepository repository;

    setUp(() {
      repository = _FakeOrderRepository();
      container = _buildContainer(repository);
      addTearDown(container.dispose);
    });

    testWidgets(
      'renders address, payment, summary rows, and totals for the cart',
      (tester) async {
        container.read(cartProvider.notifier)
          ..addItem(_burger)
          ..addItem(_burger);

        await tester.pumpWidget(_buildTestApp(container: container));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CheckoutPage));
        final l10n = AppLocalizations.of(context);
        final subtotal = _burger.priceInCents * 2;
        final total = subtotal + OrderDraft.standardDeliveryFeeInCents;

        expect(find.text(l10n.checkoutDeliveryAddressTitle), findsOneWidget);
        expect(find.text(l10n.checkoutDemoAddress), findsOneWidget);
        expect(find.text(l10n.checkoutPaymentTitle), findsOneWidget);
        expect(
          find.text(l10n.checkoutPaymentCashOnDelivery),
          findsOneWidget,
        );
        expect(find.text(l10n.checkoutItemQuantity(2)), findsOneWidget);
        expect(find.text(_burger.name), findsOneWidget);
        expect(find.text(_formatCents(subtotal)), findsNWidgets(2));
        expect(
          find.text(
            _formatCents(OrderDraft.standardDeliveryFeeInCents),
          ),
          findsOneWidget,
        );
        expect(find.text(_formatCents(total)), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, l10n.checkoutConfirmAction),
              )
              .enabled,
          isTrue,
        );
      },
    );

    testWidgets('disables the confirm button while submitting', (tester) async {
      repository.holdNextCall = true;
      container.read(cartProvider.notifier).addItem(_burger);

      await tester.pumpWidget(_buildTestApp(container: container));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CheckoutPage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(
        find.widgetWithText(FilledButton, l10n.checkoutConfirmAction),
      );
      await tester.pump();

      final submittingButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, l10n.checkoutSubmitting),
      );
      expect(submittingButton.enabled, isFalse);

      repository.pendingCompleter!.complete(_placedOrder);
      await tester.pumpAndSettle();
    });

    testWidgets(
      'shows localized failure feedback with retry and keeps the cart',
      (tester) async {
        repository = _FakeOrderRepository(
          failure: const OrderPlacementFailure(
            code: OrderPlacementFailureCode.genericFailure,
          ),
        );
        container = _buildContainer(repository);
        addTearDown(container.dispose);
        container.read(cartProvider.notifier).addItem(_burger);

        await tester.pumpWidget(_buildTestApp(container: container));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CheckoutPage));
        final l10n = AppLocalizations.of(context);

        await tester.tap(
          find.widgetWithText(FilledButton, l10n.checkoutConfirmAction),
        );
        await tester.pumpAndSettle();

        expect(find.text(l10n.checkoutErrorTitle), findsOneWidget);
        expect(find.text(l10n.checkoutErrorMessage), findsOneWidget);
        expect(
          find.widgetWithText(FilledButton, l10n.checkoutRetryAction),
          findsOneWidget,
        );
        expect(container.read(cartProvider).isEmpty, isFalse);
      },
    );

    testWidgets(
      'renders the success view with the order id, clears the cart, and '
      'triggers back-to-home',
      (tester) async {
        var backToHomeRequested = 0;
        container.read(cartProvider.notifier).addItem(_burger);

        await tester.pumpWidget(
          _buildTestApp(
            container: container,
            onBackToHome: () => backToHomeRequested++,
          ),
        );
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(CheckoutPage));
        final l10n = AppLocalizations.of(context);

        await tester.tap(
          find.widgetWithText(FilledButton, l10n.checkoutConfirmAction),
        );
        await tester.pumpAndSettle();

        expect(find.text(l10n.checkoutSuccessTitle), findsOneWidget);
        expect(
          find.text(l10n.checkoutSuccessMessage(_placedOrder.id)),
          findsOneWidget,
        );
        expect(container.read(cartProvider).isEmpty, isTrue);
        expect(repository.callCount, 1);

        await tester.tap(
          find.widgetWithText(FilledButton, l10n.checkoutSuccessBackToHome),
        );
        await tester.pumpAndSettle();

        expect(backToHomeRequested, 1);
      },
    );

    testWidgets('disables the confirm button when the cart is empty', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(container: container));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CheckoutPage));
      final l10n = AppLocalizations.of(context);

      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, l10n.checkoutConfirmAction),
            )
            .enabled,
        isFalse,
      );
    });
  });
}
