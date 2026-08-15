import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_outlined_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    context.read<LoginViewModel>().handle(
          LoadRememberedEmail(),
        );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() != true) return;

    context.read<LoginViewModel>().handle(
          LoginPressed(),
        );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
        child: BlocConsumer<LoginViewModel, LoginState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }

            if (state.loginSuccess) {
              Navigator.pushReplacementNamed(
                context,
                Routes.mainLayout,
              );
            }
          },
          builder: (context, state) {
            /// تحديث الإيميل لو جه من Secure Storage
            if (emailController.text != state.email) {
              emailController.text = state.email;

              emailController.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: emailController.text.length,
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      label: AppStrings.emailLabel,
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      validator: AuthValidators.email,
                      onChanged: (value) {
                        context.read<LoginViewModel>().handle(
                              EmailChanged(value),
                            );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: passwordController,
                      label: AppStrings.passwordLabel,
                      hintText: AppStrings.passwordHint,
                      obscureText: obscurePassword,
                      validator: AuthValidators.password,
                      onChanged: (value) {
                        context.read<LoginViewModel>().handle(
                              PasswordChanged(value),
                            );
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: state.rememberMe,
                          onChanged: (value) {
                            context.read<LoginViewModel>().handle(
                                  RememberMeChanged(value ?? false),
                                );
                          },
                        ),
                        Text(
                          AppStrings.rememberMe,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.forgotPassword,
                            );
                          },
                          child: Text(
                            AppStrings.forgetPassword,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppStrings.loginButton,
                      onPressed: _onLoginPressed,
                      isLoading: state.isLoading,
                      isEnabled: !state.isLoading,
                      enabledColor: AppColors.pinkBase,
                    ),
                    const SizedBox(height: 16),
                    CustomOutlinedButton(
                      text: AppStrings.continueAsGuest,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.mainLayout,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: AppStrings.dontHaveAccount,
                          ),
                          TextSpan(
                            text: AppStrings.signUp,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.signUp,
                                );
                              },
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.pinkBase,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}