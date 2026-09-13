
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'add_address_request.g.dart';

AddAddressRequest addAddressRequestFromJson(String str) => AddAddressRequest.fromJson(json.decode(str));

String addAddressRequestToJson(AddAddressRequest data) => json.encode(data.toJson());

@JsonSerializable()
class AddAddressRequest {
    @JsonKey(name: "recipientName")
    String recipientName;
    @JsonKey(name: "recipientPhone")
    String recipientPhone;
    @JsonKey(name: "addressLine")
    String addressLine;
    @JsonKey(name: "city")
    String city;
    @JsonKey(name: "area")
    String area;
    @JsonKey(name: "lat")
    double lat;
    @JsonKey(name: "lng")
    double lng;
    @JsonKey(name: "label")
    String label;

    AddAddressRequest({
        required this.recipientName,
        required this.recipientPhone,
        required this.addressLine,
        required this.city,
        required this.area,
        required this.lat,
        required this.lng,
        required this.label,
    });

    factory AddAddressRequest.fromJson(Map<String, dynamic> json) => _$AddAddressRequestFromJson(json);

    Map<String, dynamic> toJson() => _$AddAddressRequestToJson(this);
    
  
    
}
