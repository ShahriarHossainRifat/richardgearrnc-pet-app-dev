import 'package:go_router/go_router.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/widgets/adaptive_scaffold.dart';
import 'package:petzy_app/features/booking/presentation/pages/booking_page.dart';
import 'package:petzy_app/features/chat/presentation/pages/chat_page.dart';
import 'package:petzy_app/features/home/presentation/pages/home_page.dart';
import 'package:petzy_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:petzy_app/features/profile/presentation/pages/profile_page.dart';
import 'package:petzy_app/features/settings/presentation/pages/settings_page.dart';
import 'package:petzy_app/features/shorts/presentation/pages/shorts_page.dart';

/// Main navigation shell with bottom navigation bar.
///
/// Uses [StatefulShellRoute.indexedStack] for:
/// - State preservation (scroll position, form inputs)
/// - Independent navigation stacks per tab
/// - Deep linking support
final mainNavigationShell = StatefulShellRoute.indexedStack(
  builder: (final context, final state, final navigationShell) {
    return AdaptiveScaffold(navigationShell: navigationShell);
  },
  branches: [
    // Tab 1: Home
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          builder: (final context, final state) => const HomePage(),
        ),
      ],
    ),
    // Tab 2: Booking
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoute.booking.path,
          name: AppRoute.booking.name,
          builder: (final context, final state) => const BookingPage(),
        ),
      ],
    ),
    // Tab 3: Chat/Messages
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoute.chat.path,
          name: AppRoute.chat.name,
          builder: (final context, final state) => const ChatPage(),
        ),
      ],
    ),
    // Tab 4: Profile
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoute.profile.path,
          name: AppRoute.profile.name,
          builder: (final context, final state) => const ProfilePage(),
          routes: [
            // Settings accessible from Profile tab
            GoRoute(
              path: 'settings',
              name: AppRoute.settings.name,
              builder: (final context, final state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Routes that are outside the main navigation shell.
/// These display without the bottom navigation bar.
final protectedRoutes = [
  // Main tabbed navigation
  mainNavigationShell,

  // Onboarding (full-screen, no nav bar)
  GoRoute(
    path: AppRoute.onboarding.path,
    name: AppRoute.onboarding.name,
    builder: (final context, final state) => const OnboardingPage(),
  ),

  // Shorts (full-screen immersive, no nav bar)
  GoRoute(
    path: AppRoute.shorts.path,
    name: AppRoute.shorts.name,
    builder: (final context, final state) => const ShortsPage(),
  ),
];
