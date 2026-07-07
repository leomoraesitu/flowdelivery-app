import 'dart:async';

import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/payment_summary.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/placed_order.dart';
import 'package:flowdelivery_app/features/checkout/domain/failures/order_placement_failure.dart';
import 'package:flowdelivery_app/features/checkout/domain/repositories/order_repository.dart';
import 'package:flowdelivery_app/features/checkout/presentation/providers/checkout_providers.dart';
import 'package:flowdelivery_app/features/checkout/presentation/viewmodels/checkout_view_model.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

final _placedOrder = PlacedOrder(
  id: 'order-1',
  totalInCents: 4949,
  createdAt: DateTime.utc(2026, 7, 7, 12),
);

class _FakeOrderRepository implements OrderRepository {
  _FakeOrderRepository({this.failure});

  final OrderPlacementFailure? failure;
  final List<OrderDraft> receivedDrafts = [];
  Completer<PlacedOrder>? pendingCompleter;
  bool holdNextCall = false;

  @override
  Future<PlacedOrder> placeOrder(OrderDraft draft) {
    receivedDrafts.add(draft);

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

class _ThrowingOrderRepository implements OrderRepository {
  @override
  Future<PlacedOrder> placeOrder(OrderDraft draft) {
    return Future<PlacedOrder>.error(StateError('unexpected'));
  }
}

ProviderContainer _buildContainer(OrderRepository repository) {
  final container = ProviderContainer(
    overrides: [orderRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('CheckoutViewModel', () {
    test('starts idle', () {
      final container = _buildContainer(_FakeOrderRepository());

      expect(container.read(checkoutViewModelProvider), const CheckoutIdle());
    });

    test(
      'placeOrder builds the draft from the cart, succeeds, and clears the '
      'cart exactly once',
      () async {
        final repository = _FakeOrderRepository();
        final container = _buildContainer(repository);
        container.read(cartProvider.notifier)
          ..addItem(_burger)
          ..addItem(_burger)
          ..addItem(_fries);

        await container
            .read(checkoutViewModelProvider.notifier)
            .placeOrder(deliveryAddress: 'Rua Demo, 123');

        expect(
          container.read(checkoutViewModelProvider),
          CheckoutSuccess(order: _placedOrder),
        );
        expect(container.read(cartProvider).isEmpty, isTrue);
        expect(repository.receivedDrafts, hasLength(1));

        final draft = repository.receivedDrafts.single;
        expect(draft.restaurantId, _burger.restaurantId);
        expect(draft.deliveryAddress, 'Rua Demo, 123');
        expect(draft.paymentMethod, PaymentMethod.cashOnDelivery);
        expect(
          draft.deliveryFeeInCents,
          OrderDraft.standardDeliveryFeeInCents,
        );
        expect(draft.items, hasLength(2));
        expect(draft.items.first.productId, _burger.id);
        expect(draft.items.first.quantity, 2);
        expect(draft.subtotalInCents, _burger.priceInCents * 2 + _fries.priceInCents);
        expect(
          draft.totalInCents,
          draft.subtotalInCents + OrderDraft.standardDeliveryFeeInCents,
        );
      },
    );

    test('placeOrder maps OrderPlacementFailure codes and keeps the cart', () async {
      final repository = _FakeOrderRepository(
        failure: const OrderPlacementFailure(
          code: OrderPlacementFailureCode.networkFailure,
        ),
      );
      final container = _buildContainer(repository);
      container.read(cartProvider.notifier).addItem(_burger);

      await container
          .read(checkoutViewModelProvider.notifier)
          .placeOrder(deliveryAddress: 'Rua Demo, 123');

      expect(
        container.read(checkoutViewModelProvider),
        const CheckoutFailure(code: OrderPlacementFailureCode.networkFailure),
      );
      expect(container.read(cartProvider).isEmpty, isFalse);
    });

    test('placeOrder maps unexpected errors to genericFailure', () async {
      final container = _buildContainer(_ThrowingOrderRepository());
      container.read(cartProvider.notifier).addItem(_burger);

      await container
          .read(checkoutViewModelProvider.notifier)
          .placeOrder(deliveryAddress: 'Rua Demo, 123');

      expect(
        container.read(checkoutViewModelProvider),
        const CheckoutFailure(code: OrderPlacementFailureCode.genericFailure),
      );
    });

    test('placeOrder is a no-op while already submitting', () async {
      final repository = _FakeOrderRepository()..holdNextCall = true;
      final container = _buildContainer(repository);
      container.read(cartProvider.notifier).addItem(_burger);
      final viewModel = container.read(checkoutViewModelProvider.notifier);

      final firstCall = viewModel.placeOrder(deliveryAddress: 'Rua Demo, 123');
      expect(
        container.read(checkoutViewModelProvider),
        const CheckoutSubmitting(),
      );

      await viewModel.placeOrder(deliveryAddress: 'Rua Demo, 123');
      expect(repository.receivedDrafts, hasLength(1));

      repository.pendingCompleter!.complete(_placedOrder);
      await firstCall;

      expect(
        container.read(checkoutViewModelProvider),
        CheckoutSuccess(order: _placedOrder),
      );
      expect(repository.receivedDrafts, hasLength(1));
    });

    test('placeOrder is a no-op with an empty cart', () async {
      final repository = _FakeOrderRepository();
      final container = _buildContainer(repository);

      await container
          .read(checkoutViewModelProvider.notifier)
          .placeOrder(deliveryAddress: 'Rua Demo, 123');

      expect(container.read(checkoutViewModelProvider), const CheckoutIdle());
      expect(repository.receivedDrafts, isEmpty);
    });

    test('reset returns to idle after a failure', () async {
      final repository = _FakeOrderRepository(
        failure: const OrderPlacementFailure(
          code: OrderPlacementFailureCode.genericFailure,
        ),
      );
      final container = _buildContainer(repository);
      container.read(cartProvider.notifier).addItem(_burger);
      final viewModel = container.read(checkoutViewModelProvider.notifier);

      await viewModel.placeOrder(deliveryAddress: 'Rua Demo, 123');
      viewModel.reset();

      expect(container.read(checkoutViewModelProvider), const CheckoutIdle());
    });
  });
}
