import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_viewModel.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/l10n/app_localizations.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage.isNotEmpty) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        }

        final user = state.data;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ProfileBody(
              user: user,
              onEditProfile: () {
                context.read<ProfileViewModel>().doIntent(EditProfileIntent());

                context.push(Routes.editProfile);
              },
              onNotification: () {
                context.read<ProfileViewModel>().doIntent(NotificationIntent());

                context.push(Routes.notification);
              },
              onLanguage: () {
                _showLanguageBottomSheet(context);
              },
              onLogout: () {
                context.read<ProfileViewModel>().doIntent(LogoutIntent());

                _showLogoutDialog(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const LanguageBottomSheet(),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.logout, textAlign: TextAlign.center),
          content: Text(
            l10n.confirmLogoutSubtitle,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.actionCancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // هنا لاحقًا تعمل ConfirmLogoutIntent
                // لما تضيف logout use case.
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}
