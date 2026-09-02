sealed class SavedAddressEvent {}

class LoadAddresses extends SavedAddressEvent {}

class DeleteAddressPressed extends SavedAddressEvent {
  final String id;
  DeleteAddressPressed(this.id);
}

class SetDefaultAddressPressed extends SavedAddressEvent {
  final String id;
  SetDefaultAddressPressed(this.id);
}