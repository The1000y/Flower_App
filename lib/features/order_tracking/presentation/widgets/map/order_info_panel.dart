import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../config/routing/routes.dart';
import '../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../../../domain/entities/tracking_entity.dart';
import '../custom_delivery_boy_information_card.dart';
import '../custom_estimated_arrival_section.dart';

class OrderInfoPanel extends StatelessWidget {
  const OrderInfoPanel({super.key, required this.tracking});

  final TrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final driver = tracking.driver;
    final estimatedArrival = tracking.estimatedDeliveryAt;
    final orderId = tracking.orderId ?? '';

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (estimatedArrival != null)
                CustomEstimatedArrivalSection(
                  estimatedArrivalDateTime: estimatedArrival,
                ),
              if (driver != null) ...[
                const Gap(16),
                CustomDeliveryBoyInformationCard(
                  deliveryBoyName: driver.name ?? '',
                  deliveryBoyPhoneNumber: driver.phone ?? '',
                  deliveryBoyImageURL: driver.photoUrl,
                ),
              ],
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: AppStrings.orderDetails,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.orderDetails,
                    arguments: orderId,
                  ),
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
