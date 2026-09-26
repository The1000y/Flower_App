import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('SecureStorageService', () {
    late SecureStorageService service;

    setUp(() {
      useInMemorySecureStorage();
      service = SecureStorageService(const FlutterSecureStorage());
    });

    test('saves and reads access token', () async {
      await service.saveAccessToken('token123');
      expect(await service.getAccessToken(), 'token123');
    });

    test('saves and reads refresh token', () async {
      await service.saveRefreshToken('refresh123');
      expect(await service.getRefreshToken(), 'refresh123');
    });

    test('returns null when token has not been saved', () async {
      expect(await service.getAccessToken(), isNull);
      expect(await service.getRefreshToken(), isNull);
    });

    test('saves and reads remembered email', () async {
      await service.saveRememberedEmail('user@example.com');
      expect(await service.getRememberedEmail(), 'user@example.com');
    });

    test('deletes remembered email', () async {
      await service.saveRememberedEmail('user@example.com');
      await service.deleteRememberedEmail();

      expect(await service.getRememberedEmail(), isNull);
    });

    test('clear removes all stored values', () async {
      await service.saveAccessToken('token123');
      await service.saveRememberedEmail('user@example.com');

      await service.clear();

      expect(await service.getAccessToken(), isNull);
      expect(await service.getRememberedEmail(), isNull);
    });

    test('uses the configured storage keys', () async {
      await service.saveRememberedEmail('user@example.com');
      expect(
        await readStorageValue(AppStrings.rememberedEmail),
        'user@example.com',
      );
    });
  });
}