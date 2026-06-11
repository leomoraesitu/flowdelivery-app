import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';

abstract interface class ProductDetailsRepository {
  /// Returns the [ProductDetails] for [productId], or `null` when no product
  /// exists (the expected not-found case).
  Future<ProductDetails?> getProductDetails(String productId);
}
