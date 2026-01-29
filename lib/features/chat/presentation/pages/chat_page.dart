import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Placeholder page for the Chat/Messages feature.
///
/// This page will be expanded to include:
/// - Conversation list
/// - Message threads
/// - Real-time messaging
class ChatPage extends HookConsumerWidget {
  /// Creates a [ChatPage] instance.
  const ChatPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'chat');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chat),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble,
                size: AppConstants.iconSizeXL,
                color: theme.colorScheme.primary,
              ),
            ),
            const VerticalSpace.lg(),
            Text(
              l10n.chat,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalSpace.sm(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                l10n.comingSoon,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
