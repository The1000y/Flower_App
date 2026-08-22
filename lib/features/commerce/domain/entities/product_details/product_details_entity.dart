import 'product_include_item_entity.dart';

class ProductDetailsEntity {
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
  final List<ProductIncludeItemEntity> includes;
  final int? categoryId;
  final List<int> occasionIds;

  ProductDetailsEntity({
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
}

