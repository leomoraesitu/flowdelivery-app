import 'package:flowdelivery_app/features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/restaurant_details/data/dtos/restaurant_details_dtos.dart';
import 'package:flowdelivery_app/features/restaurant_details/data/repositories/restaurant_details_repository_impl.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestaurantDetailsRepositoryImpl', () {
    test(
      'maps the remote payload into restaurant details domain content',
      () async {
        final datasource = _FakeRestaurantDetailsRemoteDatasource(
          RestaurantDetailsRemotePayload(
            restaurant: const RestaurantDetailsDto(
              id: 'burger_artisan_collective',
              name: 'Burger Artisan Collective',
              imageAssetPath: 'assets/images/restaurant.png',
              rating: 4.8,
              deliveryTimeMinMinutes: 25,
              deliveryTimeMaxMinutes: 35,
              cuisine: 'american',
            ),
            categories: const [
              RestaurantMenuCategoryDto(
                restaurantId: 'burger_artisan_collective',
                id: 'popular',
                sortOrder: 0,
              ),
              RestaurantMenuCategoryDto(
                restaurantId: 'burger_artisan_collective',
                id: 'burgers',
                sortOrder: 1,
              ),
            ],
            items: const [
              RestaurantMenuItemDto(
                id: 'signature_truffle',
                restaurantId: 'burger_artisan_collective',
                categoryId: 'burgers',
                name: 'The Signature Truffle',
                description: 'Wagyu beef with truffle aioli.',
                imageAssetPath: 'assets/images/signature-truffle.png',
                priceInCents: 1850,
                sortOrder: 0,
              ),
            ],
          ),
        );
        final repository = RestaurantDetailsRepositoryImpl(
          datasource: datasource,
        );

        final details = await repository.getRestaurantDetails(
          'burger_artisan_collective',
        );

        expect(datasource.requestedRestaurantId, 'burger_artisan_collective');
        expect(
          details,
          RestaurantDetails(
            id: 'burger_artisan_collective',
            name: 'Burger Artisan Collective',
            imageAssetPath: 'assets/images/restaurant.png',
            rating: 4.8,
            deliveryTimeMinMinutes: 25,
            deliveryTimeMaxMinutes: 35,
            cuisine: 'american',
            categories: const [
              RestaurantMenuCategory(id: 'popular'),
              RestaurantMenuCategory(id: 'burgers'),
            ],
            items: const [
              RestaurantMenuItem(
                id: 'signature_truffle',
                categoryId: 'burgers',
                name: 'The Signature Truffle',
                description: 'Wagyu beef with truffle aioli.',
                imageAssetPath: 'assets/images/signature-truffle.png',
                priceInCents: 1850,
              ),
            ],
          ),
        );
      },
    );
  });
}

class _FakeRestaurantDetailsRemoteDatasource
    implements RestaurantDetailsRemoteDatasource {
  _FakeRestaurantDetailsRemoteDatasource(this.payload);

  final RestaurantDetailsRemotePayload payload;
  String? requestedRestaurantId;

  @override
  Future<RestaurantDetailsRemotePayload> getRestaurantDetails(
    String restaurantId,
  ) async {
    requestedRestaurantId = restaurantId;
    return payload;
  }
}
