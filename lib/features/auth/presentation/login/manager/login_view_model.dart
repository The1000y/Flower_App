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

  LoginViewModel(this.loginUseCase, this._storage) : super(const LoginState());

  Future<void> handle(LoginIntent intent) async {
    switch (intent) {
      case EmailChanged():
        emit(state.copyWith(email: intent.email, errorMessage: ''));

      case PasswordChanged():
        emit(state.copyWith(password: intent.password, errorMessage: ''));

      case RememberMeChanged():
        await _onRememberMeChanged(intent.value);

      case LoginPressed():
        await _login();
    }
  }

  Future<String?> loadSavedEmail() async {
    final saved = await _storage.getRememberedEmail();
    if (saved != null && saved.isNotEmpty) {
      emit(state.copyWith(email: saved, rememberMe: true));
    }
    return saved;
  }

  Future<void> _onRememberMeChanged(bool value) async {
    emit(state.copyWith(rememberMe: value));
    if (value && state.email.isNotEmpty) {
      await _storage.saveRememberedEmail(state.email);
    } else if (!value) {
      await _storage.deleteRememberedEmail();
    }
  }

  Future<void> _login() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

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
