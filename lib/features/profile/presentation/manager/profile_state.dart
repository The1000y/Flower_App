import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

class ProfileState extends Equatable {
  const ProfileState({BaseState<UserEntity>? baseState})
    : baseState = baseState ?? const BaseState<UserEntity>();

  final BaseState<UserEntity> baseState;

  bool get isLoading => baseState.isLoading;

  String get errorMessage => baseState.errorMessage;

  UserEntity? get data => baseState.data;

  ProfileState copyWith({BaseState<UserEntity>? baseState}) {
    return ProfileState(baseState: baseState ?? this.baseState);
  }

  @override
  List<Object?> get props => [baseState];
}
