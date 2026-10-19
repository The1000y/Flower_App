import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flower_app/config/routing/routes.dart';

import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/utils/auth_validators.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

ForgetPasswordCubit viewModel = getIt.get<ForgetPasswordCubit>();

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.passwordAppBarTitle)),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (previous, current) {
            return previous.forgotstate.isLoading !=
                current.forgotstate.isLoading;
          },
          listener: (context, state) {
            if (!(state.forgotstate.isLoading)) {
              if (state.forgotstate.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.forgotstate.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state.forgotstate.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.otpSentSuccess),
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
                    Center(child: Text(context.l10n.forgetPassword)),
                    SizedBox(height: 10.h),
                    Text(
                      context.l10n.forgetPasswordSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    CustomTextFormField(
                      controller: _emailController,
                      label: context.l10n.emailLabel,
                      hintText: context.l10n.emailHint,
                      validator: AuthValidators.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      isLoading: state.forgotstate.isLoading,
                      text: context.l10n.confirmButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.doEvent(
                            ForgetBassEvent(email: _emailController.text),
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.verificationCode,
                            arguments: {'email': _emailController.text},
                          );
                        }
                      },
                      isEnabled: !(state.forgotstate.isLoading),
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
