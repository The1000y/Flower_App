import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPinTheme {
   static PinTheme themeDefautpin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
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

 static PinTheme themeFocusedPin(TextTheme textTheme) {
    return PinTheme(
      width: 90,
      height: 55,
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

 static PinTheme themeSubmittedPin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
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

 static PinTheme themeErrorPin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
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