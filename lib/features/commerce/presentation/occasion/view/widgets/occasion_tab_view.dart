import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class OccasionTabView extends StatelessWidget {
  final String occasion;

  const OccasionTabView({super.key, required this.occasion});

  List<ProductModel> get filteredProducts {
    if (occasion == AppOccasions.all.first) return occasionProducts;
    return occasionProducts
        .where((product) => product.occasion == occasion)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 280.h,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          image: product.image,
          name: product.name,
          price: product.price,
          oldPrice: product.oldPrice,
          discount: product.discount,
        );
      },
    );
  }
}