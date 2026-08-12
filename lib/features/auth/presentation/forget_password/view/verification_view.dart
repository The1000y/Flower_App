import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    bool forceErrorState = true;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // backgroundColor: AppColors.success,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        titleSpacing: 0,
        title: Text(
          AppStrings.passwordAppBarTitle,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              AppStrings.emailVerificationTitle,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Text(
                textAlign: TextAlign.center,
                AppStrings.emailVerificationSubtitle,
                style: textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 32),
            Column(
              children: [
                Pinput(
                  onCompleted: (value) {},
                  forceErrorState: forceErrorState,
                  errorPinTheme: themeErrorPin(textTheme),
                  animationCurve: Curves.bounceInOut,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  cursor: Container(
                    width: 2,
                    height: 30,
                    color: AppColors.pinkBase,
                  ),
                  length: 4,
                  keyboardType: TextInputType.number,
                  submittedPinTheme: themeSubmittedPin(textTheme),
                  focusedPinTheme: themeFocusedPin(textTheme),
                  defaultPinTheme: themeDefautpin(textTheme),
                ),
                if (forceErrorState)
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
                          AppStrings.invalidCodeError,
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
                    Text(
                      AppStrings.resendLink,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.pinkBase,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.pinkBase,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PinTheme themeDefautpin(TextTheme textTheme) {
    return PinTheme(
                  width: 74,
                  height: 68,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white60,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: textTheme.bodyLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                );
  }

  PinTheme themeFocusedPin(TextTheme textTheme) {
    return PinTheme(
                  width: 78,
                  height: 72,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white50,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pinkBase.withValues(alpha: 0.2),
                        blurRadius: 50,
                        blurStyle: BlurStyle.outer,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  textStyle: textTheme.bodyLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkBase,
                  ),
                );
  }

  PinTheme themeSubmittedPin(TextTheme textTheme) {
    return PinTheme(
                  width: 74,
                  height: 68,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.pinkBase,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: textTheme.bodyLarge?.copyWith(
                    color: AppColors.whiteBase,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                );
  }

  PinTheme themeErrorPin(TextTheme textTheme) {
    return PinTheme(
                  width: 74,
                  height: 68,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.whiteBase,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error),
                  ),
                  textStyle: textTheme.bodyLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                );
  }
}
