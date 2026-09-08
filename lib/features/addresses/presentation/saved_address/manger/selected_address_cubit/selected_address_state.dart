import 'package:equatable/equatable.dart';

class SelectedAddressState extends Equatable {
  final String? label;
  final String? addressId;

  const SelectedAddressState({this.label, this.addressId});

  @override
  List<Object?> get props => [label, addressId];
}