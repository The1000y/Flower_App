import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class CustomHeaderOfCollection extends StatelessWidget {
  const CustomHeaderOfCollection({
    super.key,
    required this.textTheme,
    required this.collectionName,
    required this.onTapViewAll,
  });

  final TextTheme textTheme;
  final String collectionName;
  final VoidCallback onTapViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          collectionName,
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: onTapViewAll,
          child: Text(
            AppStrings.viewAllLabel,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.pinkBase,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.pinkBase,
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
