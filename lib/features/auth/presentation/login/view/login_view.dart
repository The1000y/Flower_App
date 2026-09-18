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
import 'package:flower_app/features/auth/presentation/login/view/widgets/remember_custom.dart';
import 'package:flower_app/features/auth/presentation/login/view/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _emailEditedByUser = false;

  @override
  void initState() {
    super.initState();

    context.read<LoginViewModel>().handle(LoadRememberedEmail());
  }

  void _onLoginPressed() {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    context.read<LoginViewModel>().handle(LoginPressed());
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
        child: BlocListener<LoginViewModel, LoginState>(
          listener: (context, state) {
            if (!_emailEditedByUser && emailController.text != state.email) {
              emailController.text = state.email;
              emailController.selection = TextSelection.fromPosition(
                TextPosition(offset: emailController.text.length),
              );
            }

            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: AppColors.error,
                  ),
                );
            }

            if (state.loginSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.loginSuccess),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );
              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, Routes.home);
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: emailController,
                    label: AppStrings.emailLabel,
                    hintText: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      _emailEditedByUser = true;
                      context.read<LoginViewModel>().handle(
                        EmailChanged(value),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<LoginViewModel, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.obscurePassword != current.obscurePassword,
                    builder: (context, state) {
                      return CustomTextFormField(
                        controller: passwordController,
                        label: AppStrings.passwordLabel,
                        hintText: AppStrings.passwordHint,
                        obscureText: state.obscurePassword,
                        validator: AuthValidators.password,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          context.read<LoginViewModel>().handle(
                            PasswordChanged(value),
                          );
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            context.read<LoginViewModel>().handle(
                              TogglePasswordVisibility(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                   SizedBox(height: 12.h),
                  //rememberme
                  const RememberCustom(),
                   SizedBox(height: 16.h),
                  BlocBuilder<LoginViewModel, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return CustomButton(
                        text: AppStrings.loginButton,
                        onPressed: _onLoginPressed,
                        isLoading: state.isLoading,
                        isEnabled: !state.isLoading,
                        enabledColor: AppColors.pinkBase,
                      );
                    },
                  ),
                   SizedBox(height: 16.h),
                  CustomOutlinedButton(
                    text: AppStrings.continueAsGuest,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.home);
                    },
                  ),
                   SizedBox(height: 24.h),
                  SignupWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
