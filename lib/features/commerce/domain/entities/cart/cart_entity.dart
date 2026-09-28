import 'cart_item_entity.dart';

class CartEntity {
  final List<CartItemEntity> items;
  final double subtotal;
  final double? deliveryFee;
  final double total;
  final bool hasChanges;

  CartEntity({
    required this.items,
    required this.subtotal,
    this.deliveryFee,
    required this.total,
    required this.hasChanges,
  });
}