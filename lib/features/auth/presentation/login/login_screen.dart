import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_outlined_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.loginTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomTextFormField(
              label: AppStrings.emailLabel,
              hintText: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: AppStrings.passwordLabel,
              hintText: AppStrings.passwordHint,
              obscureText: true,
              validator: AuthValidators.password,
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),

                Text(
                  'Remember me',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(AppStrings.forgetPassword),
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomButton(
              text: AppStrings.loginButton,
              onPressed: () {},
              isEnabled: false,
              enabledColor: AppColors.pinkBase,
            ),
            CustomOutlinedButton(
              text: AppStrings.continueAsGuest,
              onPressed: () {},
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: "Sign up",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.pinkBase,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    /* recognizer: (){}
                      ..onTap = () {
                        Navigate to Sign Up
                        print("recognizer");
                      },*/
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
