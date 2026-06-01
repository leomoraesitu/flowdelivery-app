import 'package:flowdelivery_app/features/home/data/dtos/home_category_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_promotion_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_restaurant_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef HomeRemoteRowsLoader = Future<List<Map<String, Object?>>> Function();
typedef HomeRemoteSingleRowLoader = Future<Map<String, Object?>?> Function();

class HomeRemoteFeedPayload {
  HomeRemoteFeedPayload({
    required List<HomeCategoryDto> categories,
    required this.promotion,
    required List<HomeRestaurantDto> featuredRestaurants,
  }) : categories = List.unmodifiable(categories),
       featuredRestaurants = List.unmodifiable(featuredRestaurants);

  final List<HomeCategoryDto> categories;
  final HomePromotionDto promotion;
  final List<HomeRestaurantDto> featuredRestaurants;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeRemoteFeedPayload &&
            _sameList(other.categories, categories) &&
            other.promotion == promotion &&
            _sameList(other.featuredRestaurants, featuredRestaurants);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(categories),
    promotion,
    Object.hashAll(featuredRestaurants),
  );

  @override
  String toString() {
    return 'HomeRemoteFeedPayload('
        'categories: $categories, '
        'promotion: $promotion, '
        'featuredRestaurants: $featuredRestaurants'
        ')';
  }

  static bool _sameList<T>(List<T> left, List<T> right) {
    if (identical(left, right)) {
      return true;
    }

    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }
}

class HomeRemoteException implements Exception {
  const HomeRemoteException({required this.message});

  final String message;

  @override
  String toString() => 'HomeRemoteException(message: $message)';
}

abstract interface class HomeRemoteDatasource {
  Future<HomeRemoteFeedPayload> getHomeFeed();
}

class SupabaseHomeRemoteDatasource implements HomeRemoteDatasource {
  const SupabaseHomeRemoteDatasource({
    required SupabaseClient client,
    HomeRemoteRowsLoader? categoryRowsLoader,
    HomeRemoteSingleRowLoader? promotionRowLoader,
    HomeRemoteRowsLoader? featuredRestaurantRowsLoader,
    HomeRemoteRowsLoader? restaurantCategoryLinkRowsLoader,
  }) : _client = client,
       _categoryRowsLoader = categoryRowsLoader,
       _promotionRowLoader = promotionRowLoader,
       _featuredRestaurantRowsLoader = featuredRestaurantRowsLoader,
       _restaurantCategoryLinkRowsLoader = restaurantCategoryLinkRowsLoader;

  static const _restaurantCategoriesTable = 'restaurant_categories';
  static const _restaurantsTable = 'restaurants';
  static const _restaurantCategoryLinksTable = 'restaurant_category_links';
  static const _homePromotionsTable = 'home_promotions';

  final SupabaseClient _client;
  final HomeRemoteRowsLoader? _categoryRowsLoader;
  final HomeRemoteSingleRowLoader? _promotionRowLoader;
  final HomeRemoteRowsLoader? _featuredRestaurantRowsLoader;
  final HomeRemoteRowsLoader? _restaurantCategoryLinkRowsLoader;

  @override
  Future<HomeRemoteFeedPayload> getHomeFeed() async {
    try {
      final categories = (await _loadCategoryRows())
          .map(HomeCategoryDto.fromRow)
          .toList(growable: false);
      final promotion = await _loadPromotion();
      final restaurants = (await _loadFeaturedRestaurantRows())
          .map(HomeRestaurantDto.fromRow)
          .toList(growable: false);
      final categoryIdsByRestaurantId = _groupCategoryIdsByRestaurantId(
        (await _loadRestaurantCategoryLinkRows())
            .map(_RestaurantCategoryLinkDto.fromRow),
      );

      final restaurantsWithCategories = restaurants
          .map(
            (restaurant) => restaurant.copyWith(
              categoryIds: categoryIdsByRestaurantId[restaurant.id] ?? const [],
            ),
          )
          .toList(growable: false);

      return HomeRemoteFeedPayload(
        categories: categories,
        promotion: promotion,
        featuredRestaurants: restaurantsWithCategories,
      );
    } on PostgrestException catch (error) {
      throw HomeRemoteException(message: error.message);
    } on FormatException catch (error) {
      throw HomeRemoteException(message: error.message);
    }
  }

  Future<List<Map<String, Object?>>> _loadCategoryRows() {
    final loader = _categoryRowsLoader;
    if (loader != null) {
      return loader();
    }

    return _selectRows(
      table: _restaurantCategoriesTable,
      columns: 'id, sort_order',
      orderBy: const ['sort_order'],
    );
  }

  Future<HomePromotionDto> _loadPromotion() async {
    final row = await (() {
      final loader = _promotionRowLoader;
      if (loader != null) {
        return loader();
      }

      return _selectMaybeSingleRow(
        table: _homePromotionsTable,
        columns:
            'id, image_asset_path, discount_percentage, is_free_delivery_enabled, sort_order',
        filters: const {'is_active': true},
        orderBy: const ['sort_order'],
      );
    })();

    if (row == null) {
      throw const HomeRemoteException(
        message: 'No active Home promotion row was returned by Supabase.',
      );
    }

    return HomePromotionDto.fromRow(row);
  }

  Future<List<Map<String, Object?>>> _loadFeaturedRestaurantRows() {
    final loader = _featuredRestaurantRowsLoader;
    if (loader != null) {
      return loader();
    }

    return _selectRows(
      table: _restaurantsTable,
      columns:
          'id, name, image_asset_path, rating, delivery_time_min_minutes, delivery_time_max_minutes, cuisine, sort_order',
      filters: const {'is_featured': true},
      orderBy: const ['sort_order'],
    );
  }

  Future<List<Map<String, Object?>>> _loadRestaurantCategoryLinkRows() {
    final loader = _restaurantCategoryLinkRowsLoader;
    if (loader != null) {
      return loader();
    }

    return _selectRows(
      table: _restaurantCategoryLinksTable,
      columns: 'restaurant_id, category_id, sort_order',
      orderBy: const ['restaurant_id', 'sort_order'],
    );
  }

  Future<List<Map<String, Object?>>> _selectRows({
    required String table,
    required String columns,
    Map<String, Object?> filters = const {},
    List<String> orderBy = const [],
  }) async {
    dynamic query = _client.from(table).select(columns);

    for (final entry in filters.entries) {
      query = query.eq(entry.key, entry.value);
    }

    for (final column in orderBy) {
      query = query.order(column);
    }

    final response = await query;
    return _castRows(response, table: table);
  }

  Future<Map<String, Object?>?> _selectMaybeSingleRow({
    required String table,
    required String columns,
    Map<String, Object?> filters = const {},
    List<String> orderBy = const [],
  }) async {
    dynamic query = _client.from(table).select(columns);

    for (final entry in filters.entries) {
      query = query.eq(entry.key, entry.value);
    }

    for (final column in orderBy) {
      query = query.order(column);
    }

    final response = await query.limit(1).maybeSingle();
    return _castMaybeSingleRow(response, table: table);
  }

  List<Map<String, Object?>> _castRows(
    Object? response, {
    required String table,
  }) {
    if (response is! List) {
      throw HomeRemoteException(
        message: 'Supabase returned an invalid row collection for "$table".',
      );
    }

    return response.map((row) => _castRow(row, table: table)).toList(
      growable: false,
    );
  }

  Map<String, Object?>? _castMaybeSingleRow(
    Object? response, {
    required String table,
  }) {
    if (response == null) {
      return null;
    }

    return _castRow(response, table: table);
  }

  Map<String, List<String>> _groupCategoryIdsByRestaurantId(
    Iterable<_RestaurantCategoryLinkDto> links,
  ) {
    final categoryIdsByRestaurantId = <String, List<String>>{};

    for (final link in links) {
      categoryIdsByRestaurantId
          .putIfAbsent(link.restaurantId, () => <String>[])
          .add(link.categoryId);
    }

    return categoryIdsByRestaurantId;
  }

  Map<String, Object?> _castRow(Object? row, {required String table}) {
    if (row is! Map) {
      throw HomeRemoteException(
        message: 'Supabase returned an invalid row for "$table".',
      );
    }

    return Map<String, Object?>.from(row);
  }
}

class _RestaurantCategoryLinkDto {
  const _RestaurantCategoryLinkDto({
    required this.restaurantId,
    required this.categoryId,
    required this.sortOrder,
  });

  factory _RestaurantCategoryLinkDto.fromRow(Map<String, Object?> row) {
    return _RestaurantCategoryLinkDto(
      restaurantId: _readString(row, key: 'restaurant_id'),
      categoryId: _readString(row, key: 'category_id'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String restaurantId;
  final String categoryId;
  final int sortOrder;

  static String _readString(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }

    throw FormatException('Expected a non-empty string for "$key".');
  }

  static int _readInt(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is int) {
      return value;
    }

    throw FormatException('Expected an int for "$key".');
  }
}
