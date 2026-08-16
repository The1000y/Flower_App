import '../../../../../config/base/base_state.dart';
import '../../../domain/entities/register_entity/register_entity.dart';

class AuthState extends BaseState<RegisterEntity> {
  const AuthState({super.isLoading, super.errorMessage, super.data});

  @override
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    RegisterEntity? data,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
