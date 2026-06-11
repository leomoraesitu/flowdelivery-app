import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDetailsRepositoryProvider = Provider<ProductDetailsRepository>((
  ref,
) {
  throw StateError('Product details repository was not configured.');
});

final productDetailsProvider = FutureProvider.family<ProductDetails?, String>((
  ref,
  productId,
) {
  return ref
      .watch(productDetailsRepositoryProvider)
      .getProductDetails(productId);
});
