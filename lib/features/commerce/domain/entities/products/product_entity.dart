class ProductEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String currency;
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final String status;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currency,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
  });
}