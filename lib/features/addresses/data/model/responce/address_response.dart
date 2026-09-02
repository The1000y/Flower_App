// To parse this JSON data, do
//
//     final addressResponse = addressResponseFromJson(jsonString);

import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'address_response.g.dart';

AddressResponse addressResponseFromJson(String str) => AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) => json.encode(data.toJson());

@JsonSerializable()
class AddressResponse {
    @JsonKey(name: "data")
    AddressDto? data;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "messageLocalized")
    String? messageLocalized;
    @JsonKey(name: "statusCode")
    String? statusCode;

    AddressResponse({
        this.data,
        this.isSuccess,
        this.message,
        this.messageLocalized,
        this.statusCode,
    });

    factory AddressResponse.fromJson(Map<String, dynamic> json) => _$AddressResponseFromJson(json);

    Map<String, dynamic> toJson() => _$AddressResponseToJson(this);
}

