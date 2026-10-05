import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._getProfileUseCase) : super(const ProfileState());

  final GetProfileUseCase _getProfileUseCase;

  void doIntent(ProfileIntent intent) {
    switch (intent) {
      case GetProfileIntent():
        _getProfile();
      case EditProfileIntent():
        break;
      case NotificationIntent():
        break;
      case LogoutIntent():
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(
        baseState: state.baseState.copyWith(isLoading: true, errorMessage: ''),
      ),
    );

    final result = await _getProfileUseCase.call();

    switch (result) {
      case SuccessResponce<ProfileEntity>():
        emit(
          state.copyWith(
            baseState: state.baseState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: result.data,
            ),
          ),
        );

      case ErrorResponce<ProfileEntity>():
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
