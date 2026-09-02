
import '../../../domain/entities/address_entity.dart';

sealed class SavedAddressState {}

class SavedAddressInitial extends SavedAddressState {}

class SavedAddressLoading extends SavedAddressState {}

class SavedAddressLoaded extends SavedAddressState {
  final List<AddressEntity> addresses;
  SavedAddressLoaded(this.addresses);
}

class SavedAddressError extends SavedAddressState {
  final String message;
  SavedAddressError(this.message);
}