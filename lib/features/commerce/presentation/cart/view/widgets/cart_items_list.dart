import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flutter/material.dart';

import 'cart_item.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItemEntity> items;
  final void Function(String cartItemId) onDelete;
  final void Function(String cartItemId, int newQuantity) onQuantityChanged;

  const CartItemsList({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItem(
          item: item,
          onDelete: () => onDelete(item.id),
          onQuantityChanged: (delta) {
            final newQuantity = item.quantity + delta;
            if (newQuantity <= 0) {
              onDelete(item.id);
              return;
            }
            onQuantityChanged(item.id, newQuantity);
          },
        );
      },
    );
  }
}
