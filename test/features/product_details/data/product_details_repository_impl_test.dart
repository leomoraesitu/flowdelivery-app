import 'package:flowdelivery_app/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/product_details/data/dtos/product_details_dto.dart';
import 'package:flowdelivery_app/features/product_details/data/repositories/product_details_repository_impl.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductDetailsRepositoryImpl', () {
    test('maps the remote DTO into the product details entity', () async {
      final datasource = _FakeProductDetailsRemoteDatasource(
        const ProductDetailsDto(
          id: 'signature_truffle',
          restaurantId: 'burger_artisan_collective',
          categoryId: 'burgers',
          name: 'The Signature Truffle',
          description: 'Wagyu beef with truffle aioli.',
          imageAssetPath: 'assets/images/signature-truffle.png',
          priceInCents: 1850,
        ),
      );
      final repository = ProductDetailsRepositoryImpl(datasource: datasource);

      final product = await repository.getProductDetails('signature_truffle');

      expect(datasource.requestedProductId, 'signature_truffle');
      expect(
        product,
        const ProductDetails(
          id: 'signature_truffle',
          restaurantId: 'burger_artisan_collective',
          categoryId: 'burgers',
          name: 'The Signature Truffle',
          description: 'Wagyu beef with truffle aioli.',
          imageAssetPath: 'assets/images/signature-truffle.png',
          priceInCents: 1850,
        ),
      );
    });

    test('propagates null when the datasource reports not-found', () async {
      final datasource = _FakeProductDetailsRemoteDatasource(null);
      final repository = ProductDetailsRepositoryImpl(datasource: datasource);

      final product = await repository.getProductDetails('missing_product');

      expect(datasource.requestedProductId, 'missing_product');
      expect(product, isNull);
    });
  });
}

class _FakeProductDetailsRemoteDatasource
    implements ProductDetailsRemoteDatasource {
  _FakeProductDetailsRemoteDatasource(this.dto);

  final ProductDetailsDto? dto;
  String? requestedProductId;

  @override
  Future<ProductDetailsDto?> getProductDetails(String productId) async {
    requestedProductId = productId;
    return dto;
  }
}
