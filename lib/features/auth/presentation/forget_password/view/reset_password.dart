import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/themes/app_colors/app_color.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    super.key,
    required this.email,
    required this.otpcode,
  });

  final String email;
  final String otpcode;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

ForgetPasswordCubit viewModel = getIt.get<ForgetPasswordCubit>();

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  final _newpassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.passwordAppBarTitle),
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (previous, current) {
            return previous.resetstate.isLoading !=
                current.resetstate.isLoading;
          },
          listener: (context, state) {
            if (!(state.resetstate.isLoading  )) {
              if (state.resetstate.errorMessage.isNotEmpty  ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.resetstate.errorMessage,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state.resetstate.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Success, new password"),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigator.push(...)
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 50.h),

                    Center(
                      child: Text(
                        AppStrings.resetPasswordTitle,
                        style: TextStyle(
                          color: AppColors.black100,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      AppStrings.resetPasswordSubtitle,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20.h),

                    CustomTextFormField(
                      label: AppStrings.newPasswordLabel,
                      hintText: AppStrings.passwordHint,
                      controller: _newpassword,
                      validator: AuthValidators.password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),

                    SizedBox(height: 20.h),

                    CustomTextFormField(
                      label: AppStrings.confirmPasswordLabel,
                      hintText: AppStrings.confirmPasswordHint,
                      controller: _confirmPassword,
                      validator: AuthValidators.password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),

                    SizedBox(height: 30.h),

                    CustomButton(
                      isLoading:
                          state.resetstate.isLoading  ,
                      text: AppStrings.confirmButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_newpassword.text ==
                              _confirmPassword.text) {
                            viewModel.doEvent(
                              ResetPasswordEvent(
                                email: widget.email,
                                newPassword: _newpassword.text,
                                resetCode: widget.otpcode,
                              ),
                            );

                            
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Passwords do not match",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      isEnabled:
                          !(state.resetstate.isLoading ),
                      enabledColor: AppColors.pinkBase,
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