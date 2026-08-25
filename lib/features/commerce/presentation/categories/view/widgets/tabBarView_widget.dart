import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'buildSortItemfFilter.dart';

class TabbarviewWidget extends StatelessWidget {
  final String category;
  final List<ProductEntity> products;
  final String searchQuery;
  final SortType? sortType;

  const TabbarviewWidget({
    super.key,
    required this.category,
    required this.products,
    this.searchQuery = '',
    this.sortType,
  });

  List<ProductEntity> get filteredProducts {
    final query = searchQuery.trim().toLowerCase();
    final result = products.where((product) {
      final matchesCategory =
          category.toLowerCase() == 'all' ||
          _matchesCategory(product, category);
      final matchesSearch =
          query.isEmpty || product.name.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    switch (sortType) {
      case SortType.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortType.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortType.newest:
        result.sort((a, b) => b.id.compareTo(a.id));
      case SortType.recommended:
      case null:
        break;
    }
    return result;
  }

  bool _matchesCategory(ProductEntity product, String value) {
    final name = product.name.toLowerCase();
    final normalized = value.toLowerCase();
    if (normalized.contains('bouquet')) return name.contains('bouquet');
    if (normalized.contains('vase'))
      return name.contains('vase') || name.contains('pot');
    if (normalized.contains('box')) return name.contains('box');
    if (normalized.contains('jewel')) return name.contains('jewel');
    if (normalized.contains('gift')) return name.contains('gift');
    if (normalized.contains('card')) return name.contains('card');
    return false;
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
          image: product.imageUrl,
          name: product.name,
          price: product.price,
          oldPrice: product.originalPrice,
          discount: product.discountPercentage?.round(),
        );
      },
    );
  }
}
