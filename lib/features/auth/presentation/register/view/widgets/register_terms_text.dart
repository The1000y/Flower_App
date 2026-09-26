import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RegisterTermsText extends StatelessWidget {
  final TapGestureRecognizer recognizer;

  const RegisterTermsText({super.key, required this.recognizer});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.blackBase),
        children: [
          const TextSpan(text: AppStrings.termsPrefix),
          TextSpan(
            text: AppStrings.termsLink,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.blackBase,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            recognizer: recognizer,
          ),
        ],
      ),
    );
  }
}
