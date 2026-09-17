import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/widgets/otp_pin_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class CustomPinWidget extends StatelessWidget {
  const CustomPinWidget({
    super.key,
    required this.codeController,
    required this.textTheme, required this.state,
  });

  final TextEditingController codeController;
  final TextTheme textTheme;
 final ForgetPasswordState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Pinput(
          controller: codeController,
          onCompleted: (value) {
            context.read<ForgetPasswordCubit>().doEvent(
              VerifyOtpEvent(
                otpCode: value,
                email: "user@example.com",
              ),
            );
          },
          forceErrorState: state.otpState.errorMessage.isNotEmpty,
          errorPinTheme:OtpPinTheme.themeErrorPin(textTheme),
          animationCurve: Curves.bounceInOut,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          cursor: Container(
            width: 2,
            height: 30,
            color: AppColors.pinkBase,
          ),
          length: 6,
          keyboardType: TextInputType.number,
          submittedPinTheme: OtpPinTheme.themeSubmittedPin(textTheme),
          focusedPinTheme: OtpPinTheme.themeFocusedPin(textTheme),
          defaultPinTheme: OtpPinTheme.themeDefautpin(textTheme),
        ),
        if (state.otpState.errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.error_outline_outlined,
                  color: AppColors.error,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  // AppStrings.invalidCodeError,
                  state.otpState.errorMessage,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${AppStrings.didntReceiveCode} ",
              style: textTheme.bodyLarge,
            ),
            InkWell(
              onTap: () {
                context.read<ForgetPasswordCubit>().doEvent(
                  ResendtOtpEvent(email: 'user@example.com'),
                );
              },
              child: Text(
                AppStrings.resendLink,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.pinkBase,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.pinkBase,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

