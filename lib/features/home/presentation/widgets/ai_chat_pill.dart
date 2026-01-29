import 'package:flutter/material.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// AI Chat pill widget that prompts users to interact with the pet health assistant.
///
/// Displays a visually prominent call-to-action that leads to the AI chat feature.
class AiChatPill extends StatelessWidget {
  /// Creates an [AiChatPill] instance.
  const AiChatPill({
    required this.onTap,
    super.key,
  });

  /// Callback when the pill is tapped.
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primaryContainer.withValues(alpha: 0.7),
            ],
            begin: .centerLeft,
            end: .centerRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusFull),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // AI icon with avatar style
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: AppConstants.iconSizeSM,
                color: colorScheme.onPrimary,
              ),
            ),
            const HorizontalSpace.sm(),
            // Prompt text
            Expanded(
              child: Text(
                l10n.aiChatPrompt,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const HorizontalSpace.xs(),
            // Chevron icon
            Icon(
              Icons.chevron_right,
              size: AppConstants.iconSizeSM,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
