import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SecureStorageService _storage;

  LoginViewModel(
    this.loginUseCase,
    this._storage,
  ) : super(const LoginState());

  Future<void> handle(LoginIntent intent) async {
    switch (intent) {
      case LoadRememberedEmail():
        await _loadRememberedEmail();

      case EmailChanged():
        emit(
          state.copyWith(
            email: intent.email,
            errorMessage: '',
          ),
        );

      case PasswordChanged():
        emit(
          state.copyWith(
            password: intent.password,
            errorMessage: '',
          ),
        );

      case RememberMeChanged():
        emit(
          state.copyWith(
            rememberMe: intent.value,
          ),
        );

      case LoginPressed():
        await _login();
    }
  }

  Future<void> _loadRememberedEmail() async {
    final savedEmail = await _storage.getRememberedEmail();

    if (savedEmail != null && savedEmail.isNotEmpty) {
      emit(
        state.copyWith(
          email: savedEmail,
          rememberMe: true,
        ),
      );
    }
  }

  Future<void> _login() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
        loginSuccess: false,
      ),
    );

    final result = await loginUseCase(
      RequestLogin(
        email: state.email,
        password: state.password,
      ),
    );

    switch (result) {
      case SuccessResponce<LoginEntity>(data: final login):

        if (state.rememberMe) {
          await _storage.saveRememberedEmail(state.email);
        } else {
          await _storage.deleteRememberedEmail();
        }

        emit(
          state.copyWith(
            isLoading: false,
            data: login,
            loginSuccess: true,
          ),
        );

      case ErrorResponce<LoginEntity>(errorMessage: final message):

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: message,
          ),
        );
    }
  }
}