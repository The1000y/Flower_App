// To parse this JSON data, do
//
//     final checkoutResponce = checkoutResponceFromJson(jsonString);

import 'package:flower_app/features/checkout/data/model/responce/data_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'checkout_responce.g.dart';

CheckoutResponce checkoutResponceFromJson(String str) =>
    CheckoutResponce.fromJson(json.decode(str));

String checkoutResponceToJson(CheckoutResponce data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CheckoutResponce {
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  DataDto? data;
  @JsonKey(name: "error")
  Error? error;

  CheckoutResponce({this.success, this.message, this.data, this.error});

  factory CheckoutResponce.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponceFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutResponceToJson(this);
}

@JsonSerializable()
class Error {
  @JsonKey(name: "code")
  String? code;
  @JsonKey(name: "field")
  String? field;

  Error({this.code, this.field});

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
