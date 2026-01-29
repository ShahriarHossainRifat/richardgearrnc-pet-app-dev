import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/home/presentation/widgets/ai_chat_pill.dart';
import 'package:petzy_app/features/home/presentation/widgets/service_rail.dart';
import 'package:petzy_app/features/home/presentation/widgets/social_post_card.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Social Home Page with Instagram-style layout.
///
/// Structure:
/// - Layer 1 (Pinned Header): Brand logo + action icons
/// - Layer 2 (Scrollable): AI chat pill + Service rail
/// - Layer 3 (Infinite Feed): Social posts
class HomePage extends HookConsumerWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);
    final colorScheme = context.colorScheme;

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'home');
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Layer 1: Pinned header with brand and actions
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'PUPPIsh',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            actions: [
              // QR Scanner button
              AppIconButton(
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  // TODO: Implement QR scanner
                  ref.read(feedbackServiceProvider).showInfo(l10n.comingSoon);
                },
              ),
              // Notifications button
              AppIconButton(
                icon: Icons.notifications_outlined,
                onPressed: () => context.pushRoute(AppRoute.notifications),
              ),
            ],
          ),

          // Layer 2: AI chat pill
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: AiChatPill(
                onTap: () => context.pushRoute(AppRoute.aiChat),
              ),
            ),
          ),

          // Layer 2: Service rail (horizontal scroll)
          const SliverToBoxAdapter(
            child: ServiceRail(),
          ),

          // Divider before feed
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),

          // Layer 3: Social feed
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (final context, final index) {
                // Demo posts - in production this would come from a provider
                return SocialPostCard(
                  username: _mockPosts[index % _mockPosts.length].username,
                  userAvatar: _mockPosts[index % _mockPosts.length].avatar,
                  timeAgo: _mockPosts[index % _mockPosts.length].timeAgo,
                  content: _mockPosts[index % _mockPosts.length].content,
                  imageUrl: _mockPosts[index % _mockPosts.length].imageUrl,
                  likes: _mockPosts[index % _mockPosts.length].likes,
                  comments: _mockPosts[index % _mockPosts.length].comments,
                );
              },
              childCount: 10, // Demo: show 10 posts
            ),
          ),

          // Bottom padding for FAB clearance
          const SliverToBoxAdapter(
            child: VerticalSpace.xl(),
          ),
        ],
      ),
      // Floating action button for creating posts
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(feedbackServiceProvider).showInfo(l10n.comingSoon);
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Mock data for demo posts
final _mockPosts = [
  _MockPost(
    username: 'Luna\'s Mom',
    avatar: 'L',
    timeAgo: '2h ago',
    content:
        'Luna had her first grooming session today! She was such a good girl. 🐕✨',
    imageUrl: null,
    likes: 24,
    comments: 5,
  ),
  _MockPost(
    username: 'Max & Charlie',
    avatar: 'M',
    timeAgo: '4h ago',
    content: 'Morning walk at the park. These two are inseparable! 🐾❤️',
    imageUrl:
        'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
    likes: 56,
    comments: 12,
  ),
  _MockPost(
    username: 'Whiskers Fan',
    avatar: 'W',
    timeAgo: '5h ago',
    content:
        'Anyone recommend a good vet in the area? Whiskers needs a checkup.',
    imageUrl: null,
    likes: 8,
    comments: 15,
  ),
  _MockPost(
    username: 'Bella\'s Dad',
    avatar: 'B',
    timeAgo: 'Yesterday',
    content: 'Bella learned a new trick today! Proud pet parent moment 🎉',
    imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400',
    likes: 89,
    comments: 23,
  ),
];

class _MockPost {
  const _MockPost({
    required this.username,
    required this.avatar,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });

  final String username;
  final String avatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
}
