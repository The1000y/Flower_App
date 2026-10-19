import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../../core/themes/app_colors/app_color.dart';

/// Tells the user that an url (call, WhatsApp...) could not be opened.
void showLaunchFailureSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(context.l10n.somethingWentWrong),
        backgroundColor: AppColors.error,
      ),
    );
}
