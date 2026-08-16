import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';

class LoginState extends BaseState<LoginEntity> {
  final String email;
  final String password;
  final bool rememberMe;
  final bool loginSuccess;

  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.loginSuccess = false,
    super.isLoading,
    super.errorMessage,
    super.data,
  });

  @override
  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? loginSuccess,
    bool? isLoading,
    String? errorMessage,
    LoginEntity? data,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        password,
        rememberMe,
        loginSuccess,
      ];
}