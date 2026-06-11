import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
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

class RestaurantDetailsViewData {
  const RestaurantDetailsViewData({
    required this.details,
    required this.selectedCategoryId,
    required this.visibleItems,
  });

  final RestaurantDetails details;
  final String? selectedCategoryId;
  final List<RestaurantMenuItem> visibleItems;
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

final restaurantDetailsViewDataProvider =
    FutureProvider.family<RestaurantDetailsViewData, String>((
      ref,
      restaurantId,
    ) async {
      final details = await ref.watch(
        restaurantDetailsProvider(restaurantId).future,
      );
      final selectedCategoryId =
          ref.watch(restaurantDetailsSelectedCategoryProvider(restaurantId)) ??
          details.categories.firstOrNull?.id;
      final visibleItems = switch (selectedCategoryId) {
        null || 'popular' => details.items,
        final categoryId =>
          details.items
              .where((item) => item.categoryId == categoryId)
              .toList(growable: false),
      };

      return RestaurantDetailsViewData(
        details: details,
        selectedCategoryId: selectedCategoryId,
        visibleItems: visibleItems,
      );
    });
