import 'package:flower_app/core/extensions/date_time_extension.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
              Text(context.l10n.estimatedArrival, style: textTheme.bodyMedium),
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
