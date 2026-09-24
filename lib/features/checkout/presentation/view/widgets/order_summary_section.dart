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
              final isLoading = state.checkoutDetailsState.isLoading;
              if (state.checkoutDetailsState.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(state.checkoutDetailsState.errorMessage),
                );
              }
              if (!isLoading && details == null) {
                return Center(child: Text(AppStrings.somethingWentWrong));
              }
              return Column(
                children: [
                  _SummaryRow(
                    label: AppStrings.subTotal,
                    value: isLoading
                        ? LoadingCircule()
                        : Text('${details!.subtotal}${AppStrings.currencyUsd}'),
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: AppStrings.deliveryFee,
                    value: isLoading
                        ? LoadingCircule()
                        : Text(
                            '${details!.deliveryFee}${AppStrings.currencyUsd}',
                          ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.white60),
                  const SizedBox(height: 12),
                  _SummaryRow(
                    label: AppStrings.total,
                    value: isLoading
                        ? LoadingCircule()
                        : Text(
                            '${details!.total}${AppStrings.currencyUsd}',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
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

class LoadingCircule extends StatelessWidget {
  const LoadingCircule({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
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
  final Widget value;
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
        value,
      ],
    );
  }
}
