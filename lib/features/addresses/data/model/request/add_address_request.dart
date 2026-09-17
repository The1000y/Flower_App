
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'add_address_request.g.dart';

AddAddressRequest addAddressRequestFromJson(String str) => AddAddressRequest.fromJson(json.decode(str));

String addAddressRequestToJson(AddAddressRequest data) => json.encode(data.toJson());

@JsonSerializable()
class AddAddressRequest {
    @JsonKey(name: "recipientName")
    String recipientName;
    @JsonKey(name: "phone")
    String phone;
    @JsonKey(name: "addressLine")
    String addressLine;
    @JsonKey(name: "cityId")
    String cityId;
    @JsonKey(name: "areaId")
    String areaId;
    @JsonKey(name: "latitude")
    double latitude;
    @JsonKey(name: "longitude")
    double longitude;
    @JsonKey(name: "label")
    String label;

    AddAddressRequest({
        required this.recipientName,
        required this.phone,
        required this.addressLine,
        required this.cityId,
        required this.areaId,
        required this.latitude,
        required this.longitude,
        required this.label,
    });

    factory AddAddressRequest.fromJson(Map<String, dynamic> json) => _$AddAddressRequestFromJson(json);

    Map<String, dynamic> toJson() => _$AddAddressRequestToJson(this);
    
  
    
}
