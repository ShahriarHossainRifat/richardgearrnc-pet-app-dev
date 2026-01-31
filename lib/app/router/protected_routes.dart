import 'package:go_router/go_router.dart';
import 'package:petzy_app/app/presentation/pages/placeholder_page.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/features/home/presentation/pages/home_page.dart';
import 'package:petzy_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:petzy_app/features/pet_setter/presentation/booking_request/pet_sitter_booking_req.dart';
import 'package:petzy_app/features/pet_setter/presentation/booking_request/pet_sitter_booking_req_details.dart';
import 'package:petzy_app/features/settings/presentation/pages/settings_page.dart';

/// Routes that require authentication.
final protectedRoutes = [
  GoRoute(
    path: AppRoute.home.path,
    name: AppRoute.home.name,
    builder: (final context, final state) => const HomePage(),
  ),
  GoRoute(
    path: AppRoute.profile.path,
    name: AppRoute.profile.name,
    builder: (final context, final state) => const PlaceholderPage(title: 'Profile'),
  ),
  GoRoute(
    path: AppRoute.settings.path,
    name: AppRoute.settings.name,
    builder: (final context, final state) => const SettingsPage(),
  ),
  GoRoute(
    path: AppRoute.onboarding.path,
    name: AppRoute.onboarding.name,
    builder: (final context, final state) => const OnboardingPage(),
  ),
  GoRoute(
    path: AppRoute.bookingDetails.path,
    name: AppRoute.bookingDetails.name,
    builder: (final context, final state) {
      final serviceId = state.extra is String ? state.extra! as String : '';
      return PetSitterBookingReqDetailsPage(serviceId: serviceId);
    },
  ),
];
