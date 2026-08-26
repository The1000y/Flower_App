import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomCategoryList extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CustomCategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
         scrollCacheExtent: ScrollCacheExtent.pixels(500), scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.only(left: 16 , right: 16),
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 8,
          );
        },

        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CustomCategoryWidget(category: categories[index]);
        },
      ),
    );
  }
}

