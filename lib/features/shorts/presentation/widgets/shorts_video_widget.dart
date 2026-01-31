import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/shorts/presentation/widgets/shorts_overlay.dart';

/// Individual video widget for a short with player and overlay.
///
/// Handles:
/// - Video initialization and playback
/// - Tap to pause/play interaction
/// - Loop playback
/// - Loading state with shimmer
class ShortsVideoWidget extends StatefulWidget {
  /// Creates a [ShortsVideoWidget].
  const ShortsVideoWidget({
    required this.videoUrl,
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isPlaying,
    super.key,
  });

  /// URL of the video to play.
  final String videoUrl;

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

  /// Whether this video should be playing.
  final bool isPlaying;

  @override
  State<ShortsVideoWidget> createState() => _ShortsVideoWidgetState();
}

class _ShortsVideoWidgetState extends State<ShortsVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPaused = false;
  bool _showPauseIcon = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await _controller.initialize();
    _controller.setLooping(true);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });

      if (widget.isPlaying) {
        _controller.play();
      }
    }
  }

  @override
  void didUpdateWidget(final ShortsVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && !_isPaused) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPaused = true;
        _showPauseIcon = true;
      } else {
        _controller.play();
        _isPaused = false;
        _showPauseIcon = true;
      }
    });

    // Hide the pause icon after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showPauseIcon = false;
        });
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player or loading state
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            _buildLoadingState(),

          // Play/Pause indicator
          if (_showPauseIcon)
            Center(
              child: AnimatedOpacity(
                opacity: _showPauseIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Gradient overlay at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Overlay UI (user info, action buttons)
          ShortsOverlay(
            username: widget.username,
            description: widget.description,
            likes: widget.likes,
            comments: widget.comments,
            shares: widget.shares,
          ),

          // Video progress indicator
          if (_isInitialized)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white.withValues(alpha: 0.3),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
