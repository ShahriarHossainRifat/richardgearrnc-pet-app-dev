import 'package:flutter/material.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/extensions/extensions.dart';

/// Custom bottom navigation bar for the main app navigation.
///
/// Shows 4 main nav items: Home, Bookings, Messages, Profile
/// Handles navigation between main screens.
class AppNavBar extends StatelessWidget {
  /// Creates an [AppNavBar] instance.
  const AppNavBar({
    required this.currentIndex,
    required this.onItemTapped,
    super.key,
  });

  /// The currently selected nav item index (0=Home, 1=Bookings, 2=Messages, 3=Profile).
  final int currentIndex;

  /// Callback when a nav item is tapped.
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: context.colorScheme.primary,
        unselectedItemColor: context.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Extension method for convenient navbar navigation.
extension NavBarNavigation on BuildContext {
  /// Navigate to nav screen by index.
  /// 0 = Home, 1 = Bookings, 2 = Messages, 3 = Profile
  void navigateToNavScreen(final int index) {
    switch (index) {
      case 0:
        goRoute(AppRoute.home);
      case 1:
        goRoute(AppRoute.bookings);
      case 2:
        goRoute(AppRoute.messages);
      case 3:
        goRoute(AppRoute.profile);
    }
  }

  /// Get the nav bar index for a given route.
  /// Used to highlight the correct nav item based on current route.
  int getNavBarIndexForRoute(final AppRoute route) {
    return switch (route) {
      AppRoute.home => 0,
      AppRoute.bookings ||
      AppRoute.bookingsOwner ||
      AppRoute.bookingsSitter ||
      AppRoute.bookingsSchool ||
      AppRoute.bookingsHotel => 1,
      AppRoute.messages => 2,
      AppRoute.profile ||
      AppRoute.profileOwner ||
      AppRoute.profileSitter ||
      AppRoute.profileSchool ||
      AppRoute.profileHotel => 3,
      _ => 0,
    };
  }
}
