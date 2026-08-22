import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flutter/material.dart';

class CustomCategoryWidget extends StatelessWidget {
  final CategoryEntity category;

  const CustomCategoryWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
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
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error_outline,
                color: AppColors.pinkBase,
              ),
            ),
          ),
        ),
        Text(category.name),
      ],
    );
  }
}
