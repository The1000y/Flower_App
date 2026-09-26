import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_viewModel.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileViewModel>().doIntent(GetProfileIntent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage.isNotEmpty && state.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(state.errorMessage)),
          );
        }

        final user = state.data;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ProfileBody(
              user: user,
              onEditProfile: () {
                context.read<ProfileViewModel>().doIntent(EditProfileIntent());
                Navigator.pushNamed(context, Routes.editProfile);
              },
              onNotification: () {
                context.read<ProfileViewModel>().doIntent(NotificationIntent());
                Navigator.pushNamed(context, Routes.notification);
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
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}

