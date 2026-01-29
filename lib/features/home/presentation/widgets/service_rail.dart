import 'package:flutter/material.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Horizontal service rail showing quick shortcuts to pet services.
///
/// Displays service avatars for: Pet Sitter, Market, School, Hotel.
class ServiceRail extends StatelessWidget {
  /// Creates a [ServiceRail] instance.
  const ServiceRail({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final services = [
      _ServiceItem(
        icon: Icons.pets,
        label: l10n.serviceSitter,
        color: const Color(0xFFFF6B72),
        onTap: () => context.pushRoute(AppRoute.booking),
      ),
      _ServiceItem(
        icon: Icons.shopping_bag_outlined,
        label: l10n.serviceMarket,
        color: const Color(0xFF4CAF50),
        onTap: () => context.pushRoute(AppRoute.booking),
      ),
      _ServiceItem(
        icon: Icons.school_outlined,
        label: l10n.serviceSchool,
        color: const Color(0xFF2196F3),
        onTap: () => context.pushRoute(AppRoute.booking),
      ),
      _ServiceItem(
        icon: Icons.hotel_outlined,
        label: l10n.serviceHotel,
        color: const Color(0xFF9C27B0),
        onTap: () => context.pushRoute(AppRoute.booking),
      ),
      _ServiceItem(
        icon: Icons.more_horiz,
        label: l10n.serviceMore,
        color: const Color(0xFF607D8B),
        onTap: () => context.pushRoute(AppRoute.booking),
      ),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: services.length,
        separatorBuilder: (_, final __) => const HorizontalSpace.md(),
        itemBuilder: (final context, final index) {
          return _ServiceAvatar(service: services[index]);
        },
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar({required this.service});

  final _ServiceItem service;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return GestureDetector(
      onTap: service.onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular avatar with gradient border
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    service.color,
                    service.color.withValues(alpha: 0.6),
                  ],
                  begin: .topLeft,
                  end: .bottomRight,
                ),
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                ),
                child: Icon(
                  service.icon,
                  color: service.color,
                  size: AppConstants.iconSizeMD,
                ),
              ),
            ),
            const VerticalSpace.xs(),
            // Label
            Text(
              service.label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
