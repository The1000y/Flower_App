import 'package:flower_app/features/auth/presentation/forget_password/view/widgets/custom_pin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();
    var textTheme = Theme.of(context).textTheme;
    return BlocProvider<ForgetPasswordCubit>(
      create: (context) => getIt.get<ForgetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          titleSpacing: 0,
          title: Text(
            AppStrings.passwordAppBarTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),

        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (previous, current) {
            return previous.otpState.isLoading != current.otpState.isLoading ||
                previous.resendOtpState.isLoading !=
                    current.resendOtpState.isLoading;
          },
          listener: (context, state) {
            // Verify OTP
            if (!state.otpState.isLoading) {
              if (state.otpState.errorMessage.isNotEmpty) {
                codeController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.error,
                    content: Text(state.otpState.errorMessage),
                  ),
                );
              } else if (state.otpState.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: AppColors.success,
                    content: Text("OTP verified successfully"),
                  ),
                );
              }
            }
            
            // Resend OTP
            if (!state.resendOtpState.isLoading) {
              if (state.resendOtpState.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.error,
                    content: Text(state.resendOtpState.errorMessage),
                  ),
                );
              } else if (state.resendOtpState.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: AppColors.success,
                    content: Text("Code resent successfully"),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    AppStrings.emailVerificationTitle,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.emailVerificationSubtitle,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 32),
                  CustomPinWidget(codeController: codeController, textTheme: textTheme , state: state,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


