import 'package:flowdelivery_app/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  const ProductDetailsRepositoryImpl({
    required ProductDetailsRemoteDatasource datasource,
  }) : _datasource = datasource;

  final ProductDetailsRemoteDatasource _datasource;

  @override
  Future<ProductDetails?> getProductDetails(String productId) async {
    final dto = await _datasource.getProductDetails(productId);
    if (dto == null) {
      return null;
    }

    return ProductDetails(
      id: dto.id,
      restaurantId: dto.restaurantId,
      categoryId: dto.categoryId,
      name: dto.name,
      description: dto.description,
      imageAssetPath: dto.imageAssetPath,
      priceInCents: dto.priceInCents,
    );
  }
}
