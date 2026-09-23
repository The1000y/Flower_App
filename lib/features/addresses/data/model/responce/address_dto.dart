import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'address_dto.g.dart';

AddressDto addressDtoFromJson(String str) => AddressDto.fromJson(json.decode(str));

String addressDtoToJson(AddressDto data) => json.encode(data.toJson());

@JsonSerializable()
class AddressDto {
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "recipientName")
    String? recipientName;
    @JsonKey(name: "recipientPhone")
    String? recipientPhone;
    @JsonKey(name: "phone")
    String? phone;
    @JsonKey(name: "addressLine")
    String? addressLine;
    @JsonKey(name: "city")
    String? city;
    @JsonKey(name: "area")
    String? area;
    @JsonKey(name: "cityId")
    String? cityId;
    @JsonKey(name: "areaId")
    String? areaId;
    @JsonKey(name: "lat")
    double? lat;
    @JsonKey(name: "lng")
    double? lng;
    @JsonKey(name: "latitude")
    double? latitude;
    @JsonKey(name: "longitude")
    double? longitude;
    @JsonKey(name: "label")
    String? label;
    @JsonKey(name: "isDefault")
    bool? isDefault;
    @JsonKey(name: "storeId")
    String? storeId;
    @JsonKey(name: "isServiceable")
    bool? isServiceable;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;

    AddressDto({
        this.id,
        this.recipientName,
        this.recipientPhone,
        this.phone,
        this.addressLine,
        this.city,
        this.area,
        this.cityId,
        this.areaId,
        this.lat,
        this.lng,
        this.latitude,
        this.longitude,
        this.label,
        this.isDefault,
        this.storeId,
        this.isServiceable,
        this.createdAt,
    });

    factory AddressDto.fromJson(Map<String, dynamic> json) => _$AddressDtoFromJson(json);

    Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

    AddressEntity toDomain() {
      return AddressEntity(
        id: id ?? "",
        recipientName: recipientName ?? "",
        recipientPhone: recipientPhone ?? phone ?? "",
        addressLine: addressLine ?? "",
        city: city ?? "",
        area: area ?? "",
        cityId: cityId,
        areaId: areaId,
        lat: lat ?? latitude ?? 0.0,
        lng: lng ?? longitude ?? 0.0,
        label: label ?? "",
        isDefault: isDefault ?? false,
        storeId: storeId ?? "",
        isServiceable: isServiceable ?? false,
        createdAt: createdAt ?? DateTime.now(),
      );
    }
}
