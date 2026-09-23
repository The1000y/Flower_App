import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          BlocBuilder<CheckoutCubit, CheckoutState>(
            buildWhen: (previous, current) =>
                previous.checkoutDetailsState != current.checkoutDetailsState,
            builder: (context, state) {
              final details = state.checkoutDetailsState.data;
              return Column(
                children: [
                  _SummaryRow(
                    label: AppStrings.subTotal,
                    value: '${details?.subtotal ?? 0}${AppStrings.currencyUsd}',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: AppStrings.deliveryFee,
                    value:
                        '${details?.deliveryFee ?? 0}${AppStrings.currencyUsd}',
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.white60),
                  const SizedBox(height: 12),
                  _SummaryRow(
                    label: AppStrings.total,
                    value: '${details?.total ?? 0}${AppStrings.currencyUsd}',
                    isTotal: true,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: AppStrings.placeOrder,
            onPressed: () {},
            isEnabled: true,
            enabledColor: AppColors.pinkBase,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = isTotal
        ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
        : textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
