import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/shorts/presentation/widgets/shorts_video_widget.dart';

/// Full-screen immersive Shorts experience with vertical scrolling.
///
/// Features:
/// - TikTok-style vertical PageView scrolling
/// - Video preloading for smooth playback
/// - Swipe down gesture to dismiss
/// - Overlay UI for interactions (like, comment, share)
class ShortsPage extends HookConsumerWidget {
  /// Creates a [ShortsPage] instance.
  const ShortsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Track current page index for preloading logic
    final currentIndex = useState(0);

    // Track screen view
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'shorts');
      // Enter immersive mode
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        ),
      );
    });

    // Demo shorts data - in production this would come from a provider
    final shorts = _mockShorts;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Shorts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        onPageChanged: (final index) => currentIndex.value = index,
        physics: const BouncingScrollPhysics(),
        itemCount: shorts.length,
        itemBuilder: (final context, final index) {
          final short = shorts[index];
          return ShortsVideoWidget(
            videoUrl: short.videoUrl,
            username: short.username,
            description: short.description,
            likes: short.likes,
            comments: short.comments,
            shares: short.shares,
            isPlaying: index == currentIndex.value,
          );
        },
      ),
    );
  }
}

// Mock data for demo shorts
final _mockShorts = [
  _MockShort(
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    username: '@petlover123',
    description: 'My golden retriever learning a new trick! 🐕✨ #DogTricks #PetTraining',
    likes: 12500,
    comments: 342,
    shares: 89,
  ),
  _MockShort(
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    username: '@catlady_jane',
    description: 'Cat vs. cucumber challenge... watch the ending! 😂 #FunnyCats',
    likes: 45200,
    comments: 1203,
    shares: 567,
  ),
  _MockShort(
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    username: '@pawsome_adventures',
    description: 'Weekend hike with my best friend 🐾🌲 #AdventurePets',
    likes: 8900,
    comments: 156,
    shares: 42,
  ),
];

class _MockShort {
  const _MockShort({
    required this.videoUrl,
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  final String videoUrl;
  final String username;
  final String description;
  final int likes;
  final int comments;
  final int shares;
}
