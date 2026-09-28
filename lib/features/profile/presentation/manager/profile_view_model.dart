import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._getProfileUseCase) : super(const ProfileState());

  final ShowProfileUsecase _getProfileUseCase;

  void doIntent(ProfileIntent intent) {
    switch (intent) {
      case GetProfileIntent():
        _getProfile();
      case EditProfileIntent():
        // Handled via navigation
        break;
      case NotificationIntent():
        // Handled via navigation
        break;
      case LogoutIntent():
        // Handled via confirmation dialog
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(
        baseState: state.baseState.copyWith(
          isLoading: true,
          // Cleared on entry so a retry does not show the previous failure while
          // it is still in flight.
          errorMessage: '',
        ),
      ),
    );

    // `getProfile()` reports failures as an `ErrorResponce` value, so there is
    // no `try/catch` here: an unexpected throw would be a bug in the data
    // layer's contract rather than a recoverable state, and hiding it behind a
    // generic message made real bugs invisible.
    final result = await _getProfileUseCase.getProfile();

    switch (result) {
      case SuccessResponce<UserEntity>():
        emit(
          state.copyWith(
            baseState: state.baseState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: result.data,
            ),
          ),
        );

      case ErrorResponce<UserEntity>():
        emit(
          state.copyWith(
            baseState: state.baseState.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }
}
