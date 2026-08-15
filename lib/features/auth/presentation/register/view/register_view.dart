import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

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
    setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    final String fullName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    context.read<AuthViewModel>().doEvent(
          RegisterEvent(
            fullName: fullName,
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phoneNumber: _phoneController.text.trim(),
            gender: _isFemale ? 1 : 2, // 1 for Female, 2 for Male as per API
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthViewModel>(),
      child: BlocConsumer<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state.data != null && state.data!.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.data!.message)),
            );
            // Navigate to home or login as per your route logic
            // Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
          } else if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Theme(
            data: AppThem.lightThem,
            child: Scaffold(
              backgroundColor: AppColors.whiteBase,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
                //بسيوني
                title: Text(
                  AppStrings.signUp,
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackBase,
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                            child: CustomTextFormField(
                              label: AppStrings.passwordLabel,
                              hintText: AppStrings.passwordHint,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: AuthValidators.strongPassword,
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
                              validator: (value) =>
                                  AuthValidators.confirmPassword(
                                value,
                                _passwordController.text,
                              ),
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
                        validator: AuthValidators.phone,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          //بسيوني
                          Text(
                            AppStrings.genderTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grayDark,
                                ),
                          ),
                          SizedBox(width: 44.w),
                          Radio<bool>(
                            value: true,
                            groupValue: _isFemale,
                            activeColor: AppColors.pinkBase,
                            onChanged: (value) =>
                                setState(() => _isFemale = value!),
                          ),
                          //بسيوني
                          Text(
                            AppStrings.female,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.blackBase,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                          ),
                          SizedBox(width: 15.5.w),
                          Radio<bool>(
                            value: false,
                            groupValue: _isFemale,
                            activeColor: AppColors.pinkBase,
                            onChanged: (value) =>
                                setState(() => _isFemale = value!),
                          ),
                          //بسيوني
                          Text(
                            AppStrings.male,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.blackBase,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                          ),

                          //  SizedBox(width: 55.w),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: AppColors.blackBase,
                                  ),
                          children: [
                            const TextSpan(text: AppStrings.termsPrefix),
                            TextSpan(
                              text: AppStrings.termsLink,
                              //بسيوني
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.blackBase,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontSize: 12.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // -----------------router_terms&conditions----------------
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48.h),
                      CustomButton(
                        text: AppStrings.signUp,
                        isEnabled: true,
                        isLoading: state.isLoading,
                        enabledColor: AppColors.pinkBase,
                        onPressed: () => _onSignUpPressed(context),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                    ),
                            children: [
                              const TextSpan(
                                  text: AppStrings.alreadyHaveAccount),
                              TextSpan(
                                text: ' ${AppStrings.loginTitle}',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  decorationColor: AppColors.pinkBase,
                                  color: AppColors.pinkBase,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

