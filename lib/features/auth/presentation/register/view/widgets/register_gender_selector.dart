import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RegisterGenderSelector extends StatelessWidget {
  final ValueNotifier<bool> isFemaleNotifier;

  const RegisterGenderSelector({super.key, required this.isFemaleNotifier});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.genderTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.grayDark,
              ),
        ),
        SizedBox(width: 44.w),
        ValueListenableBuilder<bool>(
          valueListenable: isFemaleNotifier,
          builder: (context, isFemale, child) {
            return RadioGroup<bool>(
              groupValue: isFemale,
              onChanged: (val) => isFemaleNotifier.value = val!,
              child: Row(
                children: [
                  const Radio<bool>(value: true, activeColor: AppColors.pinkBase),
                  Text(
                    AppStrings.female,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.blackBase),
                  ),
                  SizedBox(width: 15.5.w),
                  const Radio<bool>(value: false, activeColor: AppColors.pinkBase),
                  Text(
                    AppStrings.male,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.blackBase),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
