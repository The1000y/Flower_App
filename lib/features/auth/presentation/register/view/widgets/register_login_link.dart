
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterLoginLink extends StatelessWidget {
  final TapGestureRecognizer recognizer;

  const RegisterLoginLink({super.key, required this.recognizer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(text: context.l10n.alreadyHaveAccount),
            TextSpan(
              text: ' ${context.l10n.loginTitle}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.pinkBase,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: recognizer,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
