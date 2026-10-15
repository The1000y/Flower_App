// To parse this JSON data, do
//
//     final placeOrderRequest = placeOrderRequestFromJson(jsonString);

import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'place_order_request.g.dart';

PlaceOrderRequest placeOrderRequestFromJson(String str) =>
    PlaceOrderRequest.fromJson(json.decode(str));

String placeOrderRequestToJson(PlaceOrderRequest data) =>
    json.encode(data.toJson());

@JsonSerializable(includeIfNull: false)
class PlaceOrderRequest {
  @JsonKey(name: "addressId")
  String addressId;
  @JsonKey(name: "paymentMethod")
  String paymentMethod;
  @JsonKey(name: "paymentGateway")
  String paymentGateway;
  @JsonKey(name: "isGift")
  bool? isGift;
  @JsonKey(name: "giftRecipientName")
  String? giftRecipientName;
  @JsonKey(name: "giftRecipientPhone")
  String? giftRecipientPhone;

  PlaceOrderRequest({
    required this.addressId,
    required this.paymentMethod,
    required this.paymentGateway,
    this.isGift,
    this.giftRecipientName,
    this.giftRecipientPhone,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderRequestToJson(this);

  // factory PlaceOrderRequest.fromParam(PlaceOrderParam param) {
  //   final isCard = param.paymentMethod == CheckoutPaymentMethod.Card;
  //   return PlaceOrderRequest(
  //     addressId: param.addressId,
  //     paymentMethod: isCard ? "card" : "cash",
  //     paymentGateway: isCard ? 'Paymob' :"cash",
  //     isGift: param.isGift,
  //     giftRecipientName: param.giftRecipientName,
  //     giftRecipientPhone: param.giftRecipientPhone,
  //   );
  // }
  factory PlaceOrderRequest.fromParam(PlaceOrderParam param) {
    final isCard = param.paymentMethod == CheckoutPaymentMethod.Card;
    return PlaceOrderRequest(
      addressId: param.addressId,
      paymentMethod: param.paymentMethod.name, // "COD" أو "Card"
      paymentGateway: isCard ? 'Paymob' : 'cash',
      isGift: param.isGift,
      giftRecipientName: param.isGift ? param.giftRecipientName : null,
      giftRecipientPhone: param.isGift ? param.giftRecipientPhone : null,
    );
  }
}
