import 'package:flower_app/config/base/base_responce.dart';

import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/change_password_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePasswordUseCase)
      : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;

  void doEvent(ChangePasswordEvent event) {
    switch (event) {
      case UpdatePasswordEvent():
        _updatePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        );
        break;
    }
  }

  void _updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(
      state.copyWith(
        changePasswordState: state.changePasswordState.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );



    final response = await _changePasswordUseCase.call(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmPassword,
    );

    switch (response) {
      case SuccessResponce<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordState: state.changePasswordState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;

      case ErrorResponce<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordState: state.changePasswordState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
              data: null,
            ),
          ),
        );
        break;
    }
  }
}
