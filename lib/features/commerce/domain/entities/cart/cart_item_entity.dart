class CartItemEntity {
  final String id;
  final int productId;
  final String productName;
  final String productImageUrl;
  final double unitPrice;
  final int quantity;
  final double lineSubtotal;
  final bool inStock;
  final int? availableStock;
  final bool priceChanged;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.lineSubtotal,
    required this.inStock,
    this.availableStock,
    required this.priceChanged,
  });
}