import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileHomeViewModel extends Cubit<ProfileHomeState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileHomeViewModel(this._getProfileUseCase)
      : super(const ProfileHomeState());

  void doIntent(ProfileHomeIntent intent) {
    switch (intent) {
      case GetProfileIntent():
        _getProfile();
      case EditProfileIntent():
      case NotificationIntent():
      case LogoutIntent():
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(isLoading: true));

    final result = await _getProfileUseCase.call();

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