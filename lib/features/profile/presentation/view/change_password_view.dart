import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final ChangePasswordCubit _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt.get<ChangePasswordCubit>();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _viewModel.close();
    super.dispose();
  }

  void _onUpdatePressed() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        _viewModel.doEvent(
          UpdatePasswordEvent(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppStrings.resetPasswordTitle,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackBase,
            ),
          ),
        ),
        body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listenWhen: (previous, current) {
            return previous.changePasswordState.isLoading !=
                current.changePasswordState.isLoading;
          },
          listener: (context, state) {
            if (!state.changePasswordState.isLoading) {
              if (state.changePasswordState.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.changePasswordState.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state.changePasswordState.data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            final isLoading = state.changePasswordState.isLoading;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.h),

                      CustomTextFormField(
                        label: AppStrings.currentPasswordLabel,
                        hintText: AppStrings.currentPasswordHint,
                        controller: _currentPasswordController,
                        validator: AuthValidators.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),

                      SizedBox(height: 20.h),

                      CustomTextFormField(
                        label: AppStrings.newPasswordLabel,
                        hintText: AppStrings.passwordHint,
                        controller: _newPasswordController,
                        validator: AuthValidators.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),

                      SizedBox(height: 20.h),

                      CustomTextFormField(
                        label: AppStrings.confirmPasswordLabel,
                        hintText: AppStrings.confirmPasswordHint,
                        controller: _confirmPasswordController,
                        validator: (value) => AuthValidators.confirmPassword(
                          value,
                          _newPasswordController.text,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),

                      SizedBox(height: 48.h),

                      CustomButton(
                        isLoading: isLoading,
                        text: AppStrings.actionUpdate,
                        onPressed: _onUpdatePressed,
                        isEnabled: !isLoading,
                        enabledColor: AppColors.gray,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
