import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Key for the logout confirmation dialog, used by tests to assert the flow.
@visibleForTesting
const Key logoutDialogKey = Key('logout-dialog');

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

        // Full-screen error only when there is nothing to show; otherwise the
        // error is surfaced as a banner on top of the (possibly stale) data so
        // it is never silently swallowed.
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
            child: Column(
              children: [
                if (state.errorMessage.isNotEmpty)
                  _ProfileErrorBanner(message: state.errorMessage),
                Expanded(
                  child: ProfileBody(
                    user: user,
                    onEditProfile: () {
                      context.read<ProfileViewModel>().doIntent(
                        EditProfileIntent(),
                      );
                      Navigator.pushNamed(context, Routes.editProfile);
                    },
                    onNotification: () {
                      context.read<ProfileViewModel>().doIntent(
                        NotificationIntent(),
                      );
                      Navigator.pushNamed(context, Routes.notification);
                    },
                    onLanguage: () {
                      _showLanguageBottomSheet(context);
                    },
                    onLogout: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    // The sheet is pushed on the root navigator, so the inherited providers are
    // out of scope. The existing instance is re-provided explicitly.
    final localeCubit = context.read<LocaleCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider<LocaleCubit>.value(
          value: localeCubit,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const LanguageBottomSheet(),
          ),
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
          key: logoutDialogKey,
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
                _confirmLogout();
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    // The navigation/clearing side of logout is not implemented yet; the
    // intent is still dispatched so the flow is observable and testable.
    context.read<ProfileViewModel>().doIntent(LogoutIntent());
  }
}

/// Inline, non-blocking error surface used when the profile could not be
/// refreshed but previously loaded data is still available.
class _ProfileErrorBanner extends StatelessWidget {
  const _ProfileErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
