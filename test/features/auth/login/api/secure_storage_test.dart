import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
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

    test('saves and reads the user under the userData key', () async {
      const user = UserEntity(
        id: 1,
        fullName: 'Nour Mohamed',
        email: 'nour@example.com',
        phoneNumber: '+201234567890',
        gender: 'female',
        role: 'user',
        status: 'active',
      );

      await service.saveUser(user);

      final raw = await service.getUser();
      expect(raw, isNotNull);
      expect(raw, contains('nour@example.com'));
      expect(await readStorageValue(AppStrings.userData), raw);
    });

    test('getUser returns null when no user was saved', () async {
      expect(await service.getUser(), isNull);
    });

    test('readKey reads an arbitrary key', () async {
      await service.saveAccessToken('token123');

      expect(await service.readKey(AppStrings.accessToken), 'token123');
    });

    test('readKey returns null for an unknown key', () async {
      expect(await service.readKey('missing_key'), isNull);
    });
  });
}
