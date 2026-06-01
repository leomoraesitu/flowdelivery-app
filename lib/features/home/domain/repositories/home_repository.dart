import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';

abstract interface class HomeRepository {
  HomeFeedContent getHomeFeedContent();
}
