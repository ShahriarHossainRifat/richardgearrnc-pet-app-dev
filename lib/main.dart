import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/bootstrap.dart';
import 'package:riverpod_go_router_boilerplate/core/localization/locale_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';

/// Application entry point.
///
/// Uses [runGuardedApp] to wrap the app in a guarded zone for
/// comprehensive error catching in production.
void main() {
  // ignore: discarded_futures - runGuardedApp handles its own async flow
  runGuardedApp(
    appBuilder: (final sharedPreferences, final connectivity) => ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      child: const AppBootstrap(),
    ),
  );
}
