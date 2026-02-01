import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/home/domain/entities/comment.dart';
import 'package:petzy_app/features/home/presentation/widgets/comment_item.dart';

/// Callback type for adding a new comment.
typedef OnAddComment = Future<void> Function(String text);

/// Callback type for liking/unliking a comment.
typedef OnCommentLikeToggle = Future<void> Function(String commentId, bool isLiked);

/// Bottom sheet for viewing and adding comments to a post.
class CommentsBottomSheet extends HookConsumerWidget {
  /// Creates a [CommentsBottomSheet] instance.
  const CommentsBottomSheet({
    required this.comments,
    required this.onAddComment,
    required this.onCommentLikeToggle,
    this.isLoading = false,
  });

  /// List of comments to display.
  final List<Comment> comments;

  /// Callback when a new comment is added.
  final OnAddComment onAddComment;

  /// Callback when a comment is liked/unliked.
  final OnCommentLikeToggle onCommentLikeToggle;

  /// Whether comments are currently being loaded.
  final bool isLoading;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final commentController = useTextController();
    final isSubmitting = useState(false);

    useEffect(() {
      return () => commentController.dispose();
    }, []);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (final context, final scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadiusLG),
              topRight: Radius.circular(AppConstants.borderRadiusLG),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments (${comments.length})',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.close,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Comments list
              Expanded(
                child: isLoading
                    ? const LoadingWidget()
                    : comments.isEmpty
                    ? Center(
                        child: Text(
                          'No comments yet. Be the first!',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: comments.length,
                        separatorBuilder: (final _, final __) => const Divider(height: 1),
                        itemBuilder: (final context, final index) {
                          final comment = comments[index];
                          return CommentItem(
                            comment: comment,
                            onLikeToggle: (final isLiked) {
                              onCommentLikeToggle(comment.id, isLiked);
                            },
                          );
                        },
                      ),
              ),

              // Divider before input
              const Divider(height: 1),

              // Comment input field
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: 12 + MediaQuery.of(context).viewInsets.bottom, // Account for keyboard
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        enabled: !isSubmitting.value,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMD),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const HorizontalSpace.sm(),
                    AppIconButton(
                      icon: Icons.send_outlined,
                      isLoading: isSubmitting.value,
                      onPressed: commentController.text.isEmpty || isSubmitting.value
                          ? null
                          : () async {
                              isSubmitting.value = true;
                              try {
                                await onAddComment(commentController.text);
                                commentController.clear();
                              } finally {
                                isSubmitting.value = false;
                              }
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
