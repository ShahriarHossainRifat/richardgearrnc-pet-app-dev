import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/home/domain/entities/community_feed_response.dart';

/// Repository interface for community posts.
abstract class CommunityRepository {
  /// Fetch community posts with optional cursor for pagination.
  ///
  /// [limit] - Number of posts to fetch (default: 20)
  /// [cursor] - Cursor for pagination (null for first page)
  ///
  /// Returns [CommunityFeedResponse] with posts and next cursor.
  Future<Result<CommunityFeedResponse>> fetchCommunityPosts({
    final int limit = 20,
    final String? cursor,
  });
}
