import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('LoginUseCase', () {
    final request = RequestLogin(email: validEmail, password: validPassword);

    test('forwards request to repo and returns success data', () async {
      final repo = FakeAuthRepo();
      final useCase = LoginUseCase(repo);

      final result = await useCase(request);

      expect(result, isA<SuccessResponce>());
      expect(repo.lastRequest?.email, validEmail);
      expect(repo.lastRequest?.password, validPassword);
    });

    test('forwards failure from repo', () async {
      final repo = FakeAuthRepo(shouldSucceed: false);
      final useCase = LoginUseCase(repo);

      final result = await useCase(request);

      expect(result, isA<ErrorResponce>());
      expect((result as ErrorResponce).errorMessage, isNotEmpty);
    });
  });
}