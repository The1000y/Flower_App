import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings/app_strings.dart';
import '../../../core/themes/app_colors/app_color.dart';

Future<void> phoneLauncher(String phoneNumber, BuildContext context) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
  if(await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    if(!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppStrings.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
  }
}
