import 'package:flowdelivery_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_category_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_promotion_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_restaurant_dto.dart';
import 'package:flowdelivery_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeRepositoryImpl', () {
    test('maps the remote payload into Home domain content', () async {
      final repository = HomeRepositoryImpl(
        datasource: _FakeHomeRemoteDatasource(
          HomeRemoteFeedPayload(
            categories: const [
              HomeCategoryDto(id: 'all', sortOrder: 0),
              HomeCategoryDto(id: 'burgers', sortOrder: 1),
            ],
            promotion: const HomePromotionDto(
              id: 'promo',
              imageAssetPath: 'assets/images/promo.png',
              discountPercentage: 25,
              hasFreeDelivery: true,
              sortOrder: 0,
            ),
            featuredRestaurants: [
              HomeRestaurantDto(
                id: 'restaurant-1',
                name: 'Burger House',
                imageAssetPath: 'assets/images/restaurant.png',
                rating: 4.7,
                deliveryTimeMinMinutes: 20,
                deliveryTimeMaxMinutes: 30,
                cuisine: 'burgers',
                sortOrder: 0,
                categoryIds: const ['all', 'burgers'],
              ),
            ],
          ),
        ),
      );

      final content = await repository.getHomeFeedContent();

      expect(
        content,
        HomeFeedContent(
          deliveryAddress: 'Rua das Flores, 42',
          categories: const [
            HomeCategory(id: 'all'),
            HomeCategory(id: 'burgers'),
          ],
          promotion: const HomePromotion(
            id: 'promo',
            imageAssetPath: 'assets/images/promo.png',
            discountPercentage: 25,
            hasFreeDelivery: true,
          ),
          featuredRestaurants: [
            HomeRestaurant(
              id: 'restaurant-1',
              name: 'Burger House',
              imageAssetPath: 'assets/images/restaurant.png',
              rating: 4.7,
              deliveryTimeMinMinutes: 20,
              deliveryTimeMaxMinutes: 30,
              cuisine: 'burgers',
              categoryIds: const ['all', 'burgers'],
            ),
          ],
        ),
      );
    });

    test('allows overriding the local delivery address placeholder', () async {
      final repository = HomeRepositoryImpl(
        datasource: _FakeHomeRemoteDatasource(
          HomeRemoteFeedPayload(
            categories: const [HomeCategoryDto(id: 'all', sortOrder: 0)],
            promotion: const HomePromotionDto(
              id: 'promo',
              imageAssetPath: 'assets/images/promo.png',
              discountPercentage: 10,
              hasFreeDelivery: false,
              sortOrder: 0,
            ),
            featuredRestaurants: const [],
          ),
        ),
        deliveryAddressPlaceholder: 'Avenida Brasil, 1000',
      );

      final content = await repository.getHomeFeedContent();

      expect(content.deliveryAddress, 'Avenida Brasil, 1000');
    });
  });
}

class _FakeHomeRemoteDatasource implements HomeRemoteDatasource {
  const _FakeHomeRemoteDatasource(this.payload);

  final HomeRemoteFeedPayload payload;

  @override
  Future<HomeRemoteFeedPayload> getHomeFeed() async {
    return payload;
  }
}
