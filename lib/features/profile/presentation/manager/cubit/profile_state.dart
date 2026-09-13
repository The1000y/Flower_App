import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  // Initial fetch of the profile (GET)
  final BaseState<ProfileEntity> profileState;

  // Result of submitting an update (PUT)
  final BaseState<ProfileEntity> updateProfileState;

  // Locally picked avatar path — not uploaded (no upload endpoint yet)
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
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
    );
  }

  @override
  List<Object?> get props => [profileState, updateProfileState, pickedImagePath];
}