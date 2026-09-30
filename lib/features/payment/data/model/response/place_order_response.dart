// To parse this JSON data, do
//
//     final placeOrderResponse = placeOrderResponseFromJson(jsonString);

import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'place_order_response.g.dart';

PlaceOrderResponse placeOrderResponseFromJson(String str) => PlaceOrderResponse.fromJson(json.decode(str));

String placeOrderResponseToJson(PlaceOrderResponse data) => json.encode(data.toJson());

@JsonSerializable()
class PlaceOrderResponse {
    @JsonKey(name: "data")
    PlaceOrderDto? data;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "messageLocalized")
    String? messageLocalized;
    @JsonKey(name: "statusCode")
    String? statusCode;

    PlaceOrderResponse({
        this.data,
        this.isSuccess,
        this.message,
        this.messageLocalized,
        this.statusCode,
    });

    factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) => _$PlaceOrderResponseFromJson(json);

    Map<String, dynamic> toJson() => _$PlaceOrderResponseToJson(this);
}

