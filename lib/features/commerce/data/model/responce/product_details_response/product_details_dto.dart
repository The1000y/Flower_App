import 'package:json_annotation/json_annotation.dart';
import 'product_include_item_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';

part 'product_details_dto.g.dart';

@JsonSerializable()
class ProductDetailsDto {
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
  @JsonKey(name: 'images')
  final List<String>? images;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'includes')
  final List<ProductIncludeItemDto>? includes;
  @JsonKey(name: 'categoryId')
  final String? categoryId;
  @JsonKey(name: 'occasionIds')
  final List<String>? occasionIds;

  ProductDetailsDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.currency,
    required this.price,
    this.discountedPrice,
    this.discountPercent,
    this.inStock,
    this.images,
    this.description,
    this.includes,
    this.categoryId,
    this.occasionIds,
  });

  factory ProductDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsDtoToJson(this);

  ProductDetailsEntity toDomain() => ProductDetailsEntity(
    id: id,
    name: name,
    imageUrl: imageUrl,
    currency: currency ?? 'EGP',
    price: discountedPrice ?? price,
    originalPrice: discountedPrice != null ? price : null,
    discountPercentage: discountPercent,
    status: (inStock ?? true) ? 'In Stock' : 'Out of Stock',
    images: images ?? [],
    description: description ?? '',
    includes: includes?.map((e) => e.toDomain()).toList() ?? [],
    categoryId: categoryId ?? '',
    occasionIds: occasionIds ?? [],
  );
}
