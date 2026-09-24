import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryTimeSection extends StatelessWidget {
  const DeliveryTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            AppStrings.deliveryTime,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.black100),
              Text(
                AppStrings.instant,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (previous, current) =>
                    previous.estimationTimeState != current.estimationTimeState,
                builder: (context, state) {
                  final estimatedTime =
                      state.estimationTimeState.data?.estimatedDeliveryAt ?? '';
                  return Text(
                    '${AppStrings.arriveByPrefix}$estimatedTime',
                    style: TextStyle(color: AppColors.success, fontSize: 16),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
