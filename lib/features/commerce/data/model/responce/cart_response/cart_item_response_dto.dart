import 'package:json_annotation/json_annotation.dart';

import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';

part 'cart_item_response_dto.g.dart';

@JsonSerializable()
class CartItemResponseDto {
  final String id;

  final int productId;

  final String productName;

  final String productImageUrl;

  final double unitPrice;

  final int quantity;

  final double lineSubtotal;

  final bool inStock;

  final int? availableStock;

  final bool priceChanged;

  CartItemResponseDto({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.lineSubtotal,
    required this.inStock,
    this.availableStock,
    required this.priceChanged,
  });

  factory CartItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CartItemResponseDtoToJson(this);

  CartItemEntity toDomain() => CartItemEntity(
        id: id,
        productId: productId,
        productName: productName,
        productImageUrl: productImageUrl,
        unitPrice: unitPrice,
        quantity: quantity,
        lineSubtotal: lineSubtotal,
        inStock: inStock,
        availableStock: availableStock,
        priceChanged: priceChanged,
      );
}