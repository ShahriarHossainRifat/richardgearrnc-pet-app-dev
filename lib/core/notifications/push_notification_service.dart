import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:petzy_app/core/analytics/analytics_service.dart';
import 'package:petzy_app/core/utils/logger.dart';

part 'push_notification_service.g.dart';

/// Represents a push notification message.
class PushMessage {
  /// Creates a [PushMessage] instance.
  const PushMessage({
    this.title,
    this.body,
    this.data,
    this.imageUrl,
  });

  /// Notification title.
  final String? title;

  /// Notification body text.
  final String? body;

  /// Additional data payload.
  final Map<String, dynamic>? data;

  /// Image URL for rich notifications.
  final String? imageUrl;

  @override
  String toString() => 'PushMessage(title: $title, body: $body, data: $data)';
}

/// Service for handling push notifications.
///
/// Provides Firebase Cloud Messaging (FCM) integration for push notifications.
///
/// **Features:**
/// - FCM token management
/// - Foreground message handling
/// - Background message handling
/// - Topic subscriptions
/// - Permission handling
///
/// **Setup:**
/// 1. Add Firebase config files (google-services.json for Android, GoogleService-Info.plist for iOS)
/// 2. Ensure `firebase_messaging` is in pubspec.yaml
/// 3. Call `initialize()` during app startup
///
/// **Usage:**
/// ```dart
/// final pushService = ref.read(pushNotificationServiceProvider);
///
/// // Initialize
/// await pushService.initialize();
///
/// // Get token and send to backend
/// final token = await pushService.getToken();
///
/// // Listen for messages
/// pushService.onMessage.listen((message) {
///   print('Got message: ${message.body}');
/// });
///
/// // Subscribe to topics
/// await pushService.subscribeToTopic('promotions');
/// ```
class PushNotificationService {
  /// Creates a [PushNotificationService] instance.
  PushNotificationService(this._ref);

  final Ref _ref;

  AppLogger get _logger => _ref.read(loggerProvider);

  bool _isInitialized = false;
  String? _token;

  final _messageController = StreamController<PushMessage>.broadcast();
  final _tokenController = StreamController<String>.broadcast();

  /// Stream of incoming push messages (when app is in foreground).
  Stream<PushMessage> get onMessage => _messageController.stream;

  /// Stream of FCM token updates.
  Stream<String> get onTokenRefresh => _tokenController.stream;

  /// Whether push notifications are enabled.
  ///
  /// This checks your remote config or feature flag service.
  bool get isEnabled {
    // Check remote config for feature flag
    // In production, integrate with your remote config service
    // Example: return ref.read(firebaseRemoteConfigServiceProvider).getBool('push_notifications_enabled');
    return true; // Default to enabled; override with remote config check
  }

  /// Initialize the push notification service.
  ///
  /// This sets up Firebase messaging, requests permissions, and starts
  /// listening for messages.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    if (!isEnabled) {
      _logger.i(
        'Push notifications are disabled. '
        'Enable via EnvConfig feature flag.',
      );
      return false;
    }

    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission (iOS & web)
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: true,
        carPlay: false,
        criticalAlert: false,
      );

      _logger.i(
        'Notification permission status: ${settings.authorizationStatus}',
      );

      // Get FCM token
      _token = await messaging.getToken();
      _logger.i('FCM Token: $_token');

      // Listen for token refresh
      messaging.onTokenRefresh.listen((final token) async {
        _token = token;
        _tokenController.add(token);
        _logger.i('🔄 FCM token refreshed: $token');

        // Track token refresh in analytics
        try {
          await _ref
              .read(analyticsServiceProvider)
              .logEvent(
                'push_token_refreshed',
                parameters: {'token_length': token.length},
              );
        } catch (e) {
          _logger.w('Failed to log token refresh event', error: e);
        }

        // TODO: Send new token to backend API
        // Example implementation:
        // try {
        //   await _ref.read(userRepositoryProvider).updatePushToken(token);
        // } catch (e) {
        //   _logger.e('Failed to send token to backend', error: e);
        //   // Token will be sent again on next refresh
        // }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((final RemoteMessage message) async {
        _logger.i('📬 Received foreground message: ${message.messageId}');

        final pushMessage = PushMessage(
          title: message.notification?.title,
          body: message.notification?.body,
          data: message.data,
          imageUrl:
              message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
        );

        _messageController.add(pushMessage);

        // Track foreground message delivery in analytics
        try {
          await _ref
              .read(analyticsServiceProvider)
              .logEvent(
                'push_notification_received',
                parameters: {
                  'notification_id': message.messageId ?? 'unknown',
                  'has_title': message.notification?.title != null,
                  'has_body': message.notification?.body != null,
                  'data_keys': message.data.keys.toList().join(','),
                },
              );
        } catch (e) {
          _logger.w('Failed to log notification event', error: e);
        }
      });

      // Handle background message taps
      await _setupInteractedMessage();

      _isInitialized = true;
      return true;
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize PushNotificationService',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Handle notification taps when app is in background or terminated.
  ///
  /// This method is called during initialization to set up listeners
  /// for when users tap notifications.
  Future<void> _setupInteractedMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Handle a message tap (foreground or background).
  void _handleMessage(final RemoteMessage message) {
    _logger.i('📲 Handling message tap: ${message.messageId}');
    _messageController.add(
      PushMessage(
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data,
        imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      ),
    );

    // Track notification tap in analytics
    try {
      _ref
          .read(analyticsServiceProvider)
          .logEvent(
            'push_notification_opened',
            parameters: {
              'notification_id': message.messageId ?? 'unknown',
              'screen': (message.data['screen'] ?? 'unknown').toString(),
              'action': (message.data['action'] ?? 'none').toString(),
            },
          );
    } catch (e) {
      _logger.w('Failed to log notification open event', error: e);
    }

    // Handle deep linking based on message data
    // Message data should include: {'screen': 'orders', 'id': '123'}
    _handleDeepLink(message.data);
  }

  /// Handle deep linking from push notification data.
  void _handleDeepLink(final Map<String, dynamic> data) {
    final screen = data['screen'] as String?;
    if (screen == null) {
      _logger.w('No screen specified in push notification data');
      return;
    }

    // TODO: Implement deep linking navigation
    // Example pattern:
    // if (screen == 'orders') {
    //   final orderId = data['order_id'] as String?;
    //   if (orderId != null) {
    //     _navigateTo('/orders/$orderId');
    //   }
    // } else if (screen == 'promo') {
    //   _navigateTo('/promo/${data['promo_id']}');
    // }
    //
    // Note: This requires access to GoRouter context.
    // Consider using a stream-based approach or postMessage pattern
    // to communicate between the service and router layer.
    _logger.d('Deep link requested: screen=$screen, data=$data');
  }

  /// Get the current FCM token.
  ///
  /// Returns null if not initialized or not configured.
  Future<String?> getToken() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _token;
  }

  /// Subscribe to a topic.
  Future<void> subscribeToTopic(final String topic) async {
    if (!isEnabled) return;

    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e, stack) {
      _logger.e(
        'Failed to subscribe to topic: $topic',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(final String topic) async {
    if (!isEnabled) return;

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e, stack) {
      _logger.e(
        'Failed to unsubscribe from topic: $topic',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Delete the FCM token (useful for logout).
  Future<void> deleteToken() async {
    if (!isEnabled) return;

    try {
      await FirebaseMessaging.instance.deleteToken();
      _token = null;
      _logger.i('FCM token deleted');
    } catch (e, stack) {
      _logger.e(
        'Failed to delete FCM token',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Dispose the service.
  void dispose() {
    _messageController.close();
    _tokenController.close();
  }
}

/// Provider for [PushNotificationService].
@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(final Ref ref) {
  final service = PushNotificationService(ref);
  ref.onDispose(service.dispose);
  return service;
}

// ════════════════════════════════════════════════════════════════════════════
// Background message handler (must be top-level function)
// ════════════════════════════════════════════════════════════════════════════

/// Handles push notifications when the app is in the background or terminated.
///
/// This function is called in its own isolate and must be a top-level function.
/// See [PushNotificationService.initialize] for where this handler is registered.
///
/// **Important**: This runs in an isolate with no access to Flutter context.
/// Cannot navigate or show native dialogs. Use for:
/// - Updating local database/cache
/// - Scheduling local notifications
/// - Pre-fetching data
/// - Logging/analytics (if service is available)
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(final RemoteMessage message) async {
  // Runs in background isolate - no Flutter context available
  final String messageId = message.messageId ?? 'unknown';
  print('🔄 [Background] Processing message: $messageId');

  try {
    // Log background message receipt (if crashlytics available)
    // In production, you might log this to a service:
    // await FirebaseCrashlytics.instance.log(
    //   'Background message received: $messageId'
    // );

    // Handle message based on type
    // Example:
    // if (data['type'] == 'chat') {
    //   await _handleChatMessage(data);
    // } else if (data['type'] == 'order_status') {
    //   await _handleOrderStatusUpdate(data);
    // }

    // Store message in local database if needed
    // await _persistMessage(messageId, title, body, data);

    // Fetch updated data if needed (e.g., for silent notifications)
    // if (message.notification == null) {
    //   // Silent notification - just update data
    //   await _syncDataWithServer();
    // }

    print('✅ [Background] Completed processing: $messageId');
  } catch (e, stack) {
    // Errors in background handler are swallowed.
    // Make sure to log them:
    print('❌ [Background] Error: $e\n$stack');
    // In production, log to Crashlytics or custom service
  }
}
