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
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _restoreRememberedEmail();
  }

  Future<void> _restoreRememberedEmail() async {
    final saved = await context.read<LoginViewModel>().loadSavedEmail();
    if (saved != null && saved.isNotEmpty && emailcontroller.text.isEmpty) {
      emailcontroller.text = saved;
    }
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<LoginViewModel>().handle(LoginPressed());
  }

  void _onSuccessNavigate() {
    Navigator.of(context).pushReplacementNamed(Routes.mainLayout);
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: BlocConsumer<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
              if (state.data != null) {
                _onSuccessNavigate();
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: emailcontroller,
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
                      controller: passcontroller,
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
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
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
                            Navigator.of(context)
                                .pushNamed(Routes.forgotPassword);
                          },
                          child: Text(AppStrings.forgetPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppStrings.loginButton,
                      onPressed: _onLoginPressed,
                      isEnabled: !state.isLoading,
                      isLoading: state.isLoading,
                      enabledColor: AppColors.pinkBase,
                    ),
                    const SizedBox(height: 16),
                    CustomOutlinedButton(
                      text: AppStrings.continueAsGuest,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.mainLayout);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: AppStrings.dontHaveAccount),
                          TextSpan(
                            text: AppStrings.signUp,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushNamed(Routes.signUp);
                              },
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
