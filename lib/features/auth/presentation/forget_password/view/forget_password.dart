
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_state.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/utils/auth_validators.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

ForgotPasswordViewModel viewModel = getIt.get<ForgotPasswordViewModel>();

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.passwordAppBarTitle)),
        body: BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
          listenWhen: (previous, current) {
            return previous.forgotstate?.isLoading !=
                current.forgotstate?.isLoading;
          },
          listener: (context, state) {
            if (!(state.forgotstate?.isLoading ?? false)) {
              if (state.forgotstate?.errorMessage.isNotEmpty ?? false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.forgotstate!.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state.forgotstate?.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("OTP sent successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              //Navigator
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Center(child: Text(AppStrings.forgetPassword)),
                    SizedBox(height: 10.h),
                    Text(
                      AppStrings.forgetPasswordSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    CustomTextFormField(
                      controller: _emailController,
                      label: AppStrings.emailLabel,
                      hintText: AppStrings.emailHint,
                      validator: AuthValidators.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      isLoading: state.forgotstate?.isLoading ?? false,
                      text: AppStrings.confirmButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.doEvent(
                            ForgetBassEvent(email: _emailController.text),
                          );
                        }
                      },
                      isEnabled: !(state.forgotstate?.isLoading ?? false),
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
