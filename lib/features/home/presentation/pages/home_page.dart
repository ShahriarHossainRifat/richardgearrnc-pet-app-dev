import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/home/presentation/widgets/ai_chat_pill.dart';
import 'package:petzy_app/features/home/presentation/widgets/service_rail.dart';
import 'package:petzy_app/features/home/presentation/widgets/social_post_card.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Social Home Page with Instagram-style layout and Shorts/Home tabs.
///
/// Structure:
/// - Layer 1 (Pinned Header): Brand logo + Shorts/Home tabs + action icons
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

    // Track current tab (0 = Shorts, 1 = Home)
    final tabIndex = useState(1); // Default to Home tab

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'home');
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Layer 1: Premium pinned header with tabs
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 56,
            title: FadeIn(
              child: Text(
                'Petzy',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            actions: [
              // Login/Notification buttons with scale animation
              ScaleIn(
                delay: const Duration(milliseconds: 100),
                child: AppIconButton(
                  icon: Icons.notifications_outlined,
                  onPressed: () => context.pushRoute(AppRoute.notifications),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: SlideIn(
                  direction: SlideDirection.fromBottom,
                  delay: const Duration(milliseconds: 150),
                  child: AnimatedTabBar(
                    selectedIndex: tabIndex.value,
                    onTabChanged: (final index) {
                      if (index == 0) {
                        // Navigate to Shorts full-screen experience
                        context.pushRoute(AppRoute.shorts);
                      } else {
                        tabIndex.value = index;
                      }
                    },
                    tabs: const [
                      AnimatedTabItem(
                        icon: Icons.play_circle_outline,
                        label: 'Shorts',
                      ),
                      AnimatedTabItem(label: 'Home'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Layer 2: AI chat pill with entrance animation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: SlideIn(
                direction: SlideDirection.fromLeft,
                delay: const Duration(milliseconds: 200),
                child: FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: AiChatPill(
                    onTap: () => context.pushRoute(AppRoute.aiChat),
                  ),
                ),
              ),
            ),
          ),

          // Layer 2: Service rail with section header
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: FadeIn(
                    delay: const Duration(milliseconds: 250),
                    child: Text(
                      'Top Services',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const ServiceRail(),
              ],
            ),
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

          // Layer 3: Social feed with staggered animations
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (final context, final index) {
                // Demo posts - in production this would come from a provider
                final post = _mockPosts[index % _mockPosts.length];
                return FadeIn.staggered(
                  index: index,
                  baseDelay: const Duration(milliseconds: 80),
                  child: SocialPostCard(
                    username: post.username,
                    userAvatar: post.avatar,
                    timeAgo: post.timeAgo,
                    content: post.content ?? '',
                    imageUrl: post.imageUrl,
                    likes: post.likes,
                    comments: post.comments,
                  ),
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
      floatingActionButton: ScaleIn(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: () {
            ref.read(feedbackServiceProvider).showInfo(l10n.comingSoon);
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Mock data for demo posts with enhanced fields
final _mockPosts = [
  _MockPost(
    username: 'Sarah & Luna',
    handle: '@sarahluna',
    avatar: 'S',
    timeAgo: '2h ago',
    location: 'Central Dog Park',
    content: null,
    imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=600',
    likes: 128,
    comments: 24,
  ),
  _MockPost(
    username: 'Max & Charlie',
    handle: '@maxcharlie',
    avatar: 'M',
    timeAgo: '4h ago',
    location: 'Riverside Trail',
    content: 'Morning walk at the park. These two are inseparable! 🐾❤️',
    imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600',
    likes: 256,
    comments: 42,
  ),
  _MockPost(
    username: 'Whiskers Fan',
    handle: '@whiskersworld',
    avatar: 'W',
    timeAgo: '5h ago',
    location: null,
    content:
        'Anyone recommend a good vet in the area? Whiskers needs a checkup. Looking for someone experienced with senior cats 🐱',
    imageUrl: null,
    likes: 18,
    comments: 35,
  ),
  _MockPost(
    username: "Bella's Dad",
    handle: '@bellasdad',
    avatar: 'B',
    timeAgo: 'Yesterday',
    location: 'Pet Training Academy',
    content: 'Bella learned a new trick today! Proud pet parent moment 🎉',
    imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=600',
    likes: 389,
    comments: 67,
  ),
];

class _MockPost {
  const _MockPost({
    required this.username,
    required this.handle,
    required this.avatar,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    this.location,
  });

  final String username;
  final String handle;
  final String avatar;
  final String timeAgo;
  final String? location;
  final String? content;
  final String? imageUrl;
  final int likes;
  final int comments;
}
