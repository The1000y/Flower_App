// To parse this JSON data, do
//
//     final checkoutResponce = checkoutResponceFromJson(jsonString);

import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_error.dart';
import 'package:json_annotation/json_annotation.dart';


part 'checkout_responce.g.dart';



@JsonSerializable()
class CheckoutResponce {
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  CheckoutDetailsDto? data;
  @JsonKey(name: "error")
  CheckoutError? error;

  CheckoutResponce({this.success, this.message, this.data, this.error});

  factory CheckoutResponce.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponceFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutResponceToJson(this);
}

