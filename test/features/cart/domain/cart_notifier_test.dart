import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
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

const _sushi = ProductDetails(
  id: 'sushi_zen_omakase_sampler',
  restaurantId: 'sushi_zen',
  categoryId: 'rolls',
  name: 'Omakase Sampler',
  description: 'Chef selection of seasonal nigiri.',
  imageAssetPath: 'assets/images/omakase-sampler.png',
  priceInCents: 4200,
);

void main() {
  group('CartNotifier', () {
    late ProviderContainer container;
    late CartNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(cartProvider.notifier);
      addTearDown(container.dispose);
    });

    test('starts with an empty cart', () {
      final cart = container.read(cartProvider);

      expect(cart.isEmpty, isTrue);
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.totalInCents, 0);
      expect(cart.restaurantId, isNull);
    });

    test('addItem to an empty cart adds a single-quantity item', () {
      final result = notifier.addItem(_burger);
      final cart = container.read(cartProvider);

      expect(result, CartAddResult.added);
      expect(cart.items, hasLength(1));
      expect(cart.items.first.productId, _burger.id);
      expect(cart.items.first.quantity, 1);
      expect(cart.restaurantId, _burger.restaurantId);
    });

    test('addItem for a product already in the cart increments quantity', () {
      notifier.addItem(_burger);
      final result = notifier.addItem(_burger);
      final cart = container.read(cartProvider);

      expect(result, CartAddResult.added);
      expect(cart.items, hasLength(1));
      expect(cart.items.first.quantity, 2);
    });

    test('addItem for another product from the same restaurant appends it', () {
      notifier.addItem(_burger);
      final result = notifier.addItem(_fries);
      final cart = container.read(cartProvider);

      expect(result, CartAddResult.added);
      expect(cart.items, hasLength(2));
      expect(cart.restaurantId, _burger.restaurantId);
    });

    test(
      'addItem from a different restaurant requires confirmation and keeps '
      'the cart unchanged',
      () {
        notifier.addItem(_burger);
        final result = notifier.addItem(_sushi);
        final cart = container.read(cartProvider);

        expect(result, CartAddResult.requiresConfirmation);
        expect(cart.items, hasLength(1));
        expect(cart.restaurantId, _burger.restaurantId);
      },
    );

    test('removeItem removes only the matching product', () {
      notifier.addItem(_burger);
      notifier.addItem(_fries);

      notifier.removeItem(_burger.id);
      final cart = container.read(cartProvider);

      expect(cart.items, hasLength(1));
      expect(cart.items.first.productId, _fries.id);
    });

    test('updateQuantity replaces the quantity of the matching item', () {
      notifier.addItem(_burger);

      notifier.updateQuantity(_burger.id, 4);
      final cart = container.read(cartProvider);

      expect(cart.items.first.quantity, 4);
      expect(cart.itemCount, 4);
    });

    test('updateQuantity to zero removes the item', () {
      notifier.addItem(_burger);

      notifier.updateQuantity(_burger.id, 0);
      final cart = container.read(cartProvider);

      expect(cart.isEmpty, isTrue);
    });

    test('clear empties the cart and resets the restaurant lock', () {
      notifier.addItem(_burger);
      notifier.addItem(_fries);

      notifier.clear();
      final cart = container.read(cartProvider);

      expect(cart.isEmpty, isTrue);
      expect(cart.restaurantId, isNull);

      final result = notifier.addItem(_sushi);
      expect(result, CartAddResult.added);
    });

    test('itemCount and totalInCents aggregate quantities and subtotals', () {
      notifier.addItem(_burger);
      notifier.addItem(_burger);
      notifier.addItem(_fries);

      final cart = container.read(cartProvider);

      expect(cart.itemCount, 3);
      expect(cart.totalInCents, 1850 * 2 + 650);
      expect(cart.items.first.subtotalInCents, 3700);
    });

    test('cartItemCountProvider derives the aggregated quantity', () {
      expect(container.read(cartItemCountProvider), 0);

      notifier.addItem(_burger);
      notifier.addItem(_burger);
      notifier.addItem(_fries);

      expect(container.read(cartItemCountProvider), 3);
    });

    test('cartItemProvider selects only the matching product entry', () {
      notifier.addItem(_burger);

      expect(container.read(cartItemProvider(_burger.id))?.quantity, 1);
      expect(container.read(cartItemProvider(_fries.id)), isNull);
    });
  });
}
