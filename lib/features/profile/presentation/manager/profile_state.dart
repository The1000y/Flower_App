import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  const ProfileState({BaseState<ProfileEntity>? baseState})
    : baseState = baseState ?? const BaseState<ProfileEntity>();

  final BaseState<ProfileEntity> baseState;

  bool get isLoading => baseState.isLoading;

  String get errorMessage => baseState.errorMessage;

  ProfileEntity? get data => baseState.data;

  ProfileState copyWith({BaseState<ProfileEntity>? baseState}) {
    return ProfileState(baseState: baseState ?? this.baseState);
  }

  @override
  List<Object?> get props => [baseState];
}
