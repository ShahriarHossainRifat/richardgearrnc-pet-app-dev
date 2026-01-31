import 'package:flutter/material.dart';
import 'package:petzy_app/core/core.dart';

/// Overlay UI for Shorts with action buttons and user info.
///
/// Displays:
/// - Right-side action buttons (like, comment, share, bookmark)
/// - Bottom user info and description
/// - Animated like heart on double-tap
class ShortsOverlay extends StatelessWidget {
  /// Creates a [ShortsOverlay].
  const ShortsOverlay({
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
    super.key,
  });

  /// Username of the video creator.
  final String username;

  /// Video description/caption.
  final String description;

  /// Number of likes.
  final int likes;

  /// Number of comments.
  final int comments;

  /// Number of shares.
  final int shares;

  String _formatCount(final int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        // Right-side action buttons
        Positioned(
          right: AppSpacing.md,
          bottom: 120,
          child: Column(
            children: [
              _ActionButton(
                icon: Icons.favorite_border,
                label: _formatCount(likes),
                onTap: () {},
              ),
              const VerticalSpace.md(),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: _formatCount(comments),
                onTap: () {},
              ),
              const VerticalSpace.md(),
              _ActionButton(
                icon: Icons.share,
                label: _formatCount(shares),
                onTap: () {},
              ),
              const VerticalSpace.md(),
              _ActionButton(
                icon: Icons.bookmark_border,
                label: 'Save',
                onTap: () {},
              ),
              const VerticalSpace.md(),
              _ActionButton(
                icon: Icons.more_horiz,
                label: '',
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom user info and description
        Positioned(
          left: AppSpacing.md,
          right: 80,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username row
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      username.isNotEmpty ? username[1].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const HorizontalSpace.sm(),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const HorizontalSpace.sm(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace.sm(),
              // Description
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const VerticalSpace.md(),
              // Sound/Music row
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 14),
                  const HorizontalSpace.xs(),
                  Expanded(
                    child: Text(
                      '$username · Original Audio',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
