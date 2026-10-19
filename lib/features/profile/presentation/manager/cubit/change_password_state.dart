import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ChangePasswordEntity> changePasswordState;

  const ChangePasswordState({
    this.changePasswordState = const BaseState<ChangePasswordEntity>(),
  });

  ChangePasswordState copyWith({
    BaseState<ChangePasswordEntity>? changePasswordState,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object> get props => [changePasswordState];
}
