import 'package:flutter/material.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Social post card widget for the home feed.
///
/// Displays a post with user info, content, optional image,
/// and action buttons (like, comment, share).
class SocialPostCard extends StatelessWidget {
  /// Creates a [SocialPostCard] instance.
  const SocialPostCard({
    required this.username,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.imageUrl,
    super.key,
  });

  /// Display name of the post author.
  final String username;

  /// Initial/avatar letter for the user.
  final String userAvatar;

  /// Time since post was created.
  final String timeAgo;

  /// Post text content.
  final String content;

  /// Optional image URL for the post.
  final String? imageUrl;

  /// Number of likes.
  final int likes;

  /// Number of comments.
  final int comments;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMD),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    userAvatar,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const HorizontalSpace.sm(),
                // Username and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        username,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  iconSize: AppConstants.iconSizeSM,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              content,
              style: theme.textTheme.bodyMedium,
            ),
          ),

          // Post image (if exists)
          if (imageUrl != null) ...[
            const VerticalSpace.sm(),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
              child: AppCachedImage(
                imageUrl: imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],

          // Action bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: [
                // Like button
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: likes.toString(),
                  onPressed: () {},
                ),
                const HorizontalSpace.md(),
                // Comment button
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: comments.toString(),
                  onPressed: () {},
                ),
                const HorizontalSpace.md(),
                // Share button
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: l10n.share,
                  onPressed: () {},
                ),
                const Spacer(),
                // Bookmark button
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  iconSize: AppConstants.iconSizeMD,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: AppConstants.iconSizeSM),
      label: Text(
        label,
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}
