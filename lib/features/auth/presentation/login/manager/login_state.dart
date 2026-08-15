import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';

class LoginState extends BaseState<LoginEntity> {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    super.isLoading,
    super.errorMessage,
    super.data,
  });

  @override
  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
    LoginEntity? data,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}