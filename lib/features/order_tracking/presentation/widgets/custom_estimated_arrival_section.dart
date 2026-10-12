import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.estimatedArrival, style: textTheme.bodyMedium),
              const Gap(8),
              Text(
                DateFormat(
                  'd MMMM yyyy, h:mm a',
                ).format(estimatedArrivalDateTime),
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
