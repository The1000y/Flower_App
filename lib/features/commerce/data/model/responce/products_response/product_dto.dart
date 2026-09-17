import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  @JsonKey(name: 'currency')
  final String? currency;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'discountedPrice')
  final double? discountedPrice;

  @JsonKey(name: 'discountPercent')
  final double? discountPercent;

  @JsonKey(name: 'inStock')
  final bool? inStock;

  ProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.currency,
    required this.price,
    this.discountedPrice,
    this.discountPercent,
    this.inStock,
  });

  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      currency: currency ?? 'EGP',
      price: discountedPrice ?? price,
      originalPrice: discountedPrice != null ? price : null,
      discountPercentage: discountPercent,
      status: (inStock ?? true) ? 'In Stock' : 'Out of Stock',
    );
  }

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
