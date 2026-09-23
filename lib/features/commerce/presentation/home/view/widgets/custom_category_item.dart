import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/presentation/categories/navigation/categories_navigation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomCategoryWidget extends StatelessWidget {
  final CategoryEntity category;
  final int categoryIndex;
  final PersistentTabController controller;

  const CustomCategoryWidget({
    super.key,
    required this.category,
    required this.categoryIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            CategoriesNavigation.selectedIndex.value = categoryIndex;
            controller.jumpToTab(1);
          },
          child: Container(
            width: 68,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(
              category.iconUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error_outline, color: AppColors.pinkBase),
            ),
          ),
        ),
        Text(category.name),
      ],
    );
  }
}
