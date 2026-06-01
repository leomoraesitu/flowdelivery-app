import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const homeAllCategoryId = 'all';

class HomeFeedDiscoveryState {
  const HomeFeedDiscoveryState({
    this.selectedCategoryId = homeAllCategoryId,
    this.searchQuery = '',
  });

  final String selectedCategoryId;
  final String searchQuery;
}

class HomeFeedDiscoveryController extends Notifier<HomeFeedDiscoveryState> {
  @override
  HomeFeedDiscoveryState build() {
    return const HomeFeedDiscoveryState();
  }

  void selectCategory(String categoryId) {
    state = HomeFeedDiscoveryState(
      selectedCategoryId: categoryId,
      searchQuery: state.searchQuery,
    );
  }

  void setSearchQuery(String query) {
    state = HomeFeedDiscoveryState(
      selectedCategoryId: state.selectedCategoryId,
      searchQuery: query,
    );
  }
}

class HomeFeedViewData {
  const HomeFeedViewData({
    required this.content,
    required this.discoveryState,
    required this.visibleRestaurants,
  });

  final HomeFeedContent content;
  final HomeFeedDiscoveryState discoveryState;
  final List<HomeRestaurant> visibleRestaurants;

  List<HomeCategory> get categories => content.categories;
  HomePromotion get promotion => content.promotion;
  String get deliveryAddress => content.deliveryAddress;
}

String _normalizeDiscoveryQuery(String value) {
  return value.trim().toLowerCase();
}

bool _matchesSelectedCategory(
  HomeRestaurant restaurant,
  HomeFeedDiscoveryState discoveryState,
) {
  final selectedCategoryId = discoveryState.selectedCategoryId;

  if (selectedCategoryId == homeAllCategoryId) {
    return true;
  }

  return restaurant.categoryIds.contains(selectedCategoryId);
}

bool _matchesSearchQuery(
  HomeRestaurant restaurant,
  HomeFeedDiscoveryState discoveryState,
) {
  final normalizedQuery = _normalizeDiscoveryQuery(discoveryState.searchQuery);

  if (normalizedQuery.isEmpty) {
    return true;
  }

  final normalizedName = _normalizeDiscoveryQuery(restaurant.name);
  final normalizedCuisine = _normalizeDiscoveryQuery(restaurant.cuisine);

  return normalizedName.contains(normalizedQuery) ||
      normalizedCuisine.contains(normalizedQuery);
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const FixtureHomeRepository();
});

final homeFeedAsyncProvider = FutureProvider<HomeFeedContent>((ref) {
  return ref.watch(homeRepositoryProvider).getHomeFeedContent();
});

final homeFeedProvider = Provider<HomeFeedContent>((ref) {
  return ref.watch(homeFeedAsyncProvider).asData?.value ?? homeFeedFixtureContent;
});

final homeFeedDiscoveryControllerProvider =
    NotifierProvider<HomeFeedDiscoveryController, HomeFeedDiscoveryState>(
      HomeFeedDiscoveryController.new,
    );

final homeFeedViewProvider = Provider<HomeFeedViewData>((ref) {
  final content = ref.watch(homeFeedProvider);
  final discoveryState = ref.watch(homeFeedDiscoveryControllerProvider);
  final visibleRestaurants = content.featuredRestaurants
      .where(
        (restaurant) =>
            _matchesSelectedCategory(restaurant, discoveryState) &&
            _matchesSearchQuery(restaurant, discoveryState),
      )
      .toList(growable: false);

  return HomeFeedViewData(
    content: content,
    discoveryState: discoveryState,
    visibleRestaurants: visibleRestaurants,
  );
});
