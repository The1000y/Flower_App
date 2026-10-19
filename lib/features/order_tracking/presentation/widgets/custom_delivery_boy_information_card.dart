import 'package:flutter/material.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:gap/gap.dart';

import '../../../../core/shared/app_widgets/custom_profile_image.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import 'custom_contract_card.dart';

class CustomDeliveryBoyInformationCard extends StatelessWidget {
  const CustomDeliveryBoyInformationCard({
    super.key,
    required this.deliveryBoyName,
    required this.deliveryBoyPhoneNumber,
    required this.deliveryBoyImageURL,
  });

  final String deliveryBoyName;
  final String deliveryBoyPhoneNumber;
  final String? deliveryBoyImageURL;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CustomProfileImage(profileImageURL: deliveryBoyImageURL),

        const Gap(16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deliveryBoyName,
              style: textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            Text(
              context.l10n.deliveryHeroSubtitle,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        CustomContactCard(phoneNumber: deliveryBoyPhoneNumber),
      ],
    );
  }
}
