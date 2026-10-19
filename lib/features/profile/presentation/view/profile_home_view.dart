import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flower_app/config/routing/routes.dart';

import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flower_app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutDialogTitle),
        content: Text(l10n.confirmLogoutSubtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !context.mounted) return;
    await getIt<SecureStorageService>().clear();
    if (!context.mounted) return;

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      Routes.login,
      (route) => false,
    );
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
                  child: Text(context.l10n.retry),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: ProfileBody(
            profile: profileState.data,
            onEditProfile: () async {
              await Navigator.pushNamed(context, Routes.editProfile);
              if (context.mounted) {
                context.read<ProfileViewModel>().doEvent(FetchProfileEvent());
              }
            },
            onSavedAddress: () =>
                Navigator.pushNamed(context, Routes.savedAddresses),
            onNotification: () =>
                Navigator.pushNamed(context, Routes.notification),
            onLanguage: () {
              final localeCubit = context.read<LocaleCubit>();
              final nextLanguage = localeCubit.state == AppLanguage.arabic
                  ? AppLanguage.english
                  : AppLanguage.arabic;
              localeCubit.changeLanguage(nextLanguage);
            },
            onLogout: () => _confirmLogout(context),
          ),
        );
      },
    );
  }
}
