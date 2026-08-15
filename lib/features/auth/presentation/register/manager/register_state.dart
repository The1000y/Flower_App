import '../../../../../config/base/base_state.dart';
import '../../../domain/entities/register_entity/auth_entity.dart';

class AuthState extends BaseState<AuthEntity> {
  const AuthState({super.isLoading, super.errorMessage, super.data});

  @override
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    AuthEntity? data,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
