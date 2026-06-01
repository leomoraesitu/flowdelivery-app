import 'package:flowdelivery_app/features/home/data/fixtures/home_feed_fixtures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeFeedProvider = Provider<HomeFeedContent>((ref) {
  return homeFeedFixtureContent;
});
