// To parse this JSON data, do
//
//     final paymentMethods = paymentMethodsFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';


part 'payment_methods_dto.g.dart';



@JsonSerializable()
class PaymentMethodsDto {
    @JsonKey(name: "method")
    String? method;
    @JsonKey(name: "gateways")
    List<String>? gateways;

    PaymentMethodsDto({
        this.method,
        this.gateways,
    });

    factory PaymentMethodsDto.fromJson(Map<String, dynamic> json) => _$PaymentMethodsDtoFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentMethodsDtoToJson(this);
}
