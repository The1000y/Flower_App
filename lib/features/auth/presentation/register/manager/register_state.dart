import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';

class RegisterState extends BaseState<RegisterEntity> {
  const RegisterState({super.isLoading, super.errorMessage, super.data});

  @override
  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    RegisterEntity? data,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
