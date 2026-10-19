import 'package:flutter/material.dart';

import '../../../core/services/url_launcher_service.dart';
import 'launch_failure_snack_bar.dart';

Future<void> phoneLauncher(
  String phoneNumber,
  BuildContext context,
  UrlLauncherService urlLauncher,
) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);

  final launched = await urlLauncher.launch(uri);

  if (!launched && context.mounted) showLaunchFailureSnackBar(context);
}
