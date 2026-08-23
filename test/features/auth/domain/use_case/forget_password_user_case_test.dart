import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo authRepo;
  late ForgetPasswordUserCase forgetPasswordUserCase;

  setUp(() {
    authRepo = MockAuthRepo();
    forgetPasswordUserCase = ForgetPasswordUserCase(authRepo);
  });

  group('ForgetPasswordUserCase', () {
    test(
      'should call forgetPassword from AuthRepo with correct email',
      () async {
        final response = SuccessResponce<ForgetPasswordEntity>(
          ForgetPasswordEntity(
            isSuccess: true,
            message: 'success',
          ),
        );

        when(
          () => authRepo.forgetPassword(
            email: 'test@gmail.com',
          ),
        ).thenAnswer(
          (_) async => response,
        );

        final result = await forgetPasswordUserCase.call(
          email: 'test@gmail.com',
        );

        expect(result, response);

        verify(
          () => authRepo.forgetPassword(
            email: 'test@gmail.com',
          ),
        ).called(1);
      },
    );
  });
}