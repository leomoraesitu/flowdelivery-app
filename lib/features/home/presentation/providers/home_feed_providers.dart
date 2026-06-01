import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const _StaticHomeRepository();
});

final homeFeedProvider = Provider<HomeFeedContent>((ref) {
  return ref.watch(homeRepositoryProvider).getHomeFeedContent();
});

class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository();

  @override
  HomeFeedContent getHomeFeedContent() {
    return homeFeedFixtureContent;
  }
}
