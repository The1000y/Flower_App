import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHomeView extends StatefulWidget {
  const ProfileHomeView({super.key});

  @override
  State<ProfileHomeView> createState() => _ProfileHomeViewState();
}

class _ProfileHomeViewState extends State<ProfileHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileViewModel>().doEvent(FetchProfileEvent());
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.logoutDialogTitle),
        content: const Text(AppStrings.confirmLogoutSubtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !context.mounted) return;
    await getIt<SecureStorageService>().clear();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      buildWhen: (previous, current) =>
          previous.profileState != current.profileState,
      builder: (context, state) {
        final profileState = state.profileState;

        if (profileState.isLoading && profileState.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileState.data == null && profileState.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profileState.errorMessage,
                  style: const TextStyle(color: AppColors.error),
                ),
                TextButton(
                  onPressed: () => context.read<ProfileViewModel>().doEvent(
                    FetchProfileEvent(),
                  ),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: ProfileBody(
            profile: profileState.data,
            onEditProfile: () =>
                Navigator.pushNamed(context, Routes.editProfile),
            onNotification: () =>
                Navigator.pushNamed(context, Routes.notification),
            onLanguage: () =>
                Navigator.pushNamed(context, Routes.changeLanguage),
            onLogout: () => _confirmLogout(context),
          ),
        );
      },
    );
  }
}
