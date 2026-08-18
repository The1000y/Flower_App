import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
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
  bool _isFemale = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;
  bool _phoneTouched = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    setState(() {
      _firstNameTouched = true;
      _lastNameTouched = true;
      _emailTouched = true;
      _passwordTouched = true;
      _confirmPasswordTouched = true;
      _phoneTouched = true;
    });

    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterViewModel>().handle(
      RegisterSubmitted(
        fullName:
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        phoneNumber: _phoneController.text.trim(),
        gender: _isFemale ? 1 : 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterViewModel, RegisterState>(
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
                content: Text(AppStrings.registerSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;
        return Scaffold(
          backgroundColor: AppColors.whiteBase,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppStrings.signUp,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
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
                          onChanged: (_) {
                            if (!_firstNameTouched) {
                              setState(() => _firstNameTouched = true);
                            }
                          },
                          validator: (value) {
                            if (!_firstNameTouched) return null;
                            return AuthValidators.firstName(value);
                          },
                        ),
                      ),
                      SizedBox(width: 17.w),
                      Expanded(
                        child: CustomTextFormField(
                          label: AppStrings.lastNameLabel,
                          hintText: AppStrings.lastNameHint,
                          controller: _lastNameController,
                          onChanged: (_) {
                            if (!_lastNameTouched) {
                              setState(() => _lastNameTouched = true);
                            }
                          },
                          validator: (value) {
                            if (!_lastNameTouched) return null;
                            return AuthValidators.lastName(value);
                          },
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
                    onChanged: (_) {
                      if (!_emailTouched) {
                        setState(() => _emailTouched = true);
                      }
                    },
                    validator: (value) {
                      if (!_emailTouched) return null;
                      return AuthValidators.email(value);
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          label: AppStrings.passwordLabel,
                          hintText: AppStrings.passwordHint,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: (_) {
                            if (!_passwordTouched) {
                              setState(() => _passwordTouched = true);
                            }
                          },
                          validator: (value) {
                            if (!_passwordTouched) return null;
                            return AuthValidators.strongPassword(value);
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 17.w),
                      Expanded(
                        child: CustomTextFormField(
                          label: AppStrings.confirmPasswordLabel,
                          hintText: AppStrings.confirmPasswordHint,
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onChanged: (_) {
                            if (!_confirmPasswordTouched) {
                              setState(
                                () => _confirmPasswordTouched = true,
                              );
                            }
                          },
                          validator: (value) {
                            if (!_confirmPasswordTouched) return null;
                            return AuthValidators.confirmPassword(
                              value,
                              _passwordController.text,
                            );
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
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
                    onChanged: (_) {
                      if (!_phoneTouched) {
                        setState(() => _phoneTouched = true);
                      }
                    },
                    validator: (value) {
                      if (!_phoneTouched) return null;
                      return AuthValidators.phone(value);
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Text(
                        AppStrings.genderTitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayDark,
                        ),
                      ),
                      SizedBox(width: 44.w),
                      RadioGroup<bool>(
                        groupValue: _isFemale,
                        onChanged: (value) =>
                            setState(() => _isFemale = value!),
                        child: Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              activeColor: AppColors.pinkBase,
                            ),
                            Text(
                              AppStrings.female,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.blackBase),
                            ),
                            SizedBox(width: 15.5.w),
                            Radio<bool>(
                              value: false,
                              activeColor: AppColors.pinkBase,
                            ),
                            Text(
                              AppStrings.male,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.blackBase),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.blackBase,
                      ),
                      children: [
                        const TextSpan(text: AppStrings.termsPrefix),
                        TextSpan(
                          text: AppStrings.termsLink,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.blackBase,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48.h),
                  CustomButton(
                    text: AppStrings.signUp,
                    isEnabled: !isLoading,
                    isLoading: isLoading,
                    enabledColor: AppColors.pinkBase,
                    onPressed: () => _onSignUpPressed(context),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: AppStrings.alreadyHaveAccount),
                          TextSpan(
                            text: ' ${AppStrings.loginTitle}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.pinkBase,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.login,
                                );
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
