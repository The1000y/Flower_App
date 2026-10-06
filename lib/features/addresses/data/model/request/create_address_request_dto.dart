import 'package:json_annotation/json_annotation.dart';

part 'create_address_request_dto.g.dart';

@JsonSerializable()
class CreateAddressRequestDto {
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String city;
  final String area;
  final double? lat;
  final double? lng;
  final String? label;

  CreateAddressRequestDto({
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.city,
    required this.area,
    this.lat,
    this.lng,
    this.label,
  });

  factory CreateAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAddressRequestDtoToJson(this);
}