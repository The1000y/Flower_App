import 'package:json_annotation/json_annotation.dart';

part 'update_address_request_dto.g.dart';

@JsonSerializable()
class UpdateAddressRequestDto {
  final String? recipientName;
  final String? recipientPhone;
  final String? addressLine;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;
  final String? label;

  UpdateAddressRequestDto({
    this.recipientName,
    this.recipientPhone,
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
    this.label,
  });

  factory UpdateAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAddressRequestDtoToJson(this);
}