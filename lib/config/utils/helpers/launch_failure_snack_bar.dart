import 'package:flutter/material.dart';

import '../../../core/constants/app_strings/app_strings.dart';
import '../../../core/themes/app_colors/app_color.dart';

/// Tells the user that an url (call, WhatsApp...) could not be opened.
void showLaunchFailureSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(AppStrings.somethingWentWrong),
        backgroundColor: AppColors.error,
      ),
    );
}
