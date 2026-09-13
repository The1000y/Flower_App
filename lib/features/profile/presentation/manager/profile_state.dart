import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

class ProfileHomeState extends BaseState<UserEntity> {
  const ProfileHomeState({
    super.isLoading,
    super.errorMessage,
    super.data,
  });

  @override
  ProfileHomeState copyWith({
    String? errorMessage,
    bool? isLoading,
    UserEntity? data,
  }) {
    return ProfileHomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}