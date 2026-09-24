import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) =>
            previous.checkoutDetailsState != current.checkoutDetailsState ||
            previous.selectedPaymentMethod != current.selectedPaymentMethod,
        builder: (context, state) {
          if (state.checkoutDetailsState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.checkoutDetailsState.errorMessage.isNotEmpty) {
            return Center(child: Text(state.checkoutDetailsState.errorMessage));
          }
          if (state.checkoutDetailsState.data == null) {
            return const Center(child: Text(AppStrings.somethingWentWrong));
          }
          final paymentList = state.checkoutDetailsState.data!.paymentMethods;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.paymentMethod,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              for (var element in paymentList) ...[
                _PaymentOptionTile(
                  title: element.method,
                  value: element.method,
                  groupValue: state.selectedPaymentMethod,
                  onChanged: () => context.read<CheckoutCubit>().doEvent(
                    SelectPaymentMethodEvent(paymentMethod: element.method),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  const _PaymentOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String value;
  final String groupValue;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withValues(alpha: 0.27),
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: RadioListTile<String>(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: AppColors.pinkBase,
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: (selected) {
          if (selected != null) {
            onChanged();
          }
        },
      ),
    );
  }
}
