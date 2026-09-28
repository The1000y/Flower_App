import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/api/service/token_refresh_service.dart';
import 'package:flower_app/features/auth/data/model/response/refresh_token_response/refresh_token_response_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('TokenRefreshService', () {
    late SecureStorageService storage;
    late TokenRefreshService service;

    TokenRefreshService build(FakeAuthApiClient apiClient) {
      return TokenRefreshService(apiClient, storage);
    }

    setUp(() {
      useInMemorySecureStorage();
      storage = SecureStorageService(const FlutterSecureStorage());
    });

    test('exchanges the stored refresh token for a new access token', () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
          refreshToken: 'rotated-refresh',
        ),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('stored-refresh');

      final token = await service.refreshAccessToken();

      expect(token, 'fresh-access');
      expect(apiClient.lastRefreshRequest?.token, 'stored-refresh');
      expect(await storage.getAccessToken(), 'fresh-access');
    });

    test('persists the rotated refresh token returned by the gateway',
        () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
          refreshToken: 'rotated-refresh',
        ),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('old-refresh');

      await service.refreshAccessToken();

      expect(await storage.getRefreshToken(), 'rotated-refresh');
    });

    test('keeps the previous refresh token when the response omits it',
        () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
        ),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('old-refresh');

      await service.refreshAccessToken();

      expect(await storage.getRefreshToken(), 'old-refresh');
    });

    test('parses the flat gateway response body', () {
      final response = RefreshTokenResponseDto.fromJson({
        'accessToken': 'a',
        'refreshToken': 'r',
        'expiresAt': '2026-09-28T10:56:54.5495768Z',
      });

      expect(response.accessToken, 'a');
      expect(response.refreshToken, 'r');
      expect(response.expiresAt, isNotNull);
      expect(response.isSuccessful, isTrue);
    });

    test('treats a response without an access token as unsuccessful', () {
      expect(
        const RefreshTokenResponseDto().isSuccessful,
        isFalse,
      );
      expect(
        const RefreshTokenResponseDto(accessToken: '').isSuccessful,
        isFalse,
      );
    });

    test('returns null and clears credentials when no refresh token is stored',
        () async {
      final apiClient = FakeAuthApiClient();
      service = build(apiClient);
      await storage.saveAccessToken('stale-access');

      final token = await service.refreshAccessToken();

      expect(token, isNull);
      expect(apiClient.refreshCallCount, 0);
      expect(await storage.getAccessToken(), isNull);
    });

    test('returns null and clears credentials when the gateway rejects the '
        'refresh token', () async {
      final apiClient = FakeAuthApiClient(
        refreshError: DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 401,
          ),
        ),
      );
      service = build(apiClient);
      await storage.saveAccessToken('stale-access');
      await storage.saveRefreshToken('rejected-refresh');

      final token = await service.refreshAccessToken();

      expect(token, isNull);
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
    });

    test('returns null and clears credentials when the response carries no '
        'access token', () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(refreshToken: 'r'),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('stored-refresh');

      expect(await service.refreshAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
    });

    test('collapses concurrent refreshes into a single call', () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
          refreshToken: 'rotated-refresh',
        ),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('stored-refresh');

      final results = await Future.wait([
        service.refreshAccessToken(),
        service.refreshAccessToken(),
        service.refreshAccessToken(),
      ]);

      expect(apiClient.refreshCallCount, 1);
      expect(results, ['fresh-access', 'fresh-access', 'fresh-access']);
    });

    test('allows a new refresh after a previous one finished', () async {
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
        ),
      );
      service = build(apiClient);
      await storage.saveRefreshToken('stored-refresh');

      await service.refreshAccessToken();
      await service.refreshAccessToken();

      expect(apiClient.refreshCallCount, 2);
    });
  });
}
