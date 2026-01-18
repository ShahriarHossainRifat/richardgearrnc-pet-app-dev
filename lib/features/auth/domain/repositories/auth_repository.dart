import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';

/// Contract for authentication operations.
/// Implemented by [AuthRepositoryImpl] in the data layer.
abstract interface class AuthRepository {
  /// Attempt to login with email and password.
  Future<Result<User>> login(final String email, final String password);

  /// Attempt to login with phone number.
  Future<Result<User>> loginWithPhone(final String phoneNumber);

  /// Restore session from stored credentials.
  Future<Result<User>> restoreSession();

  /// Clear the current session and logout.
  Future<Result<void>> logout();

  /// Check if user is currently authenticated.
  Future<bool> isAuthenticated();
}
