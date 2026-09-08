import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';

class ChangePasswordState extends Equatable {
  final BaseState<bool> changePasswordState;

  const ChangePasswordState({
    this.changePasswordState = const BaseState<bool>(),
  });

  ChangePasswordState copyWith({
    BaseState<bool>? changePasswordState,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object> get props => [changePasswordState];
}
