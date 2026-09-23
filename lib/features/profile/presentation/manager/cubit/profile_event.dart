import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

sealed class ProfileEvents {}

class FetchProfileEvent extends ProfileEvents {}

class PickProfileImageEvent extends ProfileEvents {}

class UpdateProfileEvent extends ProfileEvents {
  final ProfileEntity profile;
  UpdateProfileEvent({required this.profile});
}