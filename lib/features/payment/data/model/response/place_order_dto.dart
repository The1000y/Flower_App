// To parse this JSON data, do
//
//     final placeOrderDto = placeOrderDtoFromJson(jsonString);

import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'place_order_dto.g.dart';

PlaceOrderDto placeOrderDtoFromJson(String str) =>
    PlaceOrderDto.fromJson(json.decode(str));

String placeOrderDtoToJson(PlaceOrderDto data) => json.encode(data.toJson());

@JsonSerializable()
class PlaceOrderDto {
  @JsonKey(name: "orderId")
  String? orderId;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "gateway")
  String? gateway;
  @JsonKey(name: "sessionId")
  String? sessionId;
  @JsonKey(name: "sessionUrl")
  String? sessionUrl;
  @JsonKey(name: "successUrl")
  String? successUrl;
  @JsonKey(name: "cancelUrl")
  String? cancelUrl;
  @JsonKey(name: "expiresAt")
  DateTime? expiresAt;
  @JsonKey(name: "amount")
  int? amount;
  @JsonKey(name: "currency")
  String? currency;
  @JsonKey(name: "estimatedDeliveryAt")
  DateTime? estimatedDeliveryAt;

  PlaceOrderDto({
    this.orderId,
    this.status,
    this.gateway,
    this.sessionId,
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
    this.expiresAt,
    this.amount,
    this.currency,
    this.estimatedDeliveryAt,
  });

  factory PlaceOrderDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderDtoToJson(this);

  PlaceOrderEntity toEntity() {
    return PlaceOrderEntity(
      sessionId: sessionId,
      sessionUrl: sessionUrl,
      message: '',
    );
  }
}
