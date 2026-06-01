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

  return HomeFeedViewData(
    content: content,
    discoveryState: discoveryState,
    visibleRestaurants: content.featuredRestaurants,
  );
});
