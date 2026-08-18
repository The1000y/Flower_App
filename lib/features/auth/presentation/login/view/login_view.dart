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
import 'package:flower_app/features/auth/presentation/login/view/home_view.dart';
import 'package:flower_app/features/auth/presentation/login/view/widgets/remember_custom.dart';
import 'package:flower_app/features/auth/presentation/login/view/widgets/signup_wiget.dart';
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
  bool _emailEditedByUser = false;

  @override
  void initState() {
    super.initState();

    context.read<LoginViewModel>().handle(LoadRememberedEmail());
  }

  void _onLoginPressed() {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      final emailError = AuthValidators.email(emailController.text);
      final passwordError = AuthValidators.password(passwordController.text);
      final message =
          emailError ?? passwordError ?? AppStrings.invalidCredentials;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
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
        child: BlocConsumer<LoginViewModel, LoginState>(
          listener: (context, state) {
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
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.loginSuccess),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              });
            }
          },
          builder: (context, state) {
            if (!_emailEditedByUser && emailController.text != state.email) {
              emailController.text = state.email;

              emailController.selection = TextSelection.fromPosition(
                TextPosition(offset: emailController.text.length),
              );
            }

            return SingleChildScrollView(
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
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: passwordController,
                      label: AppStrings.passwordLabel,
                      hintText: AppStrings.passwordHint,
                      obscureText: obscurePassword,
                      validator: AuthValidators.password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    //rememberme
                    const RememberCustom(),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeView()),

                          // Routes.mainLayout,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SignupWiget(),
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
