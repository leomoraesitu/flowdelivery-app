import 'dart:async';

import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('homeFeedAsyncProvider', () {
    test('resolves feed content through the repository contract', () async {
      final expectedContent = HomeFeedContent(
        deliveryAddress: 'Avenida Brasil, 1000',
        categories: const [HomeCategory(id: 'all')],
        promotion: const HomePromotion(
          id: 'promotion-1',
          imageAssetPath: 'assets/images/promo.png',
          discountPercentage: 20,
          hasFreeDelivery: true,
        ),
        featuredRestaurants: [
          HomeRestaurant(
            id: 'restaurant-1',
            name: 'Remote Restaurant',
            imageAssetPath: 'assets/images/restaurant.png',
            rating: 4.8,
            deliveryTimeMinMinutes: 18,
            deliveryTimeMaxMinutes: 28,
            cuisine: 'fusion',
            categoryIds: const ['all'],
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _FakeHomeRepository(() async => expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(homeFeedAsyncProvider.future),
        completion(expectedContent),
      );
    });

    test(
      'keeps the fixture content as a compatibility fallback while async data is loading',
      () async {
        final completer = Completer<HomeFeedContent>();
        final expectedContent = HomeFeedContent(
          deliveryAddress: 'Avenida Brasil, 1000',
          categories: const [HomeCategory(id: 'all')],
          promotion: const HomePromotion(
            id: 'promotion-1',
            imageAssetPath: 'assets/images/promo.png',
            discountPercentage: 20,
            hasFreeDelivery: true,
          ),
          featuredRestaurants: [
            HomeRestaurant(
              id: 'restaurant-1',
              name: 'Remote Restaurant',
              imageAssetPath: 'assets/images/restaurant.png',
              rating: 4.8,
              deliveryTimeMinMinutes: 18,
              deliveryTimeMaxMinutes: 28,
              cuisine: 'fusion',
              categoryIds: const ['all'],
            ),
          ],
        );
        final container = ProviderContainer(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _FakeHomeRepository(() => completer.future),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(homeFeedProvider), homeFeedFixtureContent);
        expect(container.read(homeFeedAsyncProvider).isLoading, isTrue);

        completer.complete(expectedContent);
        await container.read(homeFeedAsyncProvider.future);

        expect(container.read(homeFeedProvider), expectedContent);
      },
    );

    test(
      'keeps the fixture content as a compatibility fallback when async loading fails',
      () async {
        final container = ProviderContainer(
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              _FakeHomeRepository(() async => throw StateError('boom')),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(homeFeedProvider), homeFeedFixtureContent);
        await expectLater(
          container.read(homeFeedAsyncProvider.future),
          throwsA(isA<StateError>()),
        );
        expect(container.read(homeFeedProvider), homeFeedFixtureContent);
      },
    );
  });
}

class _FakeHomeRepository implements HomeRepository {
  const _FakeHomeRepository(this.loader);

  final Future<HomeFeedContent> Function() loader;

  @override
  Future<HomeFeedContent> getHomeFeedContent() {
    return loader();
  }
}
