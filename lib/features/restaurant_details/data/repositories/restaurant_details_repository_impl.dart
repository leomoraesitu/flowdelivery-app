import 'package:flowdelivery_app/features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/repositories/restaurant_details_repository.dart';

class RestaurantDetailsRepositoryImpl implements RestaurantDetailsRepository {
  const RestaurantDetailsRepositoryImpl({
    required RestaurantDetailsRemoteDatasource datasource,
  }) : _datasource = datasource;

  final RestaurantDetailsRemoteDatasource _datasource;

  @override
  Future<RestaurantDetails> getRestaurantDetails(String restaurantId) async {
    final payload = await _datasource.getRestaurantDetails(restaurantId);
    final restaurant = payload.restaurant;

    return RestaurantDetails(
      id: restaurant.id,
      name: restaurant.name,
      imageAssetPath: restaurant.imageAssetPath,
      rating: restaurant.rating,
      deliveryTimeMinMinutes: restaurant.deliveryTimeMinMinutes,
      deliveryTimeMaxMinutes: restaurant.deliveryTimeMaxMinutes,
      cuisine: restaurant.cuisine,
      categories: payload.categories
          .map((category) => RestaurantMenuCategory(id: category.id))
          .toList(growable: false),
      items: payload.items
          .map(
            (item) => RestaurantMenuItem(
              id: item.id,
              categoryId: item.categoryId,
              name: item.name,
              description: item.description,
              imageAssetPath: item.imageAssetPath,
              priceInCents: item.priceInCents,
            ),
          )
          .toList(growable: false),
    );
  }
}
