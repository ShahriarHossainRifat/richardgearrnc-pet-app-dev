import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Placeholder page for Profile feature.
///
/// This serves as the main Profile tab in the bottom navigation.
/// Provides access to settings, account management, and user info.
class ProfilePage extends HookConsumerWidget {
  /// Creates a [ProfilePage] instance.
  const ProfilePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'profile');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
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
                Icons.person,
                size: AppConstants.iconSizeXL,
                color: theme.colorScheme.primary,
              ),
            ),
            const VerticalSpace.lg(),
            Text(
              l10n.profile,
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
