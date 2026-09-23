import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftSection extends StatelessWidget {
  const GiftSection({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) =>
            previous.isGift != current.isGift ||
            previous.selectedPaymentMethod != current.selectedPaymentMethod,
        builder: (context, state) {
          return state.selectedPaymentMethod == CheckoutPaymentMethod.cash
              ? SizedBox.shrink()
              : Form(
                  key: formKey,
                  child: Column(
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
                            AppStrings.itIsAGift,
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
                          validator: (value) {
                            return AuthValidators.firstName(
                              value,
                              AppStrings.giftNameValidation,
                            );
                          },

                          hintText: AppStrings.nameLabel,
                          label: AppStrings.enterNameHint,
                          keyboardType: TextInputType.name,
                          onChanged: (value) => cubit.doEvent(
                            ChangeGiftRecipientNameEvent(name: value),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          validator: (value) => AuthValidators.phone(value),
                          hintText: AppStrings.phoneNumberLabel,
                          label: AppStrings.enterPhoneHintAlt,
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
                  ),
                );
        },
      ),
    );
  }
}
