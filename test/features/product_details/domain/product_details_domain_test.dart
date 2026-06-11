import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product details domain', () {
    const product = ProductDetails(
      id: 'signature-truffle',
      restaurantId: 'burger-artisan-collective',
      categoryId: 'burgers',
      name: 'The Signature Truffle',
      description: 'Wagyu beef and black truffle aioli.',
      imageAssetPath: 'assets/images/menu/signature-truffle.jpg',
      priceInCents: 1850,
    );

    test('exposes read-only product metadata', () {
      expect(product.id, 'signature-truffle');
      expect(product.restaurantId, 'burger-artisan-collective');
      expect(product.categoryId, 'burgers');
      expect(product.name, 'The Signature Truffle');
      expect(product.description, 'Wagyu beef and black truffle aioli.');
      expect(product.imageAssetPath, 'assets/images/menu/signature-truffle.jpg');
      expect(product.priceInCents, 1850);
    });

    test('uses value equality across identical field sets', () {
      const sameProduct = ProductDetails(
        id: 'signature-truffle',
        restaurantId: 'burger-artisan-collective',
        categoryId: 'burgers',
        name: 'The Signature Truffle',
        description: 'Wagyu beef and black truffle aioli.',
        imageAssetPath: 'assets/images/menu/signature-truffle.jpg',
        priceInCents: 1850,
      );

      expect(product, equals(sameProduct));
      expect(product.hashCode, equals(sameProduct.hashCode));
    });

    test('differs when any field changes', () {
      const repricedProduct = ProductDetails(
        id: 'signature-truffle',
        restaurantId: 'burger-artisan-collective',
        categoryId: 'burgers',
        name: 'The Signature Truffle',
        description: 'Wagyu beef and black truffle aioli.',
        imageAssetPath: 'assets/images/menu/signature-truffle.jpg',
        priceInCents: 1950,
      );

      expect(product, isNot(equals(repricedProduct)));
    });
  });
}
