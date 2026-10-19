import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../config/routing/routes.dart';
import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import '../manager/tracking_view_model.dart';

class CustomTrackingButtonsSection extends StatelessWidget {
  const CustomTrackingButtonsSection({
    super.key,
    required this.isAwaitingConfirmation,
    required this.isConfirming,
    required this.onConfirm,
  });

  final bool isAwaitingConfirmation;
  final bool isConfirming;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppStrings.showMap,
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.orderMap,
              arguments: context.read<TrackingViewModel>(),
            ),
            isEnabled: true,
            enabledColor: AppColors.pinkBase,
          ),
        ),
        if (isAwaitingConfirmation) ...[
          const Gap(8),
          Expanded(
            child: CustomButton(
              text: AppStrings.orderDeliveredAction,
              onPressed: onConfirm,
              isEnabled: true,
              isLoading: isConfirming,
              enabledColor: AppColors.pinkBase,
            ),
          ),
        ],
      ],
    );
  }
}
