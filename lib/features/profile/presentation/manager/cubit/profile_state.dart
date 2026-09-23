import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final BaseState<ProfileEntity> profileState;

  final BaseState<ProfileEntity> updateProfileState;

  final String? pickedImagePath;

  const ProfileState({
    this.profileState = const BaseState(),
    this.updateProfileState = const BaseState(),
    this.pickedImagePath,
  });

  ProfileState copyWith({
    BaseState<ProfileEntity>? profileState,
    BaseState<ProfileEntity>? updateProfileState,
    String? pickedImagePath,
    bool clearPickedImage = false,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      pickedImagePath:
      clearPickedImage ? null : (pickedImagePath ?? this.pickedImagePath),
    );
  }

  @override
  List<Object?> get props => [profileState, updateProfileState, pickedImagePath];
}