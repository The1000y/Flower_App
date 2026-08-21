import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_include_item_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_dto.g.dart';

@JsonSerializable()
class ProductDetailsDto {
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

  @JsonKey(name: 'images')
  final List<String> images;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'includes')
  final List<ProductIncludeItemDto> includes;

  @JsonKey(name: 'categoryId')
  final int? categoryId;

  @JsonKey(name: 'occasionIds')
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

  ProductDetailsEntity toDomain() {
    return ProductDetailsEntity(
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
      includes: includes.map((item) => item.toDomain()).toList(),
      categoryId: categoryId,
      occasionIds: occasionIds,
    );
  }

  factory ProductDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsDtoToJson(this);
}