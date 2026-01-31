import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Adaptive navigation scaffold that displays:
/// - Bottom NavigationBar on mobile (< 600dp)
/// - Side NavigationRail on tablet/desktop (≥ 600dp)
///
/// This widget wraps around the main navigation branches and handles
/// tab switching with state preservation via [StatefulNavigationShell].
class AdaptiveScaffold extends StatelessWidget {
  /// Creates an [AdaptiveScaffold] instance.
  const AdaptiveScaffold({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell that manages the current branch's widget tree.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(final BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width >= 600;
    final l10n = AppLocalizations.of(context);
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Side Navigation Rail for wide screens
          if (isWideScreen)
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 800,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: MediaQuery.sizeOf(context).width >= 800
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              indicatorColor: colorScheme.primaryContainer,
              destinations: _buildRailDestinations(l10n),
            ),

          // Divider between rail and content
          if (isWideScreen) const VerticalDivider(thickness: 1, width: 1),

          // Main content area
          Expanded(child: navigationShell),
        ],
      ),
      // Bottom Navigation Bar for narrow screens
      bottomNavigationBar: isWideScreen
          ? null
          : _buildBottomNavigationBar(context, l10n, colorScheme),
    );
  }

  Widget _buildBottomNavigationBar(
    final BuildContext context,
    final AppLocalizations l10n,
    final ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          height: AppConstants.bottomNavHeight,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          indicatorColor: colorScheme.primaryContainer,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLG),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          animationDuration: AppConstants.animationNormal,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _buildNavDestinations(l10n, colorScheme),
        ),
      ),
    );
  }

  List<NavigationDestination> _buildNavDestinations(
    final AppLocalizations l10n,
    final ColorScheme colorScheme,
  ) {
    // Use onPrimaryContainer for selected icons (white) for contrast
    // against the primaryContainer indicator background
    final selectedIconColor = colorScheme.onPrimaryContainer;
    final unselectedIconColor = colorScheme.onSurfaceVariant;

    return [
      NavigationDestination(
        icon: Icon(Icons.home_outlined, color: unselectedIconColor),
        selectedIcon: Icon(Icons.home, color: selectedIconColor),
        label: l10n.home,
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined, color: unselectedIconColor),
        selectedIcon: Icon(Icons.calendar_today, color: selectedIconColor),
        label: l10n.booking,
      ),
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline, color: unselectedIconColor),
        selectedIcon: Icon(Icons.chat_bubble, color: selectedIconColor),
        label: l10n.chat,
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline, color: unselectedIconColor),
        selectedIcon: Icon(Icons.person, color: selectedIconColor),
        label: l10n.profile,
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(
    final AppLocalizations l10n,
  ) {
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: Text(l10n.home),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.calendar_today_outlined),
        selectedIcon: const Icon(Icons.calendar_today),
        label: Text(l10n.booking),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.chat_bubble_outline),
        selectedIcon: const Icon(Icons.chat_bubble),
        label: Text(l10n.chat),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.profile),
      ),
    ];
  }

  void _onDestinationSelected(final int index) {
    // When tapping the current tab, reset to its root
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
