import 'package:flower_app/config/routing/routes.dart';

import 'package:flower_app/l10n/l10n.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: context.l10n.dontHaveAccount),
          TextSpan(
            text: context.l10n.signUp,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, Routes.signUp);
              },
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.pinkBase,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
