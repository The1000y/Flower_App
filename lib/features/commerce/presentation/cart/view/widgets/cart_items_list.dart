import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'cart_item.dart';

/// Renders the lines of the cart.
///
/// The widget is intentionally dumb: it forwards the id and the requested new
/// quantity and lets the cubit decide what that means (update or remove).
class CartItemsList extends StatelessWidget {
  final List<CartItemEntity> items;
  final void Function(String cartItemId) onDelete;
  final void Function(String cartItemId, String productId, int newQuantity)
  onQuantityChanged;

  const CartItemsList({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Lottie.asset('assets/lottie_json/Empty.json'),);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return CartItem(
          item: item,
          onDelete: () => onDelete(item.id),
          onQuantityChanged: (newQuantity) =>
              onQuantityChanged(item.id, item.productId, newQuantity),
        );
      },
    );
  }
}
