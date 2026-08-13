import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/themes/app_colors/app_color.dart';

class VerificationCodeError extends StatelessWidget {
  const VerificationCodeError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.passwordAppBarTitle)),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Center(
              child: Text(
                AppStrings.resetPasswordTitle,
                style: TextStyle(color: AppColors.black100, fontSize: 20.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              AppStrings.resetPasswordSubtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            CustomTextFormField(
              label: AppStrings.newPasswordLabel,
              hintText: AppStrings.passwordHint,
            ),
                        SizedBox(height: 20.h),
CustomTextFormField(label: AppStrings.confirmPasswordLabel, hintText: AppStrings.confirmPasswordHint),
            SizedBox(height: 30.h),
            CustomButton(
              text: AppStrings.confirmButton,
              onPressed: () {},
              isEnabled: true,
              enabledColor: AppColors.pinkBase,
            ),
          ],
        ),
      ),
    );
  }
}
