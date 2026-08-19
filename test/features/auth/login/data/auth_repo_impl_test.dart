import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/dummy.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('AuthRepoImpl', () {
    late SecureStorageService storage;
    late AuthRepoImpl repo;

    setUp(() {
      useInMemorySecureStorage();
      storage = SecureStorageService(const FlutterSecureStorage());
      repo = AuthRepoImpl(RemoteDataSourceImpl(), storage);
    });

    test('returns success and saves tokens when remember me is true', () async {
      final result = await repo.login(
        LoginCredentials(email: Dummy.email, password: Dummy.pass),
        rememberMe: true,
      );

      expect(result, isA<SuccessResponce>());
      expect(await storage.getAccessToken(), isNotNull);
      expect(await storage.getRefreshToken(), isNotNull);
    });

    test('does not save tokens when remember me is false', () async {
      final result = await repo.login(
        LoginCredentials(email: Dummy.email, password: Dummy.pass),
      );

      expect(result, isA<SuccessResponce>());
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
    });

    test('returns error for invalid credentials', () async {
      final result = await repo.login(
        LoginCredentials(email: 'wrong@example.com', password: 'wrong'),
      );

      expect(result, isA<ErrorResponce>());
      expect(await storage.getAccessToken(), isNull);
    });

    test('delegates remember-me methods to storage service', () async {
      await repo.saveRememberedEmail(validEmail);
      expect(await repo.getRememberedEmail(), validEmail);

      await repo.deleteRememberedEmail();
      expect(await repo.getRememberedEmail(), isNull);
    });
  });
}