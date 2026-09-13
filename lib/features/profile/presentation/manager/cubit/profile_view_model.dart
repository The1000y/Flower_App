import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_case/get_profile_use_case.dart';
import '../../../domain/use_case/update_profile_use_case.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileViewModel(this._getProfileUseCase, this._updateProfileUseCase) : super(const ProfileState());

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
    try {
      final result = await _getProfileUseCase.call();
      switch (result) {
        case SuccessResponce<ProfileEntity>():
          emit(state.copyWith(
            profileState: BaseState<ProfileEntity>(isLoading: false, data: result.data),
          ));
        case ErrorResponce<ProfileEntity>():
          emit(state.copyWith(
            profileState: BaseState<ProfileEntity>(isLoading: false, errorMessage: result.errorMessage),
          ));
      }
    } catch (e) {
      emit(state.copyWith(
        profileState: BaseState<ProfileEntity>(isLoading: false, errorMessage: e.toString()),
      ));
    }
  }

  void _pickImage(String imagePath) {
    emit(state.copyWith(pickedImagePath: imagePath));
  }

  Future<void> _updateProfile(ProfileEntity profile) async {
    emit(state.copyWith(updateProfileState: BaseState<ProfileEntity>(isLoading: true)));
    try {
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
    } catch (e) {
      emit(state.copyWith(
        updateProfileState: BaseState<ProfileEntity>(isLoading: false, errorMessage: e.toString()),
      ));
    }
  }
}