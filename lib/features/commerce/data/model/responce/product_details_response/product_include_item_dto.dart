import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/product_details/product_include_item_entity.dart';

part 'product_include_item_dto.g.dart';

@JsonSerializable()
class ProductIncludeItemDto {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'quantity')
  final int? quantity;

  ProductIncludeItemDto({
    required this.name,
    this.quantity,
  });

  ProductIncludeItemEntity toDomain() {
    return ProductIncludeItemEntity(
      name: name,
      quantity: quantity,
    );
  }

  factory ProductIncludeItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProductIncludeItemDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductIncludeItemDtoToJson(this);
}