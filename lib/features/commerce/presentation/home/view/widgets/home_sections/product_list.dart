import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProductList extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            image: product.imageUrl,
            name: product.name,
            price: product.price,
            oldPrice: product.originalPrice,
            discount: product.discountPercentage?.toInt(),
            onAddToCart: () {},
          );
        },
      ),
    );
  }
}
