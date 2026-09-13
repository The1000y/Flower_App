import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final ShowProfileUsecase _getProfileUseCase;

  ProfileViewModel(this._getProfileUseCase)
      : super(const ProfileState());

  void doIntent(ProfileIntent intent) {
    switch (intent) {
      case GetProfileIntent():
        _getProfile();

      
      case EditProfileIntent():
        // TODO: Handle this case.
        throw UnimplementedError();
      case NotificationIntent():
        // TODO: Handle this case.
        throw UnimplementedError();
      case LanguageIntent():
        // TODO: Handle this case.
        throw UnimplementedError();
      case LogoutIntent():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(isLoading: true));

    final result = await _getProfileUseCase.getProfile();

    switch (result) {
      case SuccessResponce<UserEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            data: result.data,
          ),
        );

      case ErrorResponce<UserEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }
}