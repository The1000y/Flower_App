import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
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
      child:
      BlocSelector<CheckoutCubit, CheckoutState, CheckoutPaymentMethod>(
        selector: (state) => state.selectedPaymentMethod,
        builder: (context, selected) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Payment method',style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600  ,fontSize: 18),),
              const SizedBox(height: 16),
              _PaymentOptionTile(
                title: 'Cash on delivery',
                value: CheckoutPaymentMethod.cash,
                groupValue: selected,
                onChanged: () => context.read<CheckoutCubit>().doEvent(
                  SelectPaymentMethodEvent(paymentMethod: CheckoutPaymentMethod.cash),
                )
              ),
              const SizedBox(height: 16),
              _PaymentOptionTile(
                title: 'Credit card',
                value: CheckoutPaymentMethod.creditCard,
                groupValue: selected,
                onChanged: () => context.read<CheckoutCubit>().doEvent(
                  SelectPaymentMethodEvent(paymentMethod: CheckoutPaymentMethod.creditCard),
                ),
              ),
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
  final CheckoutPaymentMethod value;
  final CheckoutPaymentMethod groupValue;
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
      child: RadioListTile<CheckoutPaymentMethod>(
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