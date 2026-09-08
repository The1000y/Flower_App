import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ChangePasswordResponse> changePasswordState;

  const ChangePasswordState({
    this.changePasswordState = const BaseState<ChangePasswordResponse>(),
  });

  ChangePasswordState copyWith({
    BaseState<ChangePasswordResponse>? changePasswordState,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object> get props => [changePasswordState];
}
