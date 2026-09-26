import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/optionTile.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatefulWidget {
  final UserEntity? user;
  final VoidCallback onEditProfile;
  final VoidCallback onNotification;
  final VoidCallback onLanguage;
  final VoidCallback onLogout;

  const ProfileBody({
    super.key,
    required this.user,
    required this.onEditProfile,
    required this.onNotification,
    required this.onLanguage,
    required this.onLogout,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProfileInfo(),
          const SizedBox(height: 20),
          _buildProfileOptions(context),
          const SizedBox(height: 24),
          _buildVersion(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_florist,
                color: AppColors.pinkBase,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.floweryAppbarTitle,
                style: const TextStyle(
                  color: AppColors.pinkBase,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.onNotification,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                  color: Colors.black87,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    final name = widget.user?.fullName.isNotEmpty == true
        ? widget.user!.fullName
        : 'Nour';
    final email = widget.user?.email.isNotEmpty == true
        ? widget.user!.email
        : 'Nour_Mohamed@gmail.com';

    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: widget.user?.photoUrl != null &&
                  widget.user!.photoUrl!.isNotEmpty
              ? NetworkImage(widget.user!.photoUrl!)
              : null,
          child: widget.user?.photoUrl == null || widget.user!.photoUrl!.isEmpty
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: widget.onEditProfile,
              child: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLanguageName =
        context.watch<LocaleCubit>().currentLanguageName;

    return Column(
      children: [
        ProfileOptionTile(
          icon: Icons.receipt_long_outlined,
          title: l10n.myOrdersTitle,
          onTap: () {
            // orders route
          },
        ),
        ProfileOptionTile(
          icon: Icons.bookmark_border_outlined,
          title: l10n.savedAddressTitle,
          onTap: () {
            // saved address route
          },
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          leading: SizedBox(
            height: 24,
            width: 40,
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _notificationsEnabled,
                activeThumbColor: AppColors.pinkBase,
                onChanged: (val) {
                  setState(() {
                    _notificationsEnabled = val;
                  });
                },
              ),
            ),
          ),
          title: l10n.notificationTitle,
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {
              _notificationsEnabled = !_notificationsEnabled;
            });
          },
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          icon: Icons.translate_outlined,
          title: l10n.language,
          trailingText: currentLanguageName,
          trailingTextColor: AppColors.pinkBase,
          onTap: widget.onLanguage,
        ),
        ProfileOptionTile(
          icon: Icons.info_outline,
          title: l10n.aboutUs,
          onTap: () {
            // about route
          },
        ),
        ProfileOptionTile(
          icon: Icons.description_outlined,
          title: l10n.termsAndConditionsAlt,
          onTap: () {
            // terms route
          },
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          icon: Icons.logout_outlined,
          title: l10n.logout,
          trailing: const Icon(
            Icons.logout_outlined,
            size: 20,
            color: Colors.black87,
          ),
          onTap: widget.onLogout,
        ),
      ],
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Text(
      'v 6.3.0 - (446)',
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

