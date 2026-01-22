import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petzy_app/core/constants/api_endpoints.dart';
import 'package:petzy_app/core/constants/app_constants.dart';
import 'package:petzy_app/core/constants/storage_keys.dart';
import 'package:petzy_app/core/network/api_client.dart';
import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/domain/repositories/auth_repository.dart';

/// Remote implementation of [AuthRepository] for actual API calls.
///
/// Expected response for login endpoints:
/// ```json
/// {"token": "jwt", "refresh_token": "refresh", "user": {...}}
/// ```
class AuthRepositoryRemote implements AuthRepository {
  /// Creates a [AuthRepositoryRemote] instance.
  AuthRepositoryRemote({
    required final ApiClient apiClient,
    required this.secureStorage,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Secure storage for storing tokens.
  final FlutterSecureStorage secureStorage;

  @override
  Future<Result<User>> login(final String email, final String password) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      fromJson: (final json) => json as Map<String, dynamic>,
    );

    return result.fold(
      onSuccess: _handleAuthResponse,
      onFailure: Failure.new,
    );
  }

  @override
  Future<Result<void>> loginWithPhone(final String phoneNumber) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.loginPhone,
      data: {'phone_number': phoneNumber},
      fromJson: (final json) => json as Map<String, dynamic>,
    );

    return result.fold(
      onSuccess: (_) {
        // OTP sent successfully - do NOT store any tokens or user data
        // User will be authenticated only after OTP verification with verifyOtp()
        return const Success(null);
      },
      onFailure: Failure.new,
    );
  }

  @override
  Future<Result<User>> verifyOtp(
    final String phoneNumber,
    final String code,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {'phone_number': phoneNumber, 'code': code},
      fromJson: (final json) => json as Map<String, dynamic>,
    );

    return result.fold(
      onSuccess: _handleAuthResponse,
      onFailure: Failure.new,
    );
  }

  @override
  Future<Result<void>> resendOtp(final String phoneNumber) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.resendOtp,
      data: {'phone_number': phoneNumber},
      fromJson: (final json) => json as Map<String, dynamic>,
    );

    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: Failure.new,
    );
  }

  @override
  Future<Result<User>> restoreSession() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);

    if (token == null) {
      return Failure(AuthException.noSession());
    }

    // Validate token by fetching current user with timeout
    try {
      final result = await _apiClient
          .get<Map<String, dynamic>>(
            ApiEndpoints.currentUserProfile,
            fromJson: (final json) => json as Map<String, dynamic>,
          )
          .timeout(AppConstants.sessionRestoreTimeout);

      return result.fold(
        onSuccess: (final data) {
          final userData = data['user'] as Map<String, dynamic>? ?? data;
          return Success(User.fromJson(userData));
        },
        onFailure: (final error) {
          // Clear tokens on 401 (fire-and-forget) to avoid fold type issues
          if (error is NetworkException && error.statusCode == 401) {
            _clearTokens(); // Not awaited to prevent fold type signature issues
          }
          return Failure(error);
        },
      );
    } on TimeoutException catch (_) {
      // Session validation timed out - treat as invalid session
      return Failure(
        NetworkException(message: 'Session validation timed out'),
      );
    } catch (e) {
      // Network error or other exception
      return Failure(
        NetworkException(message: 'Failed to restore session: $e'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Optionally notify backend (ignore errors)
      await _apiClient.post<void>(ApiEndpoints.logout);
    } catch (_) {
      // Ignore logout API errors - we still want to clear local state
    }

    return _clearTokens();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  /// Handles successful auth responses by storing tokens and user data.
  /// Shared by [login] and [verifyOtp].
  Future<Result<User>> _handleAuthResponse(
    final Map<String, dynamic> data,
  ) async {
    try {
      // 1. Store tokens
      final token = data['token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (token != null) {
        await secureStorage.write(key: StorageKeys.accessToken, value: token);
      }
      if (refreshToken != null) {
        await secureStorage.write(
          key: StorageKeys.refreshToken,
          value: refreshToken,
        );
      }

      // 2. Parse and store user
      final userData = data['user'] as Map<String, dynamic>?;
      if (userData == null) {
        return const Failure(
          AuthException(message: 'Invalid response: missing user data'),
        );
      }

      final user = User.fromJson(userData);
      await secureStorage.write(key: StorageKeys.userId, value: user.id);

      return Success(user);
    } catch (e, stackTrace) {
      return Failure(
        CacheException(
          message: 'Failed to process authentication response: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Clears all stored authentication tokens and user data asynchronously.
  Future<Result<void>> _clearTokens() async {
    try {
      await Future.wait([
        secureStorage.delete(key: StorageKeys.accessToken),
        secureStorage.delete(key: StorageKeys.refreshToken),
        secureStorage.delete(key: StorageKeys.userId),
      ]);
      return const Success(null);
    } catch (e, stackTrace) {
      return Failure(
        CacheException(message: 'Clear session failed', stackTrace: stackTrace),
      );
    }
  }
}
