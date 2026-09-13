import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

class ProfileState extends BaseState<UserEntity> {
  const ProfileState({
    super.isLoading,
    super.errorMessage,
    super.data,
  });

  ProfileState copyWith({
    String? errorMessage,
    bool? isLoading,
    UserEntity? data,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}