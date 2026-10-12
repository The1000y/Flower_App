import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../core/themes/app_colors/app_color.dart';

class CustomTrackingButtonsSection extends StatelessWidget {
  const CustomTrackingButtonsSection({
    super.key,
    required this.isDelivered,
    this.onShowMap,
    this.onDelivered,
  });

  final bool isDelivered;
  final VoidCallback? onShowMap;
  final VoidCallback? onDelivered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppStrings.showMap,
            onPressed: onShowMap,
            isEnabled: true,
            enabledColor: AppColors.pinkBase,
          ),
        ),

        if (isDelivered) ...[
          const Gap(8),
          Expanded(
            child: CustomButton(
              text: AppStrings.orderDeliveredAction,
              onPressed: onDelivered,
              isEnabled: true,
              enabledColor: AppColors.pinkBase,
            ),
          ),
        ],
      ],
    );
  }
}