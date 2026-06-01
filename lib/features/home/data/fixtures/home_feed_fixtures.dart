import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';

class HomeFeedContent {
  HomeFeedContent({
    required this.deliveryAddress,
    required List<HomeCategory> categories,
    required this.promotion,
    required List<HomeRestaurant> featuredRestaurants,
  }) : categories = List.unmodifiable(categories),
       featuredRestaurants = List.unmodifiable(featuredRestaurants);

  final String deliveryAddress;
  final List<HomeCategory> categories;
  final HomePromotion promotion;
  final List<HomeRestaurant> featuredRestaurants;
}

final homeFeedFixtureContent = HomeFeedContent(
  deliveryAddress: 'Rua das Flores, 42',
  categories: const [
    HomeCategory(id: 'all'),
    HomeCategory(id: 'burgers'),
    HomeCategory(id: 'pizza'),
    HomeCategory(id: 'sushi'),
    HomeCategory(id: 'healthy'),
  ],
  promotion: const HomePromotion(
    id: 'weekend_pizza_party',
    imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
    discountPercentage: 30,
    hasFreeDelivery: true,
  ),
  featuredRestaurants: [
    HomeRestaurant(
      id: 'burger_artisan_collective',
      name: 'Burger Artisan Collective',
      imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
      rating: 4.8,
      deliveryTimeMinMinutes: 25,
      deliveryTimeMaxMinutes: 35,
      cuisine: 'american',
      categoryIds: const ['all', 'burgers'],
    ),
    HomeRestaurant(
      id: 'pasta_roma',
      name: 'Pasta Roma',
      imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
      rating: 4.6,
      deliveryTimeMinMinutes: 30,
      deliveryTimeMaxMinutes: 45,
      cuisine: 'italian',
      categoryIds: const ['all', 'healthy'],
    ),
    HomeRestaurant(
      id: 'sushi_zen',
      name: 'Sushi Zen',
      imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
      rating: 4.9,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 30,
      cuisine: 'japanese',
      categoryIds: const ['all', 'sushi'],
    ),
    HomeRestaurant(
      id: 'taco_harbor',
      name: 'Taco Harbor',
      imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
      rating: 4.5,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 30,
      cuisine: 'mexican',
      categoryIds: const ['all', 'healthy'],
    ),
  ],
);
