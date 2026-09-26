import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/change_password_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  late ChangePasswordCubit cubit;
  late MockChangePasswordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    cubit = ChangePasswordCubit(mockUseCase);
  });

  const tEntity = ChangePasswordEntity(
    data: true,
    isSuccess: true,
    message: 'Password changed successfully',
    errorCode: 200,
  );

  test('initial state should be ChangePasswordState()', () {
    expect(cubit.state, equals(const ChangePasswordState()));
  });

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'emits [isLoading: true, data: tEntity] when UpdatePasswordEvent succeeds',
    build: () {
      when(() => mockUseCase.call(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmNewPassword: 'NewPassword123',
          )).thenAnswer((_) async => SuccessResponce<ChangePasswordEntity>(tEntity));
      return cubit;
    },
    act: (cubit) => cubit.doEvent(
      UpdatePasswordEvent(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      ),
    ),
    expect: () => [
      const ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordEntity>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      const ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordEntity>(
          isLoading: false,
          errorMessage: '',
          data: tEntity,
        ),
      ),
    ],
    verify: (_) {
      verify(() => mockUseCase.call(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmNewPassword: 'NewPassword123',
          )).called(1);
    },
  );

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'emits [isLoading: true, errorMessage] when UpdatePasswordEvent fails',
    build: () {
      when(() => mockUseCase.call(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmNewPassword: 'NewPassword123',
          )).thenAnswer((_) async => ErrorResponce<ChangePasswordEntity>(Exception('Change password failed')));
      return cubit;
    },
    act: (cubit) => cubit.doEvent(
      UpdatePasswordEvent(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      ),
    ),
    expect: () => [
      const ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordEntity>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      const ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordEntity>(
          isLoading: false,
          errorMessage: 'something went wrong, pls try again',
          data: null,
        ),
      ),
    ],
    verify: (_) {
      verify(() => mockUseCase.call(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmNewPassword: 'NewPassword123',
          )).called(1);
    },
  );
}
