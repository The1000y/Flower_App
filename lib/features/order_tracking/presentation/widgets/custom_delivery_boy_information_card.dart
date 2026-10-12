import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import 'custom_contract_card.dart';

class CustomDeliveryBoyInformationCard extends StatelessWidget {
  const CustomDeliveryBoyInformationCard({
    super.key,
    required this.deliveryBoyName,
    required this.deliveryBoyPhoneNumber,
    this.deliveryBoyImageURL,
  });

  final String deliveryBoyName;
  final String deliveryBoyPhoneNumber;
  final String? deliveryBoyImageURL;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.pinkBase,
          child: ClipOval(
            child: deliveryBoyImageURL == null || deliveryBoyImageURL!.isEmpty
                ? const Icon(Icons.person, size: 30)
                : Image.network(
                    deliveryBoyImageURL!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 30);
                    },
                  ),
          ),
        ),

        const Gap(16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deliveryBoyName,
              style: textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            Text(
              AppStrings.deliveryHeroSubtitle,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        CustomContractCard(phoneNumber: deliveryBoyPhoneNumber),
      ],
    );
  }
}
