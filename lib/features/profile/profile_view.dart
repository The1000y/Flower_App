import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomButton(
            text: 'Saved address',
            isEnabled: true,
            enabledColor: AppColors.pinkBase,
            onPressed: () => Navigator.pushNamed(context, Routes.savedAddresses),
          ),
        ),
      ),
    );
  }
}