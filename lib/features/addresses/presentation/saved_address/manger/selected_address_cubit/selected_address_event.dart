sealed class SelectedAddressEvent {}

class AddressSelectedEvent extends SelectedAddressEvent {
  final String addressId;
  final String label;

  AddressSelectedEvent({required this.addressId, required this.label});
}