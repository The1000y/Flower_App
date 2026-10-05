import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_switch_tile.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/option_tile.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    this.user,
    required this.onEditProfile,
    required this.onNotification,
    required this.onLanguage,
    required this.onLogout,
    this.unreadNotificationsCount,
    this.notificationsEnabled = true,
    this.onNotificationsChanged,
    this.profile,
  });

  final UserEntity? user;
  final ProfileEntity? profile;
  final VoidCallback onEditProfile;
  final VoidCallback onNotification;
  final VoidCallback onLanguage;
  final VoidCallback onLogout;

  final int? unreadNotificationsCount;

  final bool notificationsEnabled;

  final ValueChanged<bool>? onNotificationsChanged;

  int get _badgeCount => unreadNotificationsCount ?? 0;

  String get _badgeLabel => _badgeCount > 99 ? '99+' : '$_badgeCount';

  String get _displayName {
    final fullName = user?.fullName;
    if (fullName != null && fullName.trim().isNotEmpty) return fullName;

    final profileName =
        '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'.trim();
    return profileName;
  }

  String get _displayEmail {
    final email = user?.email ?? profile?.email;
    return email ?? '';
  }

  String? get _displayPhotoUrl {
    final photoUrl = user?.photoUrl ?? profile?.photoUrl;
    if (photoUrl == null || photoUrl.trim().isEmpty) return null;
    return photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProfileInfo(context),
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotification,
                tooltip: l10n.notificationTitle,
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                  color: Colors.black87,
                ),
              ),
              if (_badgeCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
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
                    child: Center(
                      child: Text(
                        _badgeLabel,
                        style: const TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final name = _displayName;
    final email = _displayEmail;

    final photoUrl = _displayPhotoUrl;
    final hasPhoto = photoUrl != null;

    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
          child: hasPhoto
              ? null
              : const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: onEditProfile,
              tooltip: AppLocalizations.of(context)!.editProfileTitle,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(
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
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ProfileOptionTile(
          icon: Icons.receipt_long_outlined,
          title: l10n.myOrdersTitle,
          onTap: () {},
        ),
        ProfileOptionTile(
          icon: Icons.bookmark_border_outlined,
          title: l10n.savedAddressTitle,
          onTap: () {},
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        NotificationSwitchTile(
          title: l10n.notificationTitle,
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          icon: Icons.translate_outlined,
          title: l10n.language,

          trailing: BlocBuilder<LocaleCubit, AppLanguage>(
            builder: (context, language) => Text(
              language.nativeName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.pinkBase,
              ),
            ),
          ),
          onTap: onLanguage,
        ),
        ProfileOptionTile(
          icon: Icons.info_outline,
          title: l10n.aboutUs,
          onTap: () {},
        ),
        ProfileOptionTile(
          icon: Icons.description_outlined,
          title: l10n.termsAndConditionsAlt,
          onTap: () {},
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
          onTap: onLogout,
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
