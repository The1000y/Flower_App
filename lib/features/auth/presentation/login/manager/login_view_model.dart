import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/load_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase, this._loadRememberedEmailUseCase)
    : super(const LoginState());

  final LoginUseCase _loginUseCase;
  final LoadRememberedEmailUseCase _loadRememberedEmailUseCase;

  Future<void> handle(LoginIntent intent) async {
    switch (intent) {
      case LoadRememberedEmail():
        await _loadRememberedEmail();

      case EmailChanged():
        emit(state.copyWith(email: intent.email, errorMessage: ''));

      case PasswordChanged():
        emit(state.copyWith(password: intent.password, errorMessage: ''));

      case RememberMeChanged():
        emit(state.copyWith(rememberMe: intent.value));

      case TogglePasswordVisibility():
        emit(state.copyWith(obscurePassword: !state.obscurePassword));

      case LoginPressed():
        await _login();
    }
  }

  Future<void> _loadRememberedEmail() async {
    final savedEmail = await _loadRememberedEmailUseCase();

    if (savedEmail != null && savedEmail.isNotEmpty && state.email.isEmpty) {
      emit(state.copyWith(email: savedEmail, rememberMe: true));
    }
  }

  Future<void> _login() async {
    emit(
      state.copyWith(isLoading: true, errorMessage: '', loginSuccess: false),
    );

    // `rememberMe` is forwarded and applied by the repository. Persisting the
    // remembered email here as well duplicated the policy in two layers and
    // could leave the two disagreeing about what was stored.
    final result = await _loginUseCase(
      LoginCredentials(email: state.email, password: state.password),
      rememberMe: state.rememberMe,
    );

    switch (result) {
      case SuccessResponce<LoginEntity>(data: final login):
        emit(state.copyWith(isLoading: false, data: login, loginSuccess: true));

      case ErrorResponce<LoginEntity>(errorMessage: final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }
}
