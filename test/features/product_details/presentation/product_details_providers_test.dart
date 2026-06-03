import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:flowdelivery_app/features/product_details/presentation/providers/product_details_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('productDetailsProvider', () {
    test('loads product details by stable product id', () async {
      final repository = _FakeProductDetailsRepository(_product);
      final container = ProviderContainer(
        overrides: [
          productDetailsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(productDetailsProvider('signature_truffle').future),
        completion(_product),
      );
      expect(repository.requestedProductIds, ['signature_truffle']);
    });

    test('resolves to null when the product is not found', () async {
      final repository = _FakeProductDetailsRepository(null);
      final container = ProviderContainer(
        overrides: [
          productDetailsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(productDetailsProvider('missing_product').future),
        completion(isNull),
      );
      expect(repository.requestedProductIds, ['missing_product']);
    });
  });
}

class _FakeProductDetailsRepository implements ProductDetailsRepository {
  _FakeProductDetailsRepository(this.product);

  final ProductDetails? product;
  final requestedProductIds = <String>[];

  @override
  Future<ProductDetails?> getProductDetails(String productId) async {
    requestedProductIds.add(productId);
    return product;
  }
}

const _product = ProductDetails(
  id: 'signature_truffle',
  restaurantId: 'burger_artisan_collective',
  categoryId: 'burgers',
  name: 'The Signature Truffle',
  description: 'Wagyu beef with truffle aioli.',
  imageAssetPath: 'assets/images/signature-truffle.png',
  priceInCents: 1850,
);
