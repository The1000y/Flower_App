import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'originalPrice')
  final double? originalPrice;

  @JsonKey(name: 'discountPercentage')
  final double? discountPercentage;

  @JsonKey(name: 'status')
  final String status;

  ProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currency,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
  });

  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      currency: currency,
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      status: status,
    );
  }

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}