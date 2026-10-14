import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../config/routing/routes.dart';
import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../core/themes/app_colors/app_color.dart';

class CustomTrackingButtonsSection extends StatelessWidget {
  const CustomTrackingButtonsSection({super.key, required this.isDelivered});

  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppStrings.showMap,
            onPressed: () => Navigator.pushNamed(context, Routes.orderMap),
            isEnabled: true,
            enabledColor: AppColors.pinkBase,
          ),
        ),

        if (isDelivered) ...[
          const Gap(8),
          Expanded(
            child: CustomButton(
              text: AppStrings.orderDeliveredAction,
              onPressed: () {

              },
              isEnabled: true,
              enabledColor: AppColors.pinkBase,
            ),
          ),
        ],
      ],
    );
  }
}
