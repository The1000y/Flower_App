import 'package:flower_app/features/addresses/domain/entities/store_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nearest_store_dto.g.dart';

@JsonSerializable()
class NearestStoreDto {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'address')
  final String? address;
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  @JsonKey(name: 'openingTime')
  final String? openingTime;
  @JsonKey(name: 'closingTime')
  final String? closingTime;

  const NearestStoreDto({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.openingTime,
    this.closingTime,
  });

  factory NearestStoreDto.fromJson(Map<String, dynamic> json) =>
      _$NearestStoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NearestStoreDtoToJson(this);

  StoreEntity toDomain() {
    return StoreEntity(
      id: id ?? "",
      name: name ?? "",
      address: address ?? "",
      phoneNumber: phoneNumber ?? "",
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      openingTime: openingTime ?? "",
      closingTime: closingTime ?? "",
    );
  }
}