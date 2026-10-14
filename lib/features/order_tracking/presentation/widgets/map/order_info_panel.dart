import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../custom_delivery_boy_information_card.dart';
import '../custom_estimated_arrival_section.dart';

class OrderInfoPanel extends StatelessWidget {
  const OrderInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomEstimatedArrivalSection(
                estimatedArrivalDateTime: DateTime(2024, 9, 3, 11),
              ),
              const Gap(16),
              CustomDeliveryBoyInformationCard(
                deliveryBoyName: 'Muhamed',
                deliveryBoyPhoneNumber: '01014194042',
                deliveryBoyImageURL:
                'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: AppStrings.orderDetails,
                  onPressed: () {},
                  isEnabled: true,
                  enabledColor: AppColors.pinkBase,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
