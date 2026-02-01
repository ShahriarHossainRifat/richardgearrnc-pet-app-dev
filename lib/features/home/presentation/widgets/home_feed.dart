import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/home/domain/entities/post.dart';

/// Individual post card in the feed.
class PostCard extends HookConsumerWidget {
  /// Creates a [PostCard] instance.
  const PostCard({
    required this.post,
    required this.onLikeToggle,
    required this.onSaveToggle,
  });

  /// The post data.
  final Post post;

  /// Callback when like button is tapped.
  final void Function(bool) onLikeToggle;

  /// Callback when save button is tapped.
  final void Function(bool) onSaveToggle;

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
                  placeholder: (final context, final url) =>
                      const LoadingWidget(),
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
                          isLiked.value
                              ? Icons.favorite
                              : Icons.favorite_outline,
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
