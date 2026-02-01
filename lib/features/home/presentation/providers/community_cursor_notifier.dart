import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:petzy_app/features/home/domain/entities/post.dart';
import 'package:petzy_app/features/home/data/repositories/community_repository_provider.dart';

part 'community_cursor_notifier.freezed.dart';
part 'community_cursor_notifier.g.dart';

/// Freezed state for paginated community posts.
@freezed
abstract class CommunityCursorState with _$CommunityCursorState {
  /// Creates a [CommunityCursorState] instance.
  const factory CommunityCursorState({
    required final List<Post> posts,
    required final String? nextCursor,
    required final bool hasMore,
    required final bool isLoading,
    required final String? error,
  }) = _CommunityCursorState;
}

/// Riverpod notifier for managing paginated community posts with cursor-based pagination.
@riverpod
class CommunityCursor extends _$CommunityCursor {
  @override
  CommunityCursorState build() {
    return const CommunityCursorState(
      posts: [],
      nextCursor: null,
      hasMore: true,
      isLoading: false,
      error: null,
    );
  }

  /// Page size for pagination.
  static const int _pageSize = 20;

  /// Load the first page of posts.
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(communityRepositoryProvider);
    final result = await repository.fetchCommunityPosts(limit: _pageSize);

    result.fold(
      onSuccess: (final response) {
        state = CommunityCursorState(
          posts: response.items,
          nextCursor: response.nextCursor,
          hasMore: response.nextCursor != null,
          isLoading: false,
          error: null,
        );
      },
      onFailure: (final error) {
        state = state.copyWith(
          isLoading: false,
          error: error.toString(),
        );
      },
    );
  }

  /// Load the next page of posts.
  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final repository = ref.read(communityRepositoryProvider);
    final result = await repository.fetchCommunityPosts(
      limit: _pageSize,
      cursor: state.nextCursor,
    );

    result.fold(
      onSuccess: (final response) {
        state = CommunityCursorState(
          posts: [...state.posts, ...response.items],
          nextCursor: response.nextCursor,
          hasMore: response.nextCursor != null,
          isLoading: false,
          error: null,
        );
      },
      onFailure: (final error) {
        state = state.copyWith(
          isLoading: false,
          error: error.toString(),
        );
      },
    );
  }

  /// Refresh the feed (reload from first page).
  Future<void> refreshFeed() async {
    state = const CommunityCursorState(
      posts: [],
      nextCursor: null,
      hasMore: true,
      isLoading: false,
      error: null,
    );
    await loadFirstPage();
  }

  /// Update like status for a post.
  void updatePostLike(final String postId, final bool isLiked) {
    final updatedPosts = state.posts
        .map(
          (final Post post) => post.id == postId
              ? post.copyWith(
                  isLiked: isLiked,
                  likeCount: isLiked ? post.likeCount + 1 : post.likeCount - 1,
                )
              : post,
        )
        .toList();

    state = state.copyWith(posts: updatedPosts);
  }

  /// Update save status for a post.
  void updatePostSave(final String postId, final bool isSaved) {
    final updatedPosts = state.posts
        .map(
          (final Post post) =>
              post.id == postId ? post.copyWith(isSaved: isSaved) : post,
        )
        .toList();

    state = state.copyWith(posts: updatedPosts);
  }
}
