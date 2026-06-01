import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const FixtureHomeRepository();
});

final homeFeedAsyncProvider = FutureProvider<HomeFeedContent>((ref) {
  return ref.watch(homeRepositoryProvider).getHomeFeedContent();
});

final homeFeedProvider = Provider<HomeFeedContent>((ref) {
  return ref.watch(homeFeedAsyncProvider).asData?.value ?? homeFeedFixtureContent;
});
