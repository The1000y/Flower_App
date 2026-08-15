import 'package:bloc/bloc.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase) : super(const LoginState());

  Future<void> handle(LoginIntent intent) async {
    switch (intent) {
      case EmailChanged():
        emit(state.copyWith(email: intent.email));

      case PasswordChanged():
        emit(state.copyWith(password: intent.password));

      case RememberMeChanged():
        emit(state.copyWith(rememberMe: intent.value));

      case LoginPressed():
        await _login();
    }
  }

  Future<void> _login() async {
    emit(state.copyWith(isLoading: true));

    final result = await loginUseCase(
      RequestLogin(email: state.email, password: state.password),
    );

    switch (result) {
      case SuccessResponce<LoginEntity>(data: final login):
        emit(state.copyWith(isLoading: false, data: login));

      case ErrorResponce<LoginEntity>(errorMessage: final msg):
        emit(state.copyWith(isLoading: false, errorMessage: msg));
    }
  }
}
