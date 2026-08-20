import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/features/commerce/presentation/categories/dummy/appCategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TabbarviewWidget extends StatelessWidget {
  final String category;

  const TabbarviewWidget({super.key, required this.category});

  List<ProductModel> get filteredProducts {
    if (category == AppCategories.all) {
      return products;
    }

    return products.where((product) => product.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProducts = filteredProducts;

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: categoryProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 280.h,
      ),
      itemBuilder: (context, index) {
        final product = categoryProducts[index];

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
