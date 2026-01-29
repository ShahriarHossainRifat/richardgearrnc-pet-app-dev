import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// The root application widget.
class App extends HookConsumerWidget {
  /// Creates the root [App] widget.
  const App({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Initialize push notification service on app startup
    useOnMount(() {
      _initializePushNotifications(ref);
    });

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'Petzy App',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Localization configuration
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Router configuration
      routerConfig: router,

      // Scroll behavior for consistent scrolling across platforms
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),

      // Connectivity wrapper - shows offline banner
      builder: (final context, final child) => ConnectivityWrapper(
        bannerPosition: .top,
        showBanner: true,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }

  /// Initialize push notifications during app startup.
  static Future<void> _initializePushNotifications(final WidgetRef ref) async {
    final pushService = ref.read(pushNotificationServiceProvider);
    final analytics = ref.read(analyticsServiceProvider);

    // Initialize push notification service
    final initialized = await pushService.initialize();
    if (!initialized) {
      AppLogger.instance.w('Push notifications not initialized');
      return;
    }

    // Get and send FCM token to backend
    try {
      final token = await pushService.getToken();
      AppLogger.instance.i(
        '📱 FCM Token obtained: ${token?.substring(0, 20)}...',
      );

      // Log token obtained event
      await analytics.logEvent(
        'push_token_obtained',
        parameters: {
          'token_length': token?.length ?? 0,
          'has_token': token != null,
        },
      );

      if (token != null) {
        // TODO: Send token to backend API for user device registration
        // Example:
        // final userRepo = ref.read(userRepositoryProvider);
        // await userRepo.updatePushToken(token);
      }
    } catch (e, stack) {
      AppLogger.instance.e(
        '❌ Failed to obtain FCM token',
        error: e,
        stackTrace: stack,
      );
      await analytics.logEvent(
        'push_token_error',
        parameters: {'error': e.toString()},
      );
    }

    // Listen for foreground messages
    pushService.onMessage.listen((final message) async {
      AppLogger.instance.i(
        '📬 Foreground message: ${message.title} - ${message.body}',
      );

      // Show a native notification
      final localNotificationService = ref.read(
        localNotificationServiceProvider,
      );
      try {
        await localNotificationService.show(
          LocalNotificationConfig(
            id: message.hashCode,
            title: message.title ?? 'Notification',
            body: message.body ?? '',
            payload: message.data.toString(),
            channelId: 'fcm_channel',
            playSound: true,
            enableVibration: true,
          ),
        );
      } catch (e) {
        AppLogger.instance.e('Failed to show notification', error: e);
      }
    });

    // Listen for token refresh events
    pushService.onTokenRefresh.listen((final newToken) async {
      AppLogger.instance.i('🔄 FCM Token refreshed');

      // Track token refresh
      await analytics.logEvent(
        'push_token_refreshed_app',
        parameters: {'token_length': newToken.length},
      );

      // TODO: Send new token to backend
      // This ensures we always have the latest token registered
    });

    AppLogger.instance.i('✅ Push notifications initialized successfully');
  }
}
