import 'package:json_annotation/json_annotation.dart';

part 'update_address_request_dto.g.dart';

@JsonSerializable()
class UpdateAddressRequestDto {
  @JsonKey(name: "recipientName")
  final String? recipientName;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "addressLine")
  final String? addressLine;
  @JsonKey(name: "cityId")
  final String? cityId;
  @JsonKey(name: "areaId")
  final String? areaId;
  @JsonKey(name: "latitude")
  final double? latitude;
  @JsonKey(name: "longitude")
  final double? longitude;
  @JsonKey(name: "label")
  final String? label;

  UpdateAddressRequestDto({
    this.recipientName,
    this.phone,
    this.addressLine,
    this.cityId,
    this.areaId,
    this.latitude,
    this.longitude,
    this.label,
  });

  factory UpdateAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAddressRequestDtoToJson(this);
}
