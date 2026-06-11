import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';

const restaurantDetailsFixture = RestaurantDetails(
  id: 'burger_artisan_collective',
  name: 'Burger Artisan Collective',
  imageAssetPath: 'assets/images/restaurant.png',
  rating: 4.8,
  deliveryTimeMinMinutes: 25,
  deliveryTimeMaxMinutes: 35,
  cuisine: 'american',
  categories: [
    RestaurantMenuCategory(id: 'popular'),
    RestaurantMenuCategory(id: 'burgers'),
    RestaurantMenuCategory(id: 'sides'),
  ],
  items: [
    RestaurantMenuItem(
      id: 'signature_truffle',
      categoryId: 'burgers',
      name: 'The Signature Truffle',
      description: 'Wagyu beef with truffle aioli.',
      imageAssetPath: 'assets/images/signature-truffle.png',
      priceInCents: 1850,
    ),
    RestaurantMenuItem(
      id: 'classic_cheeseburger',
      categoryId: 'burgers',
      name: 'Classic Cheeseburger',
      description: 'Hand-smashed patty with sharp cheddar.',
      imageAssetPath: 'assets/images/classic-cheeseburger.png',
      priceInCents: 1450,
    ),
    RestaurantMenuItem(
      id: 'truffle_fries',
      categoryId: 'sides',
      name: 'Truffle Fries',
      description: 'Hand-cut fries with truffle salt and parmesan.',
      imageAssetPath: 'assets/images/truffle-fries.png',
      priceInCents: 650,
    ),
  ],
);
