import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/repositories/restaurant_details_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailsSelectedCategoryController extends Notifier<String?> {
  RestaurantDetailsSelectedCategoryController(this.restaurantId);

  final String restaurantId;

  @override
  String? build() {
    return null;
  }

  void selectCategory(String categoryId) {
    state = categoryId;
  }

  void reset() {
    state = null;
  }
}

final restaurantDetailsRepositoryProvider =
    Provider<RestaurantDetailsRepository>((ref) {
      throw StateError('Restaurant details repository was not configured.');
    });

final restaurantDetailsProvider =
    FutureProvider.family<RestaurantDetails, String>((ref, restaurantId) {
      return ref
          .watch(restaurantDetailsRepositoryProvider)
          .getRestaurantDetails(restaurantId);
    });

final restaurantDetailsSelectedCategoryProvider =
    NotifierProvider.family<
      RestaurantDetailsSelectedCategoryController,
      String?,
      String
    >(RestaurantDetailsSelectedCategoryController.new);
