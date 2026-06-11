import 'package:flowdelivery_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required HomeRemoteDatasource datasource,
    this.deliveryAddressPlaceholder = _defaultDeliveryAddressPlaceholder,
  }) : _datasource = datasource;

  static const _defaultDeliveryAddressPlaceholder = 'Rua das Flores, 42';

  final HomeRemoteDatasource _datasource;
  final String deliveryAddressPlaceholder;

  @override
  Future<HomeFeedContent> getHomeFeedContent() async {
    final payload = await _datasource.getHomeFeed();

    return HomeFeedContent(
      deliveryAddress: deliveryAddressPlaceholder,
      categories: payload.categories
          .map((category) => HomeCategory(id: category.id))
          .toList(growable: false),
      promotion: HomePromotion(
        id: payload.promotion.id,
        imageAssetPath: payload.promotion.imageAssetPath,
        discountPercentage: payload.promotion.discountPercentage,
        hasFreeDelivery: payload.promotion.hasFreeDelivery,
      ),
      featuredRestaurants: payload.featuredRestaurants
          .map(
            (restaurant) => HomeRestaurant(
              id: restaurant.id,
              name: restaurant.name,
              imageAssetPath: restaurant.imageAssetPath,
              rating: restaurant.rating,
              deliveryTimeMinMinutes: restaurant.deliveryTimeMinMinutes,
              deliveryTimeMaxMinutes: restaurant.deliveryTimeMaxMinutes,
              cuisine: restaurant.cuisine,
              categoryIds: restaurant.categoryIds,
            ),
          )
          .toList(growable: false),
    );
  }
}

class FixtureHomeRepository implements HomeRepository {
  const FixtureHomeRepository();

  @override
  Future<HomeFeedContent> getHomeFeedContent() async {
    return homeFeedFixtureContent;
  }
}
