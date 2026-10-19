import 'package:flower_app/config/utils/auth_validators.dart';

import 'package:flower_app/l10n/l10n.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_custom_text_form_field.dart';
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

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _loginRecognizer;

  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = () {};
    _loginRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.pop(context);
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
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    setState(() => _isSubmitted = true);

    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterViewModel>().handle(
      RegisterSubmitted(
        fullName:
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
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
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
        }
        if (state.data != null && state.data!.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(context.l10n.registerSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.l10n.signUp,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RegisterCustomTextFormField(
                        label: context.l10n.firstNameLabel,
                        hintText: context.l10n.firstNameHint,
                        controller: _firstNameController,
                        validator: AuthValidators.firstName,
                        forceShowErrors: _isSubmitted,
                      ),
                    ),
                    SizedBox(width: 17.w),
                    Expanded(
                      child: RegisterCustomTextFormField(
                        label: context.l10n.lastNameLabel,
                        hintText: context.l10n.lastNameHint,
                        controller: _lastNameController,
                        validator: AuthValidators.lastName,
                        forceShowErrors: _isSubmitted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                RegisterCustomTextFormField(
                  label: context.l10n.emailLabel,
                  hintText: context.l10n.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: AuthValidators.email,
                  forceShowErrors: _isSubmitted,
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RegisterCustomTextFormField(
                        label: context.l10n.passwordLabel,
                        hintText: context.l10n.passwordHint,
                        controller: _passwordController,
                        isPassword: true,
                        validator: AuthValidators.strongPassword,
                        forceShowErrors: _isSubmitted,
                      ),
                    ),
                    SizedBox(width: 17.w),
                    Expanded(
                      child: RegisterCustomTextFormField(
                        label: context.l10n.confirmPasswordLabel,
                        hintText: context.l10n.confirmPasswordHint,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        forceShowErrors: _isSubmitted,
                        validator: (value) => AuthValidators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                RegisterCustomTextFormField(
                  label: context.l10n.phoneNumberLabel,
                  hintText: context.l10n.phoneNumberHint,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: AuthValidators.phone,
                  forceShowErrors: _isSubmitted,
                ),
                SizedBox(height: 24.h),
                RegisterGenderSelector(isFemaleNotifier: _isFemaleNotifier),
                SizedBox(height: 16.h),
                RegisterTermsText(recognizer: _termsRecognizer),
                SizedBox(height: 48.h),
                BlocBuilder<RegisterViewModel, RegisterState>(
                  builder: (context, state) => CustomButton(
                    text: context.l10n.signUp,
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
