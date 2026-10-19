import 'package:flower_app/core/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';

class CustomEstimatedArrivalSection extends StatelessWidget {
  const CustomEstimatedArrivalSection({
    super.key,
    required this.estimatedArrivalDateTime,
  });

  final DateTime estimatedArrivalDateTime;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.estimatedArrival, style: textTheme.bodyMedium),
              const Gap(8),
              Text(
                estimatedArrivalDateTime.toEstimatedArrivalFormat(),
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
