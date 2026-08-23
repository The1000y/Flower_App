import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/reset_password_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo authRepo;
  late ResetPasswordUserCase resetPasswordUserCase;

  setUp(() {
    authRepo = MockAuthRepo();
    resetPasswordUserCase = ResetPasswordUserCase(
      authRepo: authRepo,
    );
  });

  group('ResetPasswordUserCase', () {
    test(
      'should call resetPassword from AuthRepo with correct data',
      () async {
        final response = SuccessResponce<ResetPassswordEntity>(
          ResetPassswordEntity(
            isSuccess: true,
            message: 'success',
          ),
        );

        when(
          () => authRepo.resetPassword(
            email: 'test@gmail.com',
            otp: '123456',
            password: 'A12320022',
          ),
        ).thenAnswer(
          (_) async => response,
        );

        final result = await resetPasswordUserCase.call(
          email: 'test@gmail.com',
          otp: '123456',
          password: 'A12320022',
        );

        expect(result, response);

        verify(
          () => authRepo.resetPassword(
            email: 'test@gmail.com',
            otp: '123456',
            password: 'A12320022',
          ),
        ).called(1);
      },
    );
  });
}