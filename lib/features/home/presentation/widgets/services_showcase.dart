import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petzy_app/core/extensions/extensions.dart';

import '../../../../app/router/app_router.dart';

/// Top services showcase widget.
///
/// Displays the 4 main services: Pet Sitter, Pet Market, Pet School, Pet Hotel.
/// This matches the screenshot design.
class ServicesShowcase extends StatelessWidget {
  /// Creates a [ServicesShowcase] instance.
  const ServicesShowcase({super.key});

  @override
  Widget build(final BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 32),
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _ServiceCard(
          icon: Icons.person_outline,
          label: 'Pet sitter',
          onTap: () => context.goNamed(AppRoute.petSitter.name),
        ),
        _ServiceCard(
          icon: Icons.shopping_bag_outlined,
          label: 'Pet Market',
          onTap: () => context.goNamed(AppRoute.petMarket.name),
        ),
        _ServiceCard(
          icon: Icons.school_outlined,
          label: 'Pet school',
          onTap: () {},
        ),
        _ServiceCard(
          icon: Icons.hotel_outlined,
          label: 'Pet hotel',
          onTap: () {},
        ),
      ],
    );
  }
}

/// Individual service card in the showcase.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
