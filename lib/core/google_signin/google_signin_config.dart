/// Configuration for Google Sign-In.
///
/// The serverClientId is required on Android to enable native Sign-In.
/// Get your Web OAuth 2.0 Client ID from:
/// https://console.cloud.google.com/apis/credentials
///
/// Select your project, then:
/// 1. APIs & Services → Credentials
/// 2. Find "OAuth 2.0 Client IDs"
/// 3. Look for the one with type "Web application"
/// 4. Copy the Client ID
class GoogleSignInConfig {
  /// Web OAuth 2.0 Client ID (required for Android native auth)
  ///
  /// This is the same client ID used in your Firebase project's
  /// Google Cloud Console credentials.
  ///
  /// On Android, this enables the native Google Sign-In flow instead of
  /// falling back to web authentication.
  static const String androidServerClientId =
      '389948242204-gje1kfob8id9s3rslqvq9q7q2d1qv5j1.apps.googleusercontent.com';
}
