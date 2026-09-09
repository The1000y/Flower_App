import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/use_case/change_password_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_cubit_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase])
void main() {
  provideDummy<BaseResponce<ChangePasswordResponse>>(
    ErrorResponce(Exception('dummy')),
  );

  late ChangePasswordCubit cubit;
  late MockChangePasswordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    cubit = ChangePasswordCubit(mockUseCase);
  });

  final tResponse = ChangePasswordResponse(
    data: true,
    isSuccess: true,
    message: 'Password changed successfully',
    errorCode: 200,
  );

  test('initial state should be ChangePasswordState()', () {
    expect(cubit.state, equals(const ChangePasswordState()));
  });

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'emits [isLoading: true, data: tResponse] when UpdatePasswordEvent succeeds',
    build: () {
      when(mockUseCase.call(any))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));
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
        changePasswordState: BaseState<ChangePasswordResponse>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordResponse>(
          isLoading: false,
          errorMessage: '',
          data: tResponse,
        ),
      ),
    ],
    verify: (_) {
      verify(mockUseCase.call(any)).called(1);
    },
  );

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'emits [isLoading: true, errorMessage] when UpdatePasswordEvent fails',
    build: () {
      when(mockUseCase.call(any))
          .thenAnswer((_) async => ErrorResponce<ChangePasswordResponse>(Exception('Change password failed')));
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
        changePasswordState: BaseState<ChangePasswordResponse>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      const ChangePasswordState(
        changePasswordState: BaseState<ChangePasswordResponse>(
          isLoading: false,
          errorMessage: 'something went wrong, pls try again',
          data: null,
        ),
      ),
    ],
    verify: (_) {
      verify(mockUseCase.call(any)).called(1);
    },
  );
}
