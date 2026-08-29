import 'package:json_annotation/json_annotation.dart';

import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';

import 'cart_item_response_dto.dart';

part 'cart_response_dto.g.dart';

@JsonSerializable()
class CartResponseDto {
  final CartDataDto data;

  final bool isSuccess;

  final String message;

  final String messageLocalized;

  final String statusCode;

  CartResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.messageLocalized,
    required this.statusCode,
  });

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CartResponseDtoToJson(this);

  CartEntity toDomain() => data.toDomain();
}

@JsonSerializable()
class CartDataDto {
  final List<CartItemResponseDto> items;

  final double subtotal;

  final double? deliveryFee;

  final double total;

  final bool hasChanges;

  CartDataDto({
    required this.items,
    required this.subtotal,
    this.deliveryFee,
    required this.total,
    required this.hasChanges,
  });

  factory CartDataDto.fromJson(Map<String, dynamic> json) =>
      _$CartDataDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CartDataDtoToJson(this);

  CartEntity toDomain() => CartEntity(
        items: items.map((item) => item.toDomain()).toList(),
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        hasChanges: hasChanges,
      );
}