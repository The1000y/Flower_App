import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_request_dto.g.dart';

@JsonSerializable()
class UpdateCartItemRequestDto {
  final int quantity;

  UpdateCartItemRequestDto({
    required this.quantity,
  });

  factory UpdateCartItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateCartItemRequestDtoToJson(this);
}