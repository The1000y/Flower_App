import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/api/client/auth_api_client.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/model/request/refresh_token_request/refresh_token_request_dto.dart';
import 'package:injectable/injectable.dart';

/// Exchanges the stored refresh token for a fresh access token.
///
/// The gateway expires access tokens after 15 minutes (`expiresIn: 900`) while
/// the session itself stays alive through the refresh token, so a long session
/// has to recover from `401` responses transparently.
@lazySingleton
class TokenRefreshService {
  final AuthApiClient _authApiClient;
  final SecureStorageService _secureStorage;

  /// The in-flight refresh, if any. Concurrent `401`s share this single future
  /// so a burst of failing requests triggers exactly one refresh call instead
  /// of one per request. The gateway rotates the refresh token, which makes a
  /// stampede especially harmful: only the first of several parallel refreshes
  /// can win before the token it used is invalidated.
  Future<String?>? _inFlight;

  TokenRefreshService(this._authApiClient, this._secureStorage);

  /// Returns a new access token, or `null` when the session can no longer be
  /// renewed. Never throws: a failed refresh is an expected outcome that the
  /// caller turns into "send the user back to login".
  Future<String?> refreshAccessToken() {
    return _inFlight ??= _performRefresh().whenComplete(() {
      _inFlight = null;
    });
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _secureStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearAuth();
      return null;
    }

    try {
      final response = await _authApiClient.refreshToken(
        RefreshTokenRequestDto(token: refreshToken),
      );

      if (!response.isSuccessful) {
        await _clearAuth();
        return null;
      }

      final accessToken = response.accessToken!;
      await _secureStorage.saveAccessToken(accessToken);

      // The gateway rotates the refresh token, so persist the new one when it
      // is present. Keep the previous value if the response omits it.
      final rotated = response.refreshToken;
      if (rotated != null && rotated.isNotEmpty) {
        await _secureStorage.saveRefreshToken(rotated);
      }

      return accessToken;
    } on DioException {
      await _clearAuth();
      return null;
    } catch (_) {
      await _clearAuth();
      return null;
    }
  }

  /// Drops the stored credentials so the next launch starts at the login
  /// screen instead of retrying with tokens the gateway already rejected.
  Future<void> _clearAuth() => _secureStorage.clear();
}
