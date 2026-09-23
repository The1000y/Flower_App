import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
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
  final ImagePickerService _imagePickerService;

  ProfileViewModel(
      this._getProfileUseCase,
      this._updateProfileUseCase,
      this._imagePickerService,
      ) : super(const ProfileState());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case FetchProfileEvent():
        _fetchProfile();
      case PickProfileImageEvent():
        _pickImage();
      case UpdateProfileEvent():
        _updateProfile(event.profile);
    }
  }

  Future<void> _fetchProfile() async {
    emit(state.copyWith(
      profileState: const BaseState<ProfileEntity>(isLoading: true),
    ));
    final result = await _getProfileUseCase.call();
    switch (result) {
      case SuccessResponce<ProfileEntity>():
        emit(state.copyWith(
          profileState: BaseState<ProfileEntity>(data: result.data),
        ));
      case ErrorResponce<ProfileEntity>():
        emit(state.copyWith(
          profileState: BaseState<ProfileEntity>(errorMessage: result.errorMessage),
        ));
    }
  }

  Future<void> _pickImage() async {
    final path = await _imagePickerService.pickFromGallery();
    if (path != null) {
      emit(state.copyWith(pickedImagePath: path));
    }
  }

  Future<void> _updateProfile(ProfileEntity profile) async {
    emit(state.copyWith(
      updateProfileState: const BaseState<ProfileEntity>(isLoading: true),
    ));
    final result = await _updateProfileUseCase.call(profile);
    switch (result) {
      case SuccessResponce<ProfileEntity>():
        emit(state.copyWith(
          // keep the loaded profile in sync so "has changes" compares against it
          profileState: BaseState<ProfileEntity>(data: result.data),
          updateProfileState: BaseState<ProfileEntity>(data: result.data),
          clearPickedImage: true,
        ));
      case ErrorResponce<ProfileEntity>():
        emit(state.copyWith(
          updateProfileState: BaseState<ProfileEntity>(errorMessage: result.errorMessage),
        ));
    }
  }
}