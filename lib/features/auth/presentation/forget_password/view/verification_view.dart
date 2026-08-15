import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

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
            return previous.otpState.data != current.otpState.data ||
                previous.otpState.errorMessage !=
                    current.otpState.errorMessage ||
                previous.resendOtpState.data != current.resendOtpState.data ||
                previous.resendOtpState.errorMessage !=
                    current.resendOtpState.errorMessage;
          },
          listener: (context, state) {
            if (state.otpState.errorMessage.isNotEmpty) {
              codeController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.error,
                  content: Text(state.otpState.errorMessage),
                ),
              );
            }
            if (state.otpState.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.success,
                  content: Text("OTP verified successfully"),
                ),
              );
            }

            // Resend Error
            if (state.resendOtpState.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.error,
                  content: Text(state.resendOtpState.errorMessage),
                ),
              );
            }

            // Resend Success
            if (state.resendOtpState.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.success,
                  content: Text("Code resent successfully"),
                ),
              );
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
                  Column(
                    children: [
                      Pinput(
                        controller: codeController,
                        onCompleted: (value) {
                          context.read<ForgetPasswordCubit>().doEvent(
                            VerifyOtpEvent(
                              otpCode: value,
                              email: "user@example.com",
                            ),
                          );
                        },
                        forceErrorState: state.otpState.errorMessage.isNotEmpty,
                        errorPinTheme: themeErrorPin(textTheme),
                        animationCurve: Curves.bounceInOut,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        cursor: Container(
                          width: 2,
                          height: 30,
                          color: AppColors.pinkBase,
                        ),
                        length: 6,
                        keyboardType: TextInputType.number,
                        submittedPinTheme: themeSubmittedPin(textTheme),
                        focusedPinTheme: themeFocusedPin(textTheme),
                        defaultPinTheme: themeDefautpin(textTheme),
                      ),
                      if (state.otpState.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.error_outline_outlined,
                                color: AppColors.error,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                // AppStrings.invalidCodeError,
                                state.otpState.errorMessage,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${AppStrings.didntReceiveCode} ",
                            style: textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () {
                              context.read<ForgetPasswordCubit>().doEvent(
                                ResendtOtpEvent(email: 'user@example.com'),
                              );
                            },
                            child: Text(
                              AppStrings.resendLink,
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.pinkBase,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.pinkBase,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PinTheme themeDefautpin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white60,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: textTheme.bodyLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  PinTheme themeFocusedPin(TextTheme textTheme) {
    return PinTheme(
      width: 90,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkBase.withValues(alpha: 0.2),
            blurRadius: 50,
            blurStyle: BlurStyle.outer,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      textStyle: textTheme.bodyLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.pinkBase,
      ),
    );
  }

  PinTheme themeSubmittedPin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.pinkBase,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.whiteBase,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  PinTheme themeErrorPin(TextTheme textTheme) {
    return PinTheme(
      width: 80,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error),
      ),
      textStyle: textTheme.bodyLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
