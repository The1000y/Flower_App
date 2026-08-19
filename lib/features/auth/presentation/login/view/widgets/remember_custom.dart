import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RememberCustom extends StatelessWidget {
  const RememberCustom({
    super.key,
    
  });


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, LoginState>(
      buildWhen: (previous, current) =>
          previous.rememberMe != current.rememberMe,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.rememberMe,
              onChanged: (value) {
                context.read<LoginViewModel>().handle(
                  RememberMeChanged(value ?? false),
                );
              },
            ),

            InkWell(
              onTap: () {
                context.read<LoginViewModel>().handle(
                  RememberMeChanged(!state.rememberMe),
                );
              },
              child: Text(
                AppStrings.rememberMe,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.forgotPassword,
                );
              },
              child: const Text(
                AppStrings.forgetPassword,
              ),
            ),
          ],
        );
      },
    );
  }
}

//spreate it and deny to rebulid it agin if any change in email or password 