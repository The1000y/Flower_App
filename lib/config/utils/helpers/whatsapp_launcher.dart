import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings/app_strings.dart';
import '../../../core/themes/app_colors/app_color.dart';

Future<void> whatsAppLauncher(String phoneNumber, BuildContext context) async {
  final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  final uri = Uri.parse('https://wa.me/$cleanPhone');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    if (!context.mounted) return;

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