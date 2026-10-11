import 'package:equatable/equatable.dart';

class AddAddressParams extends Equatable {
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String city;
  final String area;
  final String cityId;
  final String areaId;
  final double lat;
  final double lng;
  final String label;

  const AddAddressParams({
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.city,
    required this.area,
    required this.cityId,
    required this.areaId,
    required this.lat,
    required this.lng,
    required this.label,
  });

  @override
  List<Object?> get props => [
    recipientName,
    recipientPhone,
    addressLine,
    city,
    area,
    cityId,
    areaId,
    lat,
    lng,
    label,
  ];
}
