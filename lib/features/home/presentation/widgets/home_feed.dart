import 'package:flutter/material.dart';
import 'package:petzy_app/core/extensions/extensions.dart';

/// Home feed widget showing posts.
///
/// Displays posts from users in the community.
class HomeFeed extends StatelessWidget {
  /// Creates a [HomeFeed] instance.
  const HomeFeed({super.key});

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _mockPosts.length,
      itemBuilder: (final context, final index) {
        final post = _mockPosts[index];
        return _PostCard(post: post);
      },
    );
  }
}

/// Individual post card in the feed.
class _PostCard extends StatefulWidget {
  const _PostCard({required this.post});

  final _Post post;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header with user info
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.colorScheme.primaryContainer,
                backgroundImage: NetworkImage(widget.post.userImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.post.timeAgo,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Post image
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            image: DecorationImage(
              image: NetworkImage(widget.post.postImage),
              fit: BoxFit.cover,
            ),
          ),
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
                      setState(() => _isLiked = !_isLiked);
                    },
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: _isLiked ? Colors.red : null,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.post.likes}',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      const Icon(Icons.comment_outlined, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.post.comments}',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.share_outlined, size: 24),
                  const Spacer(),
                  const Icon(Icons.bookmark_outline, size: 24),
                ],
              ),
              const SizedBox(height: 12),

              // Post description
              Text(
                widget.post.description,
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),

              // View comments link
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all ${widget.post.comments} comments',
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

/// Mock post data.
class _Post {
  const _Post({
    required this.username,
    required this.userImage,
    required this.timeAgo,
    required this.description,
    required this.postImage,
    required this.likes,
    required this.comments,
  });

  final String username;
  final String userImage;
  final String timeAgo;
  final String description;
  final String postImage;
  final int likes;
  final int comments;
}

/// Mock posts data.
final _mockPosts = [
  const _Post(
    username: 'Sarah',
    userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    timeAgo: '2h ago',
    description:
        'Luna had the best time at the dog park today! She made so many new friends and even learned to fetch... 🌳🐶',
    postImage: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=800', // Dog park
    likes: 324,
    comments: 28,
  ),
  const _Post(
    username: 'Mike & Rocky',
    userImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    timeAgo: '4h ago',
    description:
        'Training session went great! Rocky is learning to sit and stay. #dogtraining #goodboy',
    postImage: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800', // Dog training
    likes: 156,
    comments: 12,
  ),
  const _Post(
    username: 'Bella Grooming',
    userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    timeAgo: '6h ago',
    description: 'Fresh cut for this little guy! ✂️🐩 Call us to book your appointment today!',
    postImage: 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=800', // Dog grooming
    likes: 412,
    comments: 45,
  ),
];
