import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/register_entity/register_entity.dart';
import '../../../domain/use_case/register_auth_use_case.dart';

@injectable
class AuthViewModel extends Cubit<AuthState> {
  final RegisterAuthUseCase _registerAuthUseCase;

  AuthViewModel(this._registerAuthUseCase) : super(const AuthState());

  void doEvent(AuthEvent event) {
    switch (event) {
      case RegisterEvent():
        _register(event);
        break;
    }
  }

  Future<void> _register(RegisterEvent event) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    try {
      final request = RegisterRequest(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
        gender: event.gender,
        confirmPassword: event.confirmPassword,
      );

      final result = await _registerAuthUseCase.execute(request);

      if (result is SuccessResponce<RegisterEntity>) {
        emit(state.copyWith(isLoading: false, data: result.data));
      } else if (result is ErrorResponce<RegisterEntity>) {
        emit(state.copyWith(
            isLoading: false, errorMessage: result.errorMessage));
      }
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }
}
