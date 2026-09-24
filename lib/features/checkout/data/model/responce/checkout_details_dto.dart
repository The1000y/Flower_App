// To parse this JSON data, do
//
//     final dataDto = dataDtoFromJson(jsonString);


import 'package:flower_app/features/checkout/data/model/responce/payment_methods_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:json_annotation/json_annotation.dart';


part 'checkout_details_dto.g.dart';



@JsonSerializable()
class CheckoutDetailsDto {
  @JsonKey(name: "subtotal")
  int? subtotal;
  @JsonKey(name: "deliveryFee")
  int? deliveryFee;
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "estimatedDeliveryAt")
  String? estimatedDeliveryAt;
  @JsonKey(name: "paymentMethods")
  List<PaymentMethodsDto>? paymentMethods;
  @JsonKey(name: "isGift")
  bool? isGift;
  @JsonKey(name: "giftRecipientName")
  String? giftRecipientName;
  @JsonKey(name: "giftRecipientPhone")
  String? giftRecipientPhone;

  CheckoutDetailsDto({
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.estimatedDeliveryAt,
    this.paymentMethods,
    this.isGift,
    this.giftRecipientName,
    this.giftRecipientPhone,
  });

  factory CheckoutDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutDetailsDtoToJson(this);

  CheckoutDetailsEntity toEntity() {
    return CheckoutDetailsEntity(
      subtotal: subtotal ?? 0,
      deliveryFee: deliveryFee ?? 0,
      total: total ?? 0,
      estimatedDeliveryAt: estimatedDeliveryAt ?? '',
      paymentMethods:
          paymentMethods?.map((element) {
            return PaymentMethodEntity(
              method: element.method ?? '',
              gateways: element.gateways ?? const [],
            );
          }).toList() ??
          [],
      isGift: isGift ?? false,
      giftRecipientName: giftRecipientName,
      giftRecipientPhone: giftRecipientPhone,
    );
  }
}


