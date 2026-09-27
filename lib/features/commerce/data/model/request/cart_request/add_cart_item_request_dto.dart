import 'package:json_annotation/json_annotation.dart';

import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_item_response_dto.dart';

part 'add_cart_item_request_dto.g.dart';

@JsonSerializable()
class AddCartItemRequestDto {
  @JsonKey(fromJson: cartIdFromJson)
  final String productId;

  final int quantity;

  AddCartItemRequestDto({required this.productId, required this.quantity});

  factory AddCartItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemRequestDtoToJson(this);
}
