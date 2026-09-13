import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_case/get_profile_usecase.dart';
import '../../../domain/use_case/update_profile_use_case.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileViewModel(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const ProfileState());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case FetchProfileEvent():
        _fetchProfile();
        break;
      case PickProfileImageEvent():
        _pickImage(event.imagePath);
        break;
      case UpdateProfileEvent():
        _updateProfile(event.profile);
        break;
    }
  }

  Future<void> _fetchProfile() async {
    emit(state.copyWith(profileState: BaseState<ProfileEntity>(isLoading: true)));
    final result = await _getProfileUseCase.call();
    switch (result) {
      case SuccessResponce<UserEntity>():
        emit(state.copyWith(
          profileState: BaseState<ProfileEntity>(
            isLoading: false,
            data: _userToProfile(result.data),
          ),
        ));
      case ErrorResponce<UserEntity>():
        emit(state.copyWith(
          profileState: BaseState<ProfileEntity>(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ));
    }
  }

  void _pickImage(String imagePath) {
    emit(state.copyWith(pickedImagePath: imagePath));
  }

  Future<void> _updateProfile(ProfileEntity profile) async {
    emit(state.copyWith(updateProfileState: BaseState<ProfileEntity>(isLoading: true)));
    final result = await _updateProfileUseCase.call(profile);
    switch (result) {
      case SuccessResponce<ProfileEntity>():
        emit(state.copyWith(
          updateProfileState: BaseState<ProfileEntity>(isLoading: false, data: result.data),
        ));
      case ErrorResponce<ProfileEntity>():
        emit(state.copyWith(
          updateProfileState: BaseState<ProfileEntity>(isLoading: false, errorMessage: result.errorMessage),
        ));
    }
  }

  ProfileEntity _userToProfile(UserEntity user) {
    final parts = user.fullName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty && parts.first.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return ProfileEntity(
      firstName: firstName,
      lastName: lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
      photoUrl: user.photoUrl,
    );
  }
}