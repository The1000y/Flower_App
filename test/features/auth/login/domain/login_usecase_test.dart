import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('LoginUseCase', () {
    final credentials = LoginCredentials(
      email: validEmail,
      password: validPassword,
    );

    test('forwards request to repo and returns success data', () async {
      final repo = FakeAuthRepo();
      final useCase = LoginUseCase(repo);

      final result = await useCase(credentials, rememberMe: true);

      expect(result, isA<SuccessResponce>());
      expect(repo.lastLoginRequest?.email, validEmail);
      expect(repo.lastLoginRequest?.password, validPassword);
      expect(repo.lastRememberMe, isTrue);
    });

    test('forwards failure from repo', () async {
      final repo = FakeAuthRepo(shouldSucceed: false);
      final useCase = LoginUseCase(repo);

      final result = await useCase(credentials);

      expect(result, isA<ErrorResponce>());
      expect((result as ErrorResponce).errorMessage, isNotEmpty);
    });
  });
}