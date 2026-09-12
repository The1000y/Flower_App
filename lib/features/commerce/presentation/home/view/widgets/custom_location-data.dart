import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class CustomLocationData extends StatelessWidget {
  const CustomLocationData({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.addAddress);
      },
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: AppColors.black100),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              ' ${AppStrings.deliverToPrefix} 2XVP+XC - Sheikh Zayed',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.pinkBase,
            size: 24,
          ),
        ],
      ),
    );
  }
}
