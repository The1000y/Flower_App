import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/address_entity.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDto {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'recipientName')
  final String recipientName;
  @JsonKey(name: 'recipientPhone')
  final String recipientPhone;
  @JsonKey(name: 'addressLine')
  final String addressLine;
  @JsonKey(name: 'city')
  final String city;
  @JsonKey(name: 'area')
  final String area;
  @JsonKey(name: 'lat')
  final double? lat;
  @JsonKey(name: 'lng')
  final double? lng;
  @JsonKey(name: 'label')
  final String? label;
  @JsonKey(name: 'isDefault')
  final bool isDefault;
  @JsonKey(name: 'storeId')
  final String? storeId;
  @JsonKey(name: 'isServiceable')
  final bool isServiceable;

  AddressDto({
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

  AddressEntity toDomain() {
    return AddressEntity(
      id: id,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      addressLine: addressLine,
      city: city,
      area: area,
      lat: lat,
      lng: lng,
      label: label,
      isDefault: isDefault,
      storeId: storeId,
      isServiceable: isServiceable,
    );
  }

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);
}