import 'package:json_annotation/json_annotation.dart';
import 'product_include_item_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';

part 'product_details_dto.g.dart';

@JsonSerializable()
class ProductDetailsDto {
  final int id;
  final String name;
  final String imageUrl;
  final String currency;
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final String status;
  final List<String> images;
  final String description;
  final List<ProductIncludeItemDto> includes;
  final int? categoryId;
  final List<int> occasionIds;

  ProductDetailsDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currency,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
    required this.images,
    required this.description,
    required this.includes,
    this.categoryId,
    required this.occasionIds,
  });

  factory ProductDetailsDto.fromJson(Map<String, dynamic> json) => _$ProductDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsDtoToJson(this);

  ProductDetailsEntity toDomain() => ProductDetailsEntity(
        id: id,
        name: name,
        imageUrl: imageUrl,
        currency: currency,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: discountPercentage,
        status: status,
        images: images,
        description: description,
        includes: includes.map((e) => e.toDomain()).toList(),
        categoryId: categoryId ?? 0,
        occasionIds: occasionIds,
      );
}
