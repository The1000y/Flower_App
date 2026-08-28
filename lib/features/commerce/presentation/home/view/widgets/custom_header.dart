import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/constants/apps_images/app_images.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class CustomHeaderHomeView extends StatelessWidget {
  const CustomHeaderHomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 89,
          height: 25,
          child: Image.asset(AppImages.logo, fit: BoxFit.fill),
        ),
        SizedBox(width: 17),
        Expanded(
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
