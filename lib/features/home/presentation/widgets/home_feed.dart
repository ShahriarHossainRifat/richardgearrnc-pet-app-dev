import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useState;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/home/domain/entities/post.dart';
import 'package:petzy_app/features/home/presentation/providers/community_cursor_notifier.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Home feed widget showing community posts with infinite scroll pagination.
///
/// Displays posts from users in the community using cursor-based pagination.
/// Automatically loads more posts when user scrolls near the bottom.
class HomeFeed extends HookConsumerWidget {
  /// Creates a [HomeFeed] instance.
  const HomeFeed({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch<CommunityCursorState>(communityCursorProvider);
    final notifier = ref.read(communityCursorProvider.notifier);

    final scrollController = ScrollController();

    // Load first page on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.posts.isEmpty && state.isLoading == false) {
          notifier.loadFirstPage();
        }
      });

      return () => scrollController.dispose();
    }, <dynamic>[]);

    // Listen for scroll events to load more posts
    useEffect(() {
      void handleScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - AppConstants.scrollLoadMoreThreshold) {
          notifier.loadNextPage();
        }
      }

      scrollController.addListener(handleScroll);
      return () => scrollController.removeListener(handleScroll);
    }, [scrollController]);

    return RefreshIndicator(
      onRefresh: () => notifier.refreshFeed(),
      child: state.posts.isEmpty
          ? (state.isLoading == true
                ? const LoadingWidget()
                : (state.error != null
                      ? AppErrorWidget(
                          message: state.error ?? l10n.unknownError,
                          onRetry: () => notifier.loadFirstPage(),
                        )
                      : EmptyWidget(
                          message: l10n.noPostsFound,
                        )))
          : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: state.posts.length + (state.isLoading == true ? 1 : 0),
              itemBuilder: (final context, final index) {
                if (index == state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(),
                  );
                }

                final post = state.posts[index];
                return _PostCard(
                  post: post,
                  onLikeToggle: (final bool isLiked) => notifier.updatePostLike(post.id, isLiked),
                  onSaveToggle: (final bool isSaved) => notifier.updatePostSave(post.id, isSaved),
                );
              },
            ),
    );
  }
}

/// Individual post card in the feed.
class _PostCard extends HookConsumerWidget {
  /// Creates a [_PostCard] instance.
  const _PostCard({
    required this.post,
    required this.onLikeToggle,
    required this.onSaveToggle,
  });

  /// The post data.
  final Post post;

  /// Callback when like button is tapped.
  final Function(bool) onLikeToggle;

  /// Callback when save button is tapped.
  final Function(bool) onSaveToggle;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLiked = useState(post.isLiked);
    final isSaved = useState(post.isSaved);
    final currentImageIndex = useState(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header with user info
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppConstants.avatarRadiusMD,
                backgroundColor: context.colorScheme.primaryContainer,
                backgroundImage: post.user.image != null
                    ? CachedNetworkImageProvider(post.user.image!)
                    : null,
              ),
              const HorizontalSpace.sm(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.fullName,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      post.createdAt.timeAgo,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppIconButton(
                icon: Icons.more_vert,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Post image carousel
        if (post.media.isNotEmpty)
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: AppConstants.postImageHeight,
                color: context.colorScheme.surfaceContainer,
                child: CachedNetworkImage(
                  imageUrl: post.media[currentImageIndex.value],
                  fit: BoxFit.cover,
                  placeholder: (final context, final url) => const LoadingWidget(),
                  errorWidget: (final context, final url, final error) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              // Image indicator dots
              if (post.media.length > 1)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMD,
                      ),
                    ),
                    child: Text(
                      '${currentImageIndex.value + 1}/${post.media.length}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              // Image navigation arrows
              if (post.media.length > 1)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: AppIconButton(
                      icon: Icons.chevron_left,
                      onPressed: () {
                        if (currentImageIndex.value > 0) {
                          currentImageIndex.value--;
                        }
                      },
                    ),
                  ),
                ),
              if (post.media.length > 1)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: AppIconButton(
                      icon: Icons.chevron_right,
                      onPressed: () {
                        if (currentImageIndex.value < post.media.length - 1) {
                          currentImageIndex.value++;
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),

        // Post actions and stats
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      isLiked.value = !isLiked.value;
                      onLikeToggle(isLiked.value);
                    },
                    child: Row(
                      children: [
                        Icon(
                          isLiked.value ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked.value ? Colors.red : null,
                          size: AppConstants.iconSizeMD,
                        ),
                        const HorizontalSpace.xs(),
                        Text(
                          '${post.likeCount + (isLiked.value && !post.isLiked ? 1 : 0)}',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const HorizontalSpace.lg(),
                  Row(
                    children: [
                      const Icon(Icons.comment_outlined, size: 24),
                      const HorizontalSpace.xs(),
                      Text(
                        '${post.commentCount}',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const HorizontalSpace.lg(),
                  const Icon(Icons.share_outlined, size: 24),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      isSaved.value = !isSaved.value;
                      onSaveToggle(isSaved.value);
                    },
                    child: Icon(
                      isSaved.value ? Icons.bookmark : Icons.bookmark_outline,
                      size: AppConstants.iconSizeMD,
                    ),
                  ),
                ],
              ),
              const VerticalSpace.md(),

              // Post description
              Text(
                post.caption,
                style: context.textTheme.bodyMedium,
              ),
              const VerticalSpace.sm(),

              // Location
              if (post.location.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: AppConstants.iconSizeSM,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    const HorizontalSpace.xs(),
                    Text(
                      post.location,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

              const VerticalSpace.md(),

              // View comments link
              if (post.commentCount > 0)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View all ${post.commentCount} comment${post.commentCount > 1 ? 's' : ''}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Divider
        const Divider(height: 1, indent: 0, endIndent: 0),
      ],
    );
  }
}
