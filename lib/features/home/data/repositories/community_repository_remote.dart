import 'package:petzy_app/core/constants/api_endpoints.dart';
import 'package:petzy_app/core/network/api_client.dart';
import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/core/utils/logger.dart';
import 'package:petzy_app/features/home/domain/entities/community_feed_response.dart';
import 'package:petzy_app/features/home/domain/repositories/community_repository.dart';

/// Remote implementation of [CommunityRepository].
///
/// Handles API calls to fetch community posts with cursor-based pagination.
class CommunityRepositoryRemote implements CommunityRepository {
  /// Creates a [CommunityRepositoryRemote] instance.
  CommunityRepositoryRemote({required this.apiClient});

  /// API client for making requests.
  final ApiClient apiClient;

  /// Default page size for pagination.
  static const int _defaultLimit = 20;

  @override
  Future<Result<CommunityFeedResponse>> fetchCommunityPosts({
    final int limit = _defaultLimit,
    final String? cursor,
  }) async {
    try {
      final queryParams = {'limit': limit.toString()};
      if (cursor != null) {
        queryParams['cursor'] = cursor;
      }

      final response = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.communityAll,
        queryParameters: queryParams,
        fromJson: (final json) => json as Map<String, dynamic>,
      );

      return response.fold(
        onSuccess: (final data) {
          final feedData = data['data'] as Map<String, dynamic>;
          final communityFeed = CommunityFeedResponse.fromJson(feedData);
          return Success(communityFeed);
        },
        onFailure: Failure.new,
      );
    } catch (e) {
      AppLogger.instance.e('Error fetching community posts: $e');
      return Failure(
        UnexpectedException(message: 'Failed to fetch community posts: $e'),
      );
    }
  }
}
