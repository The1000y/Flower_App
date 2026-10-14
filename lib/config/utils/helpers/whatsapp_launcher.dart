import 'package:flutter/material.dart';
import '../../../core/services/url_launcher_service.dart';
import 'launch_failure_snack_bar.dart';


Future<void> whatsAppLauncher(
  String phoneNumber,
  BuildContext context,
  UrlLauncherService urlLauncher,
) async {
  final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  final uri = Uri.parse('https://wa.me/$cleanPhone');

  final launched = await urlLauncher.launch(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!launched && context.mounted) showLaunchFailureSnackBar(context);
}
