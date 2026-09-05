import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';

import '../../../domain/entities/address_entity.dart';

class SavedAddressState extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;

  const SavedAddressState({
    this.addressesState = const BaseState<List<AddressEntity>>(data: []),
  });

  SavedAddressState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
  }) {
    return SavedAddressState(
      addressesState: addressesState ?? this.addressesState,
    );
  }

  @override
  List<Object?> get props => [addressesState];
}