import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';

abstract interface class RestaurantDetailsRepository {
  Future<RestaurantDetails> getRestaurantDetails(String restaurantId);
}
