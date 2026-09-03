import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CartItem extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onDelete;
  final ValueChanged<int> onQuantityChanged;

  const CartItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                item.productImageUrl,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported, size: 60),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('EGP ${item.unitPrice.toStringAsFixed(0)}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'EGP ${item.lineSubtotal.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => onQuantityChanged(-1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(item.quantity.toString()),
                      IconButton(
                        onPressed: () => onQuantityChanged(1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
