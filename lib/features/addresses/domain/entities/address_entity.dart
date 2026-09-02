import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String city;
  final String area;
  final double? lat;
  final double? lng;
  final String? label;
  final bool isDefault;
  final String? storeId;
  final bool isServiceable;

  AddressEntity({
    required this.id,
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.city,
    required this.area,
    this.lat,
    this.lng,
    this.label,
    required this.isDefault,
    this.storeId,
    required this.isServiceable,
  });

  @override
  List<Object?> get props => [
    id,
    recipientName,
    recipientPhone,
    addressLine,
    city,
    area,
    lat,
    lng,
    label,
    isDefault,
    storeId,
    isServiceable,
  ];
}