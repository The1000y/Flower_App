import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftSection extends StatelessWidget {
  const GiftSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        // selector: (state) => state.isGift,
        builder: (context, state) {
          return state.selectedPaymentMethod == CheckoutPaymentMethod.cash
              ? SizedBox.shrink()
              : Column(
                  children: [
                    Row(
                      children: [
                        Switch(
                          activeThumbColor: AppColors.white10,
                          activeTrackColor: AppColors.pinkBase,
                          inactiveThumbColor: AppColors.pinkBase,

                          value: state.isGift,
                          onChanged: (value) =>
                              cubit.doEvent(ToggleGiftEvent(isGift: value)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'It is a gift',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    if (state.isGift) ...[
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        hintText: 'Name',
                        label: 'Enter the name',
                        keyboardType: TextInputType.name,
                        onChanged: (value) => cubit.doEvent(
                          ChangeGiftRecipientNameEvent(name: value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        hintText: 'Phone number',
                        label: 'Enter the phone number',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => cubit.doEvent(
                          ChangeGiftRecipientPhoneEvent(phone: value),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 24,
                      color: AppColors.lightGray,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
