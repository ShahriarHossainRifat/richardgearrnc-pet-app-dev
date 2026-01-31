/// API endpoint paths.
///
/// Centralizes all API endpoint paths to avoid hardcoding strings
/// and ensure consistency across the app.
///
/// Usage:
/// ```dart
/// final response = await apiClient.post(ApiEndpoints.login, data: {...});
/// ```
abstract class ApiEndpoints {
  // ─────────────────────────────────────────────────────────────────────────────
  // AUTHENTICATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Login endpoint (email/password).
  static const String login = '/auth/login';

  /// Login endpoint (phone number).
  static const String loginPhone = '/auth/login/phone';

  /// Verify OTP endpoint.
  static const String verifyOtp = '/auth/verify-otp';

  /// Resend OTP endpoint.
  static const String resendOtp = '/auth/resend-otp';

  /// Get current user profile endpoint.
  static const String currentUserProfile = '/auth/me';

  /// Register endpoint.
  static const String register = '/auth/register';

  /// Logout endpoint.
  static const String logout = '/auth/logout';

  /// Refresh token endpoint.
  static const String refreshToken = '/auth/refresh';

  /// Forgot password endpoint.
  static const String forgotPassword = '/auth/forgot-password';

  /// Reset password endpoint.
  static const String resetPassword = '/auth/reset-password';

  /// Verify email endpoint.
  static const String verifyEmail = '/auth/verify-email';

  /// Resend verification email endpoint.
  static const String resendVerification = '/auth/resend-verification';

  /// Check if user exists by email.
  /// Sends {"email": "user@example.com"}.
  /// Returns {"success": true, "message": "...", "data": {"isUserExists": bool}}.
  static const String checkUserExistsByEmail = '/auth/users/exists/email';

  /// Check if user exists by phone.
  /// Sends {"phone": "+1234567890"}.
  /// Returns {"success": true, "message": "...", "data": {"isUserExists": bool}}.
  static const String checkUserExistsByPhone = '/auth/users/exists/phone';

  /// Login with Google endpoint (Firebase ID token).
  /// Returns user existence, role, and tokens.
  static const String loginGoogle = '/auth/users/exists/email';

  /// Login with Firebase phone auth (ID token exchange).
  /// Used after Firebase Phone Auth verification to create app session.
  static const String loginPhoneFirebase = '/auth/users/exists/phone';

  /// Pet owner signup endpoint.
  /// Creates a new pet owner account with profile information.
  static const String petOwnerSignup = '/auth/pet-owner-signup';

  // ─────────────────────────────────────────────────────────────────────────────
  // USER
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get current user profile.
  static const String currentUser = '/users/me';

  /// Update user profile.
  static const String updateProfile = '/users/me';

  /// Change user password.
  static const String changePassword = '/users/me/password';

  /// Upload user avatar.
  static const String uploadAvatar = '/users/me/avatar';

  /// Delete user account.
  static const String deleteAccount = '/users/me';

  /// User by ID (append user ID).
  static const String userById = '/users';

  // ─────────────────────────────────────────────────────────────────────────────
  // SETTINGS & CONFIG
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get app settings.
  static const String settings = '/settings';

  /// Notification settings.
  static const String notificationSettings = '/settings/notifications';

  /// Privacy settings.
  static const String privacySettings = '/settings/privacy';

  // ─────────────────────────────────────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// List notifications.
  static const String notifications = '/notifications';

  /// Mark notification as read.
  static const String markNotificationRead = '/notifications/read';

  /// Mark all notifications as read.
  static const String markAllNotificationsRead = '/notifications/read-all';

  /// Register device for push notifications.
  static const String registerDevice = '/notifications/device';

  // ─────────────────────────────────────────────────────────────────────────────
  // FEEDBACK & SUPPORT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Submit feedback.
  static const String feedback = '/feedback';

  /// Report issue.
  static const String reportIssue = '/support/report';

  /// Contact support.
  static const String contactSupport = '/support/contact';

  // ─────────────────────────────────────────────────────────────────────────────
  // COMMUNITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get all community posts with cursor pagination.
  /// Query parameters: limit (max 50, default 20), cursor (optional)
  static const String communityAll = '/api/community/all';

  /// Get post by ID.
  static const String postById = '/api/community/posts';

  /// Like a post.
  static const String likePost = '/api/community/posts/like';

  /// Unlike a post.
  static const String unlikePost = '/api/community/posts/unlike';

  /// Save a post.
  static const String savePost = '/api/community/posts/save';

  /// Unsave a post.
  static const String unsavePost = '/api/community/posts/unsave';

  /// Get post comments.
  static const String postComments = '/api/community/posts/comments';

  /// Add comment to post.
  static const String addComment = '/api/community/posts/comments/add';

  // ─────────────────────────────────────────────────────────────────────────────
  // VERSIONING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check app version.
  static const String checkVersion = '/version/check';

  /// Get feature flags.
  static const String featureFlags = '/config/features';
}
