import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/shared/animations/success_tracking_animation.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        textStyle: textTheme.titleLarge,
        title: AppStrings.trackOrder,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              const Gap(32),
              const SuccessTrackingAnimation(size: 150),
              const Gap(64),
              Text(AppStrings.orderPlacedSuccess, style: textTheme.titleLarge),
              const Gap(32),
              CustomButton(
                text: AppStrings.trackOrder,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.trackOrder);
                },
                isEnabled: true,
                enabledColor: AppColors.pinkBase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
