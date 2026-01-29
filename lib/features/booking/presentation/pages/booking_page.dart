import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Placeholder page for the Booking feature.
///
/// This page will be expanded to include:
/// - Service categories (Pet Sitter, Market, School, Hotel)
/// - Booking history
/// - Upcoming appointments
class BookingPage extends HookConsumerWidget {
  /// Creates a [BookingPage] instance.
  const BookingPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'booking');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.booking),
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
                Icons.calendar_today,
                size: AppConstants.iconSizeXL,
                color: theme.colorScheme.primary,
              ),
            ),
            const VerticalSpace.lg(),
            Text(
              l10n.booking,
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
