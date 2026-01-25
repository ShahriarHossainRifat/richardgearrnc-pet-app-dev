import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petzy_app/core/utils/logger.dart';

/// Service responsible for authenticating users via Google Sign-In
/// and linking the Google account with Firebase Authentication.
///
/// Compatible with:
/// - google_sign_in ^7.2.0
/// - firebase_auth ^5.x
///
/// Requirements:
/// - iOS: GIDClientID automatically added via GoogleService-Info.plist
/// - Android: SHA-1/SHA-256 fingerprints configured in Firebase Console
///   (enables native Sign-In on Android)
///
/// This service is UI-agnostic and safe to use with Riverpod.
class GoogleSignInService {
  /// Creates a [GoogleSignInService].
  ///
  /// Dependencies can be injected for testing.
  GoogleSignInService({
    final firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  // Use the singleton GoogleSignIn instance
  // On Android, serverClientId is automatically configured from build.gradle resValue
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  /// Starts the Google Sign-In flow and authenticates the user with Firebase.
  ///
  /// Returns:
  /// - Firebase **ID token** (backend-safe)
  ///
  /// Throws:
  /// - [GoogleSignInException] on cancellation or Google auth failure
  /// - [firebase_auth.FirebaseAuthException] on Firebase failure
  Future<String> signIn() async {
    try {
      // 1️⃣ Trigger Google Sign-In (uses native UI on Android/iOS)
      // authenticate() triggers the platform-specific sign-in flow
      final googleAccount = await _googleSignIn.authenticate();

      // 2️⃣ Get the authentication details with ID token
      final googleAuth = await googleAccount.authentication;

      // 3️⃣ Extract the ID token for Firebase
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const GoogleSignInException(
          message: 'Missing Google ID token',
        );
      }

      // 4️⃣ Create Firebase credential with ID token
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // 5️⃣ Authenticate with Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const GoogleSignInException(
          message: 'Firebase user is null after sign-in',
        );
      }

      // 6️⃣ Return Firebase ID token
      final firebaseIdToken = await user.getIdToken();
      if (firebaseIdToken == null) {
        throw const GoogleSignInException(
          message: 'Failed to retrieve Firebase ID token',
        );
      }

      return firebaseIdToken;
    } on firebase_auth.FirebaseAuthException catch (e, stack) {
      AppLogger.instance.e(
        'FirebaseAuthException during Google sign-in',
        error: e,
        stackTrace: stack,
      );
      throw GoogleSignInException(
        message: e.message ?? 'Firebase authentication failed',
      );
    } on GoogleSignInException {
      rethrow;
    } catch (e, stack) {
      AppLogger.instance.e(
        'Unexpected error during Google sign-in',
        error: e,
        stackTrace: stack,
      );
      throw const GoogleSignInException(
        message: 'Unexpected error during Google sign-in',
      );
    }
  }

  /// Signs out from both Google and Firebase.
  ///
  /// Call this on app logout.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e, stack) {
      AppLogger.instance.w(
        'Error during Google sign-out',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Fully disconnects the Google account from the app.
  ///
  /// This revokes Google consent and requires re-authentication.
  Future<void> disconnect() async {
    try {
      await Future.wait([
        _googleSignIn.disconnect(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e, stack) {
      AppLogger.instance.w(
        'Error disconnecting Google account',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

/// Exception thrown for Google Sign-In related failures.
class GoogleSignInException implements Exception {
  /// Creates a [GoogleSignInException].
  const GoogleSignInException({
    required this.message,
    this.isCancelled = false,
  });

  /// Factory for cancellation cases (not an error).
  const GoogleSignInException.cancelled()
    : message = 'User cancelled Google sign-in',
      isCancelled = true;

  /// Description of the failure.
  final String message;

  /// Whether the flow was cancelled by the user.
  final bool isCancelled;

  @override
  String toString() => 'GoogleSignInException: $message';
}
