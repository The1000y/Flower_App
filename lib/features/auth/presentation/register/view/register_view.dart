import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_gender_selector.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_login_link.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_terms_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final ValueNotifier<bool> _isFemaleNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscurePasswordNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPasswordNotifier = ValueNotifier<bool>(true);

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = () {};
    _loginRecognizer = TapGestureRecognizer()..onTap = () => Navigator.pop(context);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _loginRecognizer.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _isFemaleNotifier.dispose();
    _obscurePasswordNotifier.dispose();
    _obscureConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterViewModel>().handle(
      RegisterSubmitted(
        fullName: "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        phoneNumber: _phoneController.text.trim(),
        gender: _isFemaleNotifier.value ? 1 : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, RegisterState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error));
        }
        if (state.data != null && state.data!.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(AppStrings.registerSuccess),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ));
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) Navigator.pop(context);
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.signUp, style: Theme.of(context).textTheme.titleLarge),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        label: AppStrings.firstNameLabel,
                        hintText: AppStrings.firstNameHint,
                        controller: _firstNameController,
                        validator: AuthValidators.firstName,
                      ),
                    ),
                    SizedBox(width: 17.w),
                    Expanded(
                      child: CustomTextFormField(
                        label: AppStrings.lastNameLabel,
                        hintText: AppStrings.lastNameHint,
                        controller: _lastNameController,
                        validator: AuthValidators.lastName,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomTextFormField(
                  label: AppStrings.emailLabel,
                  hintText: AppStrings.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: AuthValidators.email,
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _obscurePasswordNotifier,
                        builder: (context, obscure, child) => CustomTextFormField(
                          label: AppStrings.passwordLabel,
                          hintText: AppStrings.passwordHint,
                          controller: _passwordController,
                          obscureText: obscure,
                          validator: AuthValidators.strongPassword,
                          suffixIcon: IconButton(
                            icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => _obscurePasswordNotifier.value = !obscure,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 17.w),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _obscureConfirmPasswordNotifier,
                        builder: (context, obscure, child) => CustomTextFormField(
                          label: AppStrings.confirmPasswordLabel,
                          hintText: AppStrings.confirmPasswordHint,
                          controller: _confirmPasswordController,
                          obscureText: obscure,
                          validator: (value) => AuthValidators.confirmPassword(value, _passwordController.text),
                          suffixIcon: IconButton(
                            icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => _obscureConfirmPasswordNotifier.value = !obscure,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomTextFormField(
                  label: AppStrings.phoneNumberLabel,
                  hintText: AppStrings.phoneNumberHint,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: AuthValidators.phone,
                ),
                SizedBox(height: 24.h),
                RegisterGenderSelector(isFemaleNotifier: _isFemaleNotifier),
                SizedBox(height: 16.h),
                RegisterTermsText(recognizer: _termsRecognizer),
                SizedBox(height: 48.h),
                BlocBuilder<RegisterViewModel, RegisterState>(
                  builder: (context, state) => CustomButton(
                    text: AppStrings.signUp,
                    isEnabled: !state.isLoading,
                    isLoading: state.isLoading,
                    enabledColor: AppColors.pinkBase,
                    onPressed: () => _onSignUpPressed(context),
                  ),
                ),
                SizedBox(height: 16.h),
                RegisterLoginLink(recognizer: _loginRecognizer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
